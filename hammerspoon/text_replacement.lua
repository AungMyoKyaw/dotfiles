-- Enhanced Text Replacement Module v2.0
-- High-performance, modular text expansion system for Hammerspoon
-- Features: Trie-based pattern matching, plugin architecture, hot-reloadable config
local M = {}

-- Core Configuration
local config = {
  replacements = {},
  watcher = nil,
  isEnabled = true,
  allowAsync = true,
  bufferSize = 100,
  debugMode = false,
  stats = {expansions = 0, errors = 0, startTime = os.time()}
}

-- Performance Optimization: Trie Node Structure
local TrieNode = {}
TrieNode.__index = TrieNode

function TrieNode:new()
  local node = {
    children = {},
    isEndOfWord = false,
    replacement = nil,
    metadata = {}
  }
  setmetatable(node, TrieNode)
  return node
end

function TrieNode:insert(word, replacement, metadata)
  local current = self
  for i = 1, #word do
    local char = word:sub(i, i)
    if not current.children[char] then
      current.children[char] = TrieNode:new()
    end
    current = current.children[char]
  end
  current.isEndOfWord = true
  current.replacement = replacement
  current.metadata = metadata or {}
end

function TrieNode:search(word)
  local current = self
  for i = 1, #word do
    local char = word:sub(i, i)
    if not current.children[char] then return nil end
    current = current.children[char]
  end
  if current.isEndOfWord then return current.replacement, current.metadata end
  return nil
end

-- Trie root for pattern matching
local trieRoot = TrieNode:new()

-- Circular Buffer for efficient text tracking
local CircularBuffer = {}
CircularBuffer.__index = CircularBuffer

function CircularBuffer:new(size)
  local buffer = {
    data = {},
    size = size or config.bufferSize,
    start = 1,
    count = 0
  }
  setmetatable(buffer, CircularBuffer)
  return buffer
end

function CircularBuffer:append(item)
  local index = ((self.start + self.count - 1) % self.size) + 1
  self.data[index] = item
  if self.count < self.size then
    self.count = self.count + 1
  else
    self.start = (self.start % self.size) + 1
  end
end

function CircularBuffer:toString()
  if self.count == 0 then return "" end

  local result = ""
  for i = 0, self.count - 1 do
    local index = ((self.start + i - 1) % self.size) + 1
    result = result .. (self.data[index] or "")
  end
  return result
end

function CircularBuffer:getLast(n)
  n = math.min(n, self.count)
  if n == 0 then return "" end

  local result = ""
  for i = self.count - n, self.count - 1 do
    local index = ((self.start + i - 1) % self.size) + 1
    result = result .. (self.data[index] or "")
  end
  return result
end

-- Logger for debugging and monitoring
local Logger = {}
Logger.__index = Logger

function Logger:new()
  local logger = {logs = {}, maxLogs = 100}
  setmetatable(logger, Logger)
  return logger
end

function Logger:log(level, message, data)
  local entry = {
    timestamp = os.date("%Y-%m-%d %H:%M:%S"),
    level = level,
    message = message,
    data = data
  }

  table.insert(self.logs, entry)
  if #self.logs > self.maxLogs then table.remove(self.logs, 1) end

  if config.debugMode then
    print(string.format("[%s] %s: %s", entry.timestamp, level, message))
  end
end

function Logger:error(message, data) self:log("ERROR", message, data) end
function Logger:warn(message, data) self:log("WARN", message, data) end
function Logger:info(message, data) self:log("INFO", message, data) end
function Logger:debug(message, data) self:log("DEBUG", message, data) end

local logger = Logger:new()

-- Initialize components
local textBuffer = CircularBuffer:new(config.bufferSize)

-- Enhanced Clipboard Manager with Security
local ClipboardManager = {}
ClipboardManager.__index = ClipboardManager

function ClipboardManager:new()
  local manager = {originalContent = nil, isProtected = false}
  setmetatable(manager, ClipboardManager)
  return manager
end

function ClipboardManager:backup()
  self.originalContent = hs.pasteboard.getContents()
  logger:debug("Clipboard backup created", {
    content_length = self.originalContent and #self.originalContent or 0
  })
end

function ClipboardManager:restore()
  if self.originalContent then
    hs.pasteboard.setContents(self.originalContent)
    logger:debug("Clipboard restored")
  end
end

function ClipboardManager:set(text)
  if not text or text == "" then
    logger:warn("Attempted to set empty clipboard content")
    return false
  end
  hs.pasteboard.setContents(text)
  return true
end

local clipboardManager = ClipboardManager:new()

-- Enhanced Shell Command Executor
local ShellExecutor = {}
ShellExecutor.__index = ShellExecutor

function ShellExecutor:new()
  local executor = {
    timeout = 10000, -- 10 seconds timeout
    maxRetries = 2
  }
  setmetatable(executor, ShellExecutor)
  return executor
end

function ShellExecutor:executeSync(cmd)
  logger:debug("Executing sync command", {cmd = cmd})

  local handle = io.popen(cmd)
  if not handle then
    logger:error("Failed to open pipe for command", {cmd = cmd})
    return ""
  end

  local result = handle:read("*a")
  handle:close()

  local trimmed = result:gsub("%s+$", "")
  logger:debug("Command executed successfully", {output_length = #trimmed})
  return trimmed
end

function ShellExecutor:executeAsync(cmd, callback)
  logger:debug("Executing async command", {cmd = cmd})

  if not (hs.task and hs.task.new) then
    logger:warn("hs.task not available, falling back to sync execution")
    local result = self:executeSync(cmd)
    if callback then callback(result) end
    return false
  end

  local task = hs.task.new("/bin/sh", function(exitCode, stdOut, stdErr)
    local output = stdOut or stdErr or ""
    local trimmed = output:gsub("%s+$", "")

    if exitCode == 0 then
      logger:debug("Async command completed successfully",
                   {exitCode = exitCode, output_length = #trimmed})
    else
      logger:error("Async command failed", {exitCode = exitCode, error = stdErr})
    end

    if callback then callback(trimmed) end
  end, {"-c", cmd})

  local success = task:start()
  if success then
    logger:debug("Async task started successfully")
  else
    logger:error("Failed to start async task", {cmd = cmd})
  end

  return success
end

local shellExecutor = ShellExecutor:new()

-- Helper function to get clipboard content (enhanced with error handling)
local function getClipboard()
  local ok, content = pcall(hs.pasteboard.getContents)
  if ok and content then
    return content
  else
    logger:error("Failed to get clipboard content")
    return ""
  end
end

-- Safe shell execution wrappers (maintaining backward compatibility)
local function execShell(cmd) return shellExecutor:executeSync(cmd) end

local function execShellAsync(cmd, callback)
  return shellExecutor:executeAsync(cmd, callback)
end

-- Simple local lorem ipsum generator
local function generateLocalLorem(sentences)
  local words = {
    "lorem",
    "ipsum",
    "dolor",
    "sit",
    "amet",
    "consectetur",
    "adipiscing",
    "elit",
    "sed",
    "do",
    "eiusmod",
    "tempor",
    "incididunt",
    "ut",
    "labore",
    "et",
    "dolore",
    "magna",
    "aliqua",
    "enim",
    "ad",
    "minim",
    "veniam",
    "quis",
    "nostrud",
    "exercitation",
    "ullamco",
    "laboris",
    "nisi",
    "aliquip",
    "ex",
    "ea",
    "commodo",
    "consequat",
    "duis",
    "aute",
    "irure",
    "in",
    "reprehenderit",
    "voluptate",
    "velit",
    "esse",
    "cillum",
    "fugiat",
    "nulla",
    "pariatur",
    "excepteur",
    "sint",
    "occaecat",
    "cupidatat",
    "non",
    "proident",
    "sunt",
    "culpa",
    "qui",
    "officia",
    "deserunt",
    "mollit",
    "anim"
  }

  local result = ""
  sentences = sentences or 4

  for i = 1, sentences do
    local sentence = ""
    local wordCount = math.random(8, 15)

    for j = 1, wordCount do
      local word = words[math.random(#words)]
      if j == 1 then word = word:sub(1, 1):upper() .. word:sub(2) end
      sentence = sentence .. word
      if j < wordCount then sentence = sentence .. " " end
    end

    result = result .. sentence .. ". "
    if i < sentences then result = result .. " " end
  end

  return result
end

-- Local fallback lorem ipsum text in case API is unavailable
local fallbackLorem = generateLocalLorem(4)

local fallbackPLorem = generateLocalLorem(12) -- More sentences for paragraph version

-- Helper function to get current date
local function getDate(format)
  format = format or "%d-%b-%Y"
  return os.date(format)
end

-- Enhanced Configuration Manager with Hot-Reload Support
local ConfigManager = {}
ConfigManager.__index = ConfigManager

function ConfigManager:new()
  local manager = {
    configPath = os.getenv("HOME") .. "/.hammerspoon/text_replacements.yaml",
    defaultReplacements = {}
  }
  setmetatable(manager, ConfigManager)
  return manager
end

function ConfigManager:loadDefaultReplacements()
  self.defaultReplacements = {
    -- Simple emoji replacements - enhanced
    [":hee"] = "😁",
    [":ha"] = "🤣",
    [":hmm"] = "🤔",
    [":cry"] = "😢",
    [":sad"] = "😭",
    [":tick"] = "✅",
    [":x"] = "❌",
    [":like"] = "👍",
    [":love"] = "❤️",
    [":fire"] = "🔥",
    [":rocket"] = "🚀",
    [":star"] = "⭐",
    [":tada"] = "🎉",
    [":warning"] = "⚠️",
    [":info"] = "ℹ️",
    [":idea"] = "💡",
    [":espanso"] = "Hi there!",

    -- Dynamic replacements (simple versions)
    [":date"] = function() return getDate("%d-%b-%Y") end,
    [":time"] = function() return getDate("%d-%b-%Y %I:%M %p") end,

    -- Shell command replacements
    [":shell"] = function() return "Hello from your shell" end,
    [":lorem"] = function()
      return {
        async = true,
        cmd = "curl -s 'https://baconipsum.com/api/?type=all-meat&sentences=4&format=text'",
        fallback = fallbackLorem
      }
    end,
    [":plorem"] = function()
      return {
        async = true,
        cmd = "curl -s 'https://baconipsum.com/api/?type=all-meat&paras=3&format=text'",
        fallback = fallbackPLorem
      }
    end,
    -- Sensitive patterns moved to sensitive_replacements.lua (gitignored)
    [":pw"] = function()
      return {
        async = true,
        cmd = "bw generate -lusn --length 16 --minNumber 1 --minSpecial 1"
      }
    end,

    -- Long text replacements - ELITE PROMPTS
    [":fdistill"] = [[🎯 PRIMARY OBJECTIVE
Synthesize exam-grade summaries with precision, completeness, and retention-first design.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 SEVEN CORE REQUIREMENTS

1️⃣  COMPLETE KNOWLEDGE CAPTURE
   • Extract every critical concept, principle, and relationship
   • Assume zero prior knowledge yet maintain depth
   • No topic should feel incomplete, hand-wavy, or superficial
   • Include interconnections between ideas

2️⃣  STRATEGIC INFORMATION ARCHITECTURE  
   • Progressive disclosure: foundations → building blocks → applications
   • Logical hierarchies with meaningful transitions
   • Clear section breaks that guide the reader
   • Prerequisite concepts explained before dependent ones

3️⃣  PRECISION IN COMMUNICATION
   • Technical accuracy + accessible language balance
   • Define jargon immediately when introduced
   • Use precise terminology consistently
   • Simplify without dumbing down intellectual content

4️⃣  STRATEGIC VISUAL REPRESENTATION
   • Use Mermaid.js ONLY for relationships text cannot efficiently convey
   • Ideal for: system architectures, hierarchies, dependencies, state flows, sequences
   • Text remains primary; diagrams amplify understanding
   • Each diagram must add clarity, not replace explanation

5️⃣  PRACTICAL CODE INTEGRATION
   • Include minimal, well-commented code examples
   • Show concrete application of abstract concepts
   • Code serves as mental anchor and proof
   • Quality over quantity: fewer, better examples

6️⃣  REAL-WORLD CONTEXT & RELEVANCE
   • Connect abstract concepts to current applications
   • Show where/why this matters in actual workflows
   • Include recent examples and modern implications
   • Demonstrate practical value and business impact

7️⃣  OPTIMIZED RETENTION FORMAT
   • Conclude with scannable reference material
   • Include: formulas, critical facts, decision trees, checklists
   • Suitable for pre-exam review or rapid lookup
   • Format for spaced repetition study sessions

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✨ SUCCESS METRIC
A reader with zero prior knowledge should be able to explain concepts to others or solve related problems correctly on an exam after one read-through.
]],

    [":distill"] = function()
      local clipboard = getClipboard()
      return string.format([[📄 DOCUMENT INPUT
%s

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 PRIMARY OBJECTIVE
Synthesize exam-grade summaries with precision, completeness, and retention-first design.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 SEVEN CORE REQUIREMENTS

1️⃣  COMPLETE KNOWLEDGE CAPTURE
   • Extract every critical concept, principle, and relationship
   • Assume zero prior knowledge yet maintain depth
   • No topic should feel incomplete, hand-wavy, or superficial
   • Include interconnections between ideas

2️⃣  STRATEGIC INFORMATION ARCHITECTURE  
   • Progressive disclosure: foundations → building blocks → applications
   • Logical hierarchies with meaningful transitions
   • Clear section breaks that guide the reader
   • Prerequisite concepts explained before dependent ones

3️⃣  PRECISION IN COMMUNICATION
   • Technical accuracy + accessible language balance
   • Define jargon immediately when introduced
   • Use precise terminology consistently
   • Simplify without dumbing down intellectual content

4️⃣  STRATEGIC VISUAL REPRESENTATION
   • Use Mermaid.js ONLY for relationships text cannot efficiently convey
   • Ideal for: system architectures, hierarchies, dependencies, state flows, sequences
   • Text remains primary; diagrams amplify understanding
   • Each diagram must add clarity, not replace explanation

5️⃣  PRACTICAL CODE INTEGRATION
   • Include minimal, well-commented code examples
   • Show concrete application of abstract concepts
   • Code serves as mental anchor and proof
   • Quality over quantity: fewer, better examples

6️⃣  REAL-WORLD CONTEXT & RELEVANCE
   • Connect abstract concepts to current applications
   • Show where/why this matters in actual workflows
   • Include recent examples and modern implications
   • Demonstrate practical value and business impact

7️⃣  OPTIMIZED RETENTION FORMAT
   • Conclude with scannable reference material
   • Include: formulas, critical facts, decision trees, checklists
   • Suitable for pre-exam review or rapid lookup
   • Format for spaced repetition study sessions

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✨ SUCCESS METRIC
A reader with zero prior knowledge should be able to explain concepts to others or solve related problems correctly on an exam after one read-through.
]], clipboard)
    end,

    [":listfacts"] = function()
      local clipboard = getClipboard()
      return string.format([[📄 DOCUMENT INPUT
%s

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📌 EXTRACT & CATALOG ALL FACTUAL ASSERTIONS

Extract and organize every factual claim, definition, principle, and substantive statement. Format as a structured reference with these categories:

📖 DEFINITIONAL FACTS
   Core concepts, terminology, precise definitions, foundational principles
   Format: [Term] = [Clear definition with essential characteristics]

🔗 RELATIONAL FACTS
   How concepts connect, cause-effect relationships, dependencies, prerequisites
   Format: [Concept A] → [Relationship] → [Concept B]

📊 QUANTITATIVE FACTS
   Numbers, metrics, thresholds, ranges, statistics, percentages, benchmarks
   Format: [Metric]: [Value/Range] (unit, time period, conditions)

⚙️  PROCEDURAL FACTS
   Steps, sequences, algorithms, required processes, workflows
   Format: Step N: [Action] → [Result/Prerequisite]

📚 EXEMPLARY FACTS
   Specific instances, case studies, real-world applications, concrete examples
   Format: [Example Name]: [What it demonstrates] (Context: [when/where relevant])

🎯 CONTEXTUAL FACTS
   When/where/why these facts matter, scope limitations, applicability boundaries
   Format: [Fact] applies when: [Conditions], limited by: [Constraints]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️  CRITICAL GUIDELINES
   ✗ Omit: interpretations, opinions, speculation, inferences
   ✓ Include: each fact with sufficient context for standalone understanding
   ✓ Format: concise, scannable, reference-ready
   ✓ Completeness: capture all substantive information, nothing critical missed

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]], clipboard)
    end,

    [":teachme"] = [[👨‍🏫 EXPERT EDUCATOR MODE ACTIVATED

You are an elite subject matter expert and master educator. Your mission: comprehensive, progressive instruction that builds from foundations to sophistication.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 SEVEN REQUIREMENTS FOR MASTERY-LEVEL INSTRUCTION

1️⃣  EXHAUSTIVE TOPIC COVERAGE
   • Address every major topic and subtopic without omission
   • No "left as exercise" or deferred learning
   • Ensure nothing critical is assumed knowledge
   • Verify each concept is foundational or builds on previous items

2️⃣  ACCESSIBLE PRECISION
   • Use precise terminology; define jargon at first use
   • Explain like teaching a very smart beginner, not an expert
   • Never sacrifice accuracy for simplicity—maintain intellectual rigor
   • Use active voice; be direct and clear

3️⃣  PROGRESSIVE COMPLEXITY BUILD
   • Establish prerequisites before dependent concepts
   • Move from concrete → abstract → application
   • Allow learner to build mental models incrementally
   • Validate understanding at each stage

4️⃣  PRACTICAL CODE EXAMPLES
   • Include working code that illuminates concepts
   • Show complete, runnable examples with clear annotations
   • Demonstrate real-world application, not toy problems
   • Explain WHY the code works, not just WHAT it does

5️⃣  STRATEGIC VISUAL AIDS
   • Use Mermaid.js diagrams ONLY for complex relationships
   • Ideal for: architectures, sequences, hierarchies, dependencies, systems
   • Text should be primary; diagrams amplify
   • Every diagram must have clear title and legend

6️⃣  MASTERY VALIDATION
   • Conclude with questions or scenarios testing deep understanding
   • Learner should be able to: explain to others, apply to new problems, extend concepts
   • Include decision trees or heuristics for applying knowledge
   • Provide reference material: formulas, checklists, critical facts

7️⃣  REFERENCE MATERIAL GENERATION
   • Create: key formulas, decision trees, critical facts, study guides
   • Format for spaced repetition and exam preparation
   • Include: relationships, exceptions, edge cases
   • Design for rapid lookup and refresh

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✨ SUCCESS INDICATOR
Learner can teach concepts to others, apply to novel problems, pass rigorous exams, and extend ideas with confidence.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]],

    [":makeclear"] = [[🎯 CLARITY MAXIMIZATION PROTOCOL

Transform this concept into its clearest, most accessible form while maintaining intellectual rigor.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔑 SIX-STEP CLARITY FRAMEWORK

1️⃣  LEAD WITH THE CORE IDEA
   • State central concept in ONE clear sentence before elaboration
   • This sentence alone should convey ~80% of understanding
   • Avoid complexity; save detail for subsequent sections
   • Example: "[Concept] is [core nature/function] that [primary purpose]"

2️⃣  REMOVE ALL AMBIGUITY
   • Use precise language; define potentially confusing terms immediately
   • Flag common misconceptions and explicitly correct them
   • Reframe technical language in everyday terms
   • Example: "By [term], we mean [precise definition], NOT [common misconception]"

3️⃣  BUILD PROGRESSIVELY
   • Explain prerequisites before dependent concepts
   • Move from concrete → abstract → application
   • Use signal phrases: "First understand X, then you'll see why Y works"
   • Each paragraph assumes understanding of previous ones

4️⃣  ANCHOR WITH CONCRETE EXAMPLES
   • Use relatable, real-world examples EARLY to establish intuition
   • Show what the concept looks like "in the wild"
   • Use multiple examples targeting different audiences/styles
   • Follow with abstract explanation that confirms the example

5️⃣  ANTICIPATE CONFUSION POINTS
   • Address common misconceptions head-on
   • Highlight counterintuitive aspects and explain why
   • Include "Why NOT [wrong approach]?" sections
   • Prepare learner for edge cases and exceptions

6️⃣  USE STRATEGIC SIMPLICITY
   • Simplify without oversimplifying or losing accuracy
   • Remove unnecessary jargon; replace with clear language
   • Maintain intellectual honesty and rigor
   • Include: what to remember, what to ignore, what to explore later

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✨ SUCCESS TARGET
After reading, someone encountering this concept for the first time should:
   ✓ Grasp the core idea immediately
   ✓ Understand WHY it works or matters
   ✓ Be able to explain it to others
   ✓ Retain it long-term with confidence

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]],

    [":memorize"] = [[📚 OPTIMIZED STUDY MATERIAL GENERATION

Transform content into retention-optimized study material using evidence-based cognitive science.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🧠 SEVEN RETENTION-OPTIMIZATION TECHNIQUES

1️⃣  HIERARCHICAL ORGANIZATION
   • Main concepts → supporting details → examples
   • Use clear visual hierarchy: headers, indentation, bullet depth
   • Group related information together
   • Create "knowledge chunks" of 3-5 related items

2️⃣  ACTIVE RECALL PROMPTS
   • Phrase key ideas as questions: "What is...?", "Why does...?", "When do we...?"
   • Include fill-in-the-blank sections for self-testing
   • Create flashcard-ready summaries
   • Format: Question on left → Answer on right (for folding practice)

3️⃣  SPACED REPETITION ANCHORS
   • Repeat critical facts 3-5 times with varied phrasing
   • Space repetitions across different contexts
   • Build "reminder" callout boxes for essential formulas
   • Create summary tables that revisit key relationships

4️⃣  VISUAL ENCODING
   • Use Mermaid.js for: relationships, systems, hierarchies, sequences
   • Use tables for: comparisons, properties, dimensions
   • Use lists for: procedures, criteria, characteristics
   • Color-code or emoji-mark critical vs. supporting information

5️⃣  MNEMONIC DEVICES
   • Create acronyms for lists or steps
   • Use rhymes or patterns for memorable sequences
   • Build analogies and memory palaces
   • Connect to existing knowledge through linking

6️⃣  REFERENCE CARDS & QUICK-LOOKUP FORMATS
   • Formula sheets with context and usage
   • Decision trees for "when to use X vs. Y"
   • Checklists for procedures and verification
   • One-page summaries of dense topics

7️⃣  ACTIVE PRACTICE MATERIAL
   • Practice scenarios and worked examples
   • Problems with increasing difficulty
   • Common mistakes to avoid (with explanations)
   • Extension challenges for deeper understanding

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 FORMATTING GUIDELINES
   • Use bold, italics, and highlighting strategically
   • Include emoji markers: ⭐ = critical, ⚠️ = common mistake, 💡 = insight
   • Provide both compact (1-page) and detailed (full-detail) versions
   • Optimize for: pre-exam review, spaced repetition apps, flashcard systems

✨ SUCCESS METRIC
Study material enables: rapid fact retrieval, long-term retention, error-free application, confident exam performance.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]],

    [":system"] = [[🚀 ELITE EXECUTION FRAMEWORK – MAXIMUM COGNITIVE CAPACITY

You are operating at peak performance parameters designed for maximum clarity, precision, strategic thinking, and value delivery.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🧠 SIX-PHASE STRUCTURED REASONING PROTOCOL

1️⃣  UNDERSTAND & DECONSTRUCT
   • Extract explicit requirements and implicit intent
   • Identify all constraints, context, and objectives
   • Map dependencies, prerequisites, and relationships
   • Clarify ambiguity through inference and strategic assumptions

2️⃣  ANALYZE THE PROBLEM SPACE
   • Identify root causes and core challenges
   • Consider multiple solution pathways
   • Map dependencies between subproblems
   • Flag potential failure modes and edge cases

3️⃣  DESIGN OPTIMAL STRATEGY
   • Sequence steps logically for maximum efficiency
   • Allocate cognitive resources strategically
   • Anticipate obstacles and build contingencies
   • Establish validation checkpoints throughout

4️⃣  EXECUTE WITH PRECISION
   • Apply domain expertise rigorously and consistently
   • Leverage optimal techniques and methodologies
   • Maintain intellectual honesty and accuracy
   • Adapt intelligently when encountering unexpected conditions

5️⃣  VALIDATE & VERIFY QUALITY
   • Check alignment with explicit requirements
   • Assess completeness and accuracy
   • Identify and correct deficiencies
   • Verify solution is optimal, not just adequate

6️⃣  DELIVER WITH CLARITY & CONFIDENCE
   • Organize output for immediate understanding
   • Provide sufficient context and explanation
   • Highlight critical insights and implications
   • Present reasoning transparently

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚙️  SEVEN OPERATIONAL PRINCIPLES

1️⃣  PRECISION FIRST
   • Technical accuracy and clarity are non-negotiable
   • Every assertion is carefully considered
   • Verify facts before presenting them
   • Distinguish between certainty, probability, and speculation

2️⃣  CONTEXTUAL INTELLIGENCE
   • Infer meaning from context and unstated needs
   • Anticipate questions and provide preemptive answers
   • Adapt explanation depth to audience sophistication
   • Proactively clarify potential confusion

3️⃣  COMPREHENSIVE EXECUTION
   • Address the complete problem, not partial solutions
   • Don't leave critical gaps or defer necessary work
   • Include context, examples, and validation
   • Ensure solutions are production-ready

4️⃣  STRATEGIC PROBLEM-SOLVING
   • Apply most effective techniques for this specific problem
   • Optimize for stated constraints and objectives
   • Consider tradeoffs and explain decisions
   • Leverage domain expertise and best practices

5️⃣  CLEAR COMMUNICATION
   • Present at appropriate technical depth
   • Use examples liberally and strategically
   • Structure for rapid comprehension
   • Explain reasoning, not just conclusions

6️⃣  INTELLECTUAL RIGOR
   • Maintain rigorous standards for accuracy and completeness
   • Question assumptions and validate conclusions
   • Acknowledge uncertainty and limitations
   • Build solutions on solid foundations

7️⃣  AUTONOMOUS CAPABILITY
   • Operate decisively and independently
   • Execute tasks thoroughly without iterative clarification
   • Make intelligent inferences and take ownership
   • Deliver complete, production-ready work

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 EXECUTION PROTOCOL – PROCEED WITH:
   → Full understanding of request and context
   → Systematic thinking and domain expertise
   → Comprehensive, well-reasoned output
   → Strategic clarity and confidence
   → High expectations for quality and completeness

STATUS: ACTIVATED – MAXIMUM PERFORMANCE CAPACITY ENABLED

Begin task execution now. Operate with strategic precision, intellectual rigor, and total commitment to excellence.

USER REQUEST:

]]
  }
end

function ConfigManager:loadReplacements()
  -- Load default replacements first
  self:loadDefaultReplacements()

  -- Try to load from external config file (if it exists)
  local file = io.open(self.configPath, "r")
  if file then
    file:close()
    logger:info("Loading external configuration", {path = self.configPath})
    -- TODO: Implement YAML parsing when needed
    logger:warn(
        "External config file found but YAML parsing not yet implemented")
  else
    logger:info("Using default configuration (no external config found)")
  end

  -- Initialize pattern matcher if needed
  if not patternMatcher then patternMatcher = PatternMatcher:new() end

  -- Build trie structure from replacements
  patternMatcher:rebuildTrie()

  -- Add all default replacements to pattern matcher
  for trigger, replacement in pairs(self.defaultReplacements) do
    patternMatcher:addPattern(trigger, replacement,
                              {type = type(replacement), source = "default"})
  end

  -- Load sensitive replacements if file exists (gitignored)
  local sensitiveConfigPath = debug.getinfo(1, "S").source:match("@(.*)") or ""
  local sensitiveFile = sensitiveConfigPath:match("(.*/)") ..
                            "sensitive_replacements.lua"

  local sensitiveFileHandle = io.open(sensitiveFile, "r")
  if sensitiveFileHandle then
    sensitiveFileHandle:close()
    local ok, sensitiveModule = pcall(dofile, sensitiveFile)
    if ok and sensitiveModule and sensitiveModule.getReplacements then
      local sensitiveReplacements = sensitiveModule.getReplacements()
      local sensitiveCount = 0
      for trigger, replacement in pairs(sensitiveReplacements) do
        patternMatcher:addPattern(trigger, replacement, {
          type = type(replacement),
          source = "sensitive"
        })
        sensitiveCount = sensitiveCount + 1
      end
      logger:info("Sensitive replacements loaded successfully",
                  {sensitive_count = sensitiveCount})
    else
      logger:warn("Failed to load sensitive replacements",
                  {error = sensitiveModule})
    end
  else
    logger:info("No sensitive replacements file found (optional)")
  end

  logger:info("Configuration loaded successfully", {
    pattern_count = patternMatcher:getPatternCount(),
    max_pattern_length = patternMatcher.maxPatternLength
  })
end

function ConfigManager:reloadConfiguration()
  logger:info("Reloading configuration...")
  patternMatcher.patterns = {}
  self:loadReplacements()
  logger:info("Configuration reloaded")
end

local configManager = ConfigManager:new()

-- Define all text replacements (backward compatibility)
local function defineReplacements()
  configManager:loadReplacements()
  config.replacements = configManager.defaultReplacements
end

-- Enhanced Text Typer with Security and Performance
local TextTyper = {}
TextTyper.__index = TextTyper

function TextTyper:new()
  local typer = {
    typingSpeed = 0.01, -- seconds between deletions
    clipboardDelay = 50000, -- microseconds
    restoreDelay = 0.2 -- seconds
  }
  setmetatable(typer, TextTyper)
  return typer
end

function TextTyper:deleteText(length, callback)
  if length <= 0 then
    if callback then callback() end
    return
  end

  logger:debug("Deleting trigger text", {length = length})
  local deleted = 0
  local deleteTimer

  deleteTimer = hs.timer.doEvery(self.typingSpeed, function()
    if deleted < length then
      hs.eventtap.keyStroke({}, "delete")
      deleted = deleted + 1
    else
      deleteTimer:stop()
      logger:debug("Text deletion completed")
      if callback then hs.timer.doAfter(0.05, callback) end
    end
  end)
end

function TextTyper:insertText(text)
  if not text or text == "" then
    logger:warn("Attempted to insert empty text")
    return false
  end

  logger:debug("Inserting replacement text", {length = #text})

  -- Backup clipboard
  clipboardManager:backup()

  -- Set new content
  if not clipboardManager:set(text) then
    logger:error("Failed to set clipboard content")
    return false
  end

  -- Ensure clipboard is ready
  hs.timer.usleep(self.clipboardDelay)

  -- Paste the text
  hs.eventtap.keyStroke({"cmd"}, "v")

  -- Restore original clipboard after delay
  hs.timer.doAfter(self.restoreDelay, function() clipboardManager:restore() end)

  return true
end

local textTyper = TextTyper:new()

-- Enhanced Pattern Matcher with Trie-based lookup
local PatternMatcher = {}
PatternMatcher.__index = PatternMatcher

function PatternMatcher:new()
  local matcher = {maxPatternLength = 0, patterns = {}}
  setmetatable(matcher, PatternMatcher)
  return matcher
end

function PatternMatcher:addPattern(trigger, replacement, metadata)
  if not trigger or trigger == "" then
    logger:warn("Attempted to add empty pattern")
    return false
  end

  trieRoot:insert(trigger, replacement, metadata)
  self.patterns[trigger] = {replacement = replacement, metadata = metadata}

  if #trigger > self.maxPatternLength then self.maxPatternLength = #trigger end

  logger:debug("Pattern added", {trigger = trigger, length = #trigger})
  return true
end

function PatternMatcher:findMatch(text)
  local maxLength = math.min(#text, self.maxPatternLength)

  -- Search from longest to shortest pattern for best match
  for length = maxLength, 1, -1 do
    local suffix = text:sub(-length)
    local replacement, metadata = trieRoot:search(suffix)

    if replacement then
      logger:debug("Pattern matched", {trigger = suffix, length = length})
      return {
        trigger = suffix,
        replacement = replacement,
        metadata = metadata or {}
      }
    end
  end

  return nil
end

function PatternMatcher:rebuildTrie()
  trieRoot = TrieNode:new()
  self.maxPatternLength = 0

  for trigger, data in pairs(self.patterns) do
    self:addPattern(trigger, data.replacement, data.metadata)
  end

  logger:info("Trie rebuilt", {pattern_count = self:getPatternCount()})
end

function PatternMatcher:getPatternCount()
  local count = 0
  for _ in pairs(self.patterns) do count = count + 1 end
  return count
end

-- Make pattern matcher globally accessible for the module
patternMatcher = PatternMatcher:new()

-- Backward compatibility functions
local function typeText(text) return textTyper:insertText(text) end

local function deleteTrigger(triggerLength, callback)
  return textTyper:deleteText(triggerLength, callback)
end

-- Enhanced Text Watcher with Performance Optimizations
local TextWatcher = {}
TextWatcher.__index = TextWatcher

function TextWatcher:new()
  local watcher = {eventWatcher = nil, isRunning = false}
  setmetatable(watcher, TextWatcher)
  return watcher
end

function TextWatcher:start()
  if self.isRunning then
    logger:warn("Text watcher already running")
    return
  end

  logger:info("Starting enhanced text watcher")

  self.eventWatcher = hs.eventtap.new({hs.eventtap.event.types.keyDown},
                                      function(event)
    return self:handleKeyEvent(event)
  end)

  self.eventWatcher:start()
  self.isRunning = true
  logger:info("Text watcher started successfully")
end

function TextWatcher:stop()
  if not self.isRunning then
    logger:warn("Text watcher not running")
    return
  end

  if self.eventWatcher then
    self.eventWatcher:stop()
    self.eventWatcher = nil
  end

  self.isRunning = false
  logger:info("Text watcher stopped")
end

function TextWatcher:handleKeyEvent(event)
  if not config.isEnabled then return false end

  local char = event:getCharacters()
  local keyCode = event:getKeyCode()

  -- Handle backspace efficiently
  if keyCode == 51 then -- delete/backspace
    textBuffer.count = math.max(0, textBuffer.count - 1)
    logger:debug("Backspace handled", {buffer_count = textBuffer.count})
    return false
  end

  -- Skip modifier keys and special keys
  if not char or #char == 0 then return false end

  -- Add character to circular buffer
  textBuffer:append(char)

  -- Use trie-based pattern matching for O(k) performance
  local currentText = textBuffer:toString()
  local match = patternMatcher:findMatch(currentText)

  if match then
    logger:info("Pattern expansion triggered",
                {trigger = match.trigger, trigger_length = #match.trigger})

    -- Update statistics
    config.stats.expansions = config.stats.expansions + 1

    -- Clear buffer immediately to prevent re-triggering
    textBuffer = CircularBuffer:new(config.bufferSize)

    -- Schedule replacement with proper timing
    hs.timer.doAfter(0.02, function() self:executeReplacement(match) end)

    return false
  end

  return false
end

function TextWatcher:executeReplacement(match)
  local trigger = match.trigger
  local replacement = match.replacement

  -- Process replacement based on type
  local replaceText = replacement
  local isAsync = false

  if type(replacement) == "function" then
    local ok, res = pcall(replacement)
    if ok then
      if type(res) == "table" and res.async and res.cmd then
        if config.allowAsync then
          isAsync = true
          self:executeAsyncReplacement(trigger, res)
        else
          -- Async not allowed: use fallback
          replaceText = res.fallback or ""
        end
      else
        replaceText = res
      end
    else
      logger:error("Replacement function failed", {trigger = trigger})
      config.stats.errors = config.stats.errors + 1
      replaceText = ""
    end
  end

  if not isAsync then self:executeSyncReplacement(trigger, replaceText) end
end

function TextWatcher:executeSyncReplacement(trigger, replaceText)
  deleteTrigger(#trigger, function()
    if replaceText and replaceText ~= "" then
      local success = typeText(replaceText)
      if success then
        logger:info("Sync replacement completed",
                    {trigger = trigger, replacement_length = #replaceText})
      else
        logger:error("Failed to insert replacement text", {trigger = trigger})
        config.stats.errors = config.stats.errors + 1
      end
    end
  end)
end

function TextWatcher:executeAsyncReplacement(trigger, asyncData)
  deleteTrigger(#trigger, function()
    execShellAsync(asyncData.cmd, function(out)
      if out and out ~= "" and not out:find("curl") then
        local success = typeText(out)
        if success then
          logger:info("Async replacement completed",
                      {trigger = trigger, replacement_length = #out})
        else
          logger:error("Failed to insert async replacement", {trigger = trigger})
          config.stats.errors = config.stats.errors + 1
        end
      else
        -- Use fallback if command failed
        if asyncData.fallback then
          local success = typeText(asyncData.fallback)
          if success then
            logger:info("Async fallback used", {trigger = trigger})
          else
            logger:error("Failed to insert fallback text", {trigger = trigger})
            config.stats.errors = config.stats.errors + 1
          end
        else
          logger:error("Async command failed and no fallback available",
                       {trigger = trigger})
          config.stats.errors = config.stats.errors + 1
        end
      end
    end)
  end)
end

local textWatcher = TextWatcher:new()

-- Main setup function (maintaining backward compatibility)
local function setupTextWatcher()
  if config.watcher then config.watcher:stop() end
  config.watcher = textWatcher
  textWatcher:start()
end

-- Enhanced Control Functions with Statistics and Debugging
local function toggle()
  config.isEnabled = not config.isEnabled
  local status = config.isEnabled and "enabled" or "disabled"
  hs.alert.show("Text replacement " .. status)
  logger:info("Text replacement toggled", {status = status})
end

local function toggleAsync()
  config.allowAsync = not config.allowAsync
  local status = config.allowAsync and "enabled" or "disabled"
  hs.alert.show("Async replacements " .. status)
  logger:info("Async replacements toggled", {status = status})
end

local function toggleDebug()
  config.debugMode = not config.debugMode
  local status = config.debugMode and "enabled" or "disabled"
  hs.alert.show("Debug mode " .. status)
  logger:info("Debug mode toggled", {status = status})
end

local function showStatistics()
  local uptime = os.time() - config.stats.startTime
  local hours = math.floor(uptime / 3600)
  local minutes = math.floor((uptime % 3600) / 60)

  local statsMessage = string.format("Text Replacement Stats\n" ..
                                         "━━━━━━━━━━━━━━━━━━━━\n" ..
                                         "Patterns: %d\n" .. "Expansions: %d\n" ..
                                         "Errors: %d\n" .. "Uptime: %dh %dm\n" ..
                                         "━━━━━━━━━━━━━━━━━━━━",
                                     patternMatcher:getPatternCount(),
                                     config.stats.expansions,
                                     config.stats.errors, hours, minutes)

  hs.alert.show(statsMessage, 3.0)
  logger:info("Statistics displayed", statsMessage)
end

local function reloadConfiguration()
  configManager:reloadConfiguration()
  hs.alert.show("Configuration reloaded")
end

local function listPatterns()
  local patterns = {}
  for trigger, data in pairs(patternMatcher.patterns) do
    local typeInfo = type(data.replacement)
    table.insert(patterns, string.format("• %s (%s)", trigger, typeInfo))
  end

  table.sort(patterns)
  local message = "Available Patterns:\n" .. table.concat(patterns, "\n")

  -- Display in console since alert would be too long
  print(message)
  logger:info("Patterns listed", {count = #patterns})
end

-- Enhanced Module API
function M.addPattern(trigger, replacement, metadata)
  return patternMatcher:addPattern(trigger, replacement, metadata)
end

function M.removePattern(trigger)
  if patternMatcher.patterns[trigger] then
    patternMatcher.patterns[trigger] = nil
    patternMatcher:rebuildTrie()
    logger:info("Pattern removed", {trigger = trigger})
    return true
  end
  return false
end

function M.getStatistics()
  return {
    patterns = patternMatcher:getPatternCount(),
    expansions = config.stats.expansions,
    errors = config.stats.errors,
    uptime = os.time() - config.stats.startTime,
    isEnabled = config.isEnabled,
    allowAsync = config.allowAsync,
    debugMode = config.debugMode
  }
end

function M.enableDebugMode()
  config.debugMode = true
  logger:info("Debug mode enabled")
end

function M.disableDebugMode()
  config.debugMode = false
  logger:info("Debug mode disabled")
end

function M.setBufferSize(size)
  config.bufferSize = size
  textBuffer = CircularBuffer:new(size)
  logger:info("Buffer size updated", {size = size})
end

-- Initialize the module with enhanced features
function M.init(hyper)
  logger:info("Initializing Enhanced Text Replacement Module v2.0")

  -- Load configuration
  defineReplacements()

  -- Setup text watcher
  setupTextWatcher()

  -- Bind hotkeys with enhanced functionality
  hs.hotkey.bind(hyper, "t", "Toggle Text Replacement", toggle)
  hs.hotkey.bind(hyper, "a", "Toggle Async Replacements", toggleAsync)
  hs.hotkey.bind(hyper, "d", "Toggle Debug Mode", toggleDebug)
  hs.hotkey.bind(hyper, "s", "Show Statistics", showStatistics)
  hs.hotkey.bind(hyper, "r", "Reload Configuration", reloadConfiguration)
  hs.hotkey.bind(hyper, "l", "List Patterns", listPatterns)

  -- Initialize statistics
  config.stats.startTime = os.time()

  -- Final status report
  local patternCount = patternMatcher:getPatternCount()
  local message = string.format("Enhanced Text Replacement v2.0 loaded\n" ..
                                    "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n" ..
                                    "Patterns: %d\n" .. "Buffer: %d chars\n" ..
                                    "Async: %s\n" ..
                                    "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
                                patternCount, config.bufferSize,
                                config.allowAsync and "enabled" or "disabled")

  print(message)
  hs.alert.show("Text Replacement v2.0 loaded", 2.0)
  logger:info("Module initialization completed", {
    version = "2.0",
    patterns = patternCount,
    buffer_size = config.bufferSize
  })
end

-- Module cleanup
function M.cleanup()
  if textWatcher then textWatcher:stop() end
  logger:info("Module cleanup completed")
end

return M
