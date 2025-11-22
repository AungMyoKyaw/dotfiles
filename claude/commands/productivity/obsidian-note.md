---
description: 'Creates production-ready Obsidian notes with automatic formatting, intelligent metadata extraction, mermaid diagrams, and Context7-powered research integration for comprehensive learning materials'
argument-hint: '[draft note content] [--research] [--exam-ready] [--depth detailed|comprehensive|expert]'
---

## Obsidian Note Creator: Study & Learning Tool

**Purpose**: Transform your rough notes into polished, comprehensive Obsidian notes with intelligent organization, research integration, and visual aids.

**The Goal**: Create notes so well-structured and complete that studying them deeply provides a strong foundation for exams and real understanding.

**Important**: Always save the generated note as a file. Default to the current directory if no vault or folder is specified. The note must exist as a file that can be opened in Obsidian or any markdown editor.

### How to Use

This command works with minimal constraints—adapt it to your needs:

```bash
# Simplest form: just your content
/obsidian-note "Your notes, ideas, or draft content..."

# Add research depth when needed
/obsidian-note --research "Topic you want deeply explored"

# Create exam-focused versions
/obsidian-note --exam-ready "Subject for study preparation"

# Visual topics benefit from diagrams
/obsidian-note --diagram "Concept or process to visualize"

# Mix and match as you see fit
/obsidian-note --research --diagram --exam-ready "Your topic"

# Control depth for your audience
/obsidian-note --depth expert "Advanced topic for specialists"
/obsidian-note --depth detailed "Accessible version for beginners"

# Organize in specific folders
/obsidian-note --vault "Learning" --folder "Biology" "Photosynthesis"

# Add custom tags for better retrieval
/obsidian-note --tags "important,urgent,revisit" "Your content"
```

**No strict rules**—use what serves your purpose. The command adapts to how you work.

### What This Command Does

Claude will process your content and can creatively:

**Research & Content**

- Optionally integrate Context7 libraries for authoritative sources (use `--research`)
- Fill gaps and add missing perspectives
- Explain concepts at different levels of detail
- Connect ideas and show relationships

**Organization & Structure**

- Create logical flow that makes sense for learning
- Extract key concepts and terminology
- Build a useful hierarchy of information
- Auto-generate tags based on content

**Visual Enhancement**

- Generate diagrams when helpful (use `--diagram`)
- Format code blocks, lists, and tables intelligently
- Highlight important definitions and examples
- Create a glossary of terms

**Metadata & Linking**

- Identify prerequisites and related topics
- Create WikiLinks for cross-connections
- Suggest how this fits into broader knowledge
- Extract dates, people, and events when relevant

**Format Options**

- Detailed: Accessible, thorough explanations
- Comprehensive: Balanced depth and breadth
- Expert: Advanced concepts and nuanced perspectives

### The AI Processing Approach

Claude will:

1. **Understand context** - What's the topic? Who's the audience? What's the goal?
2. **Research if needed** - Use Context7 to fetch current, authoritative information
3. **Organize intelligently** - Structure content for understanding and retention
4. **Add value** - Include examples, analogies, visual descriptions, connections
5. **Format appropriately** - Use markdown features to enhance readability
6. **Create visuals when helpful** - Diagrams, tables, and structured data
7. **Be creative** - Go beyond the content provided; enhance and expand thoughtfully
8. **Create and save the file** - Write the markdown file to disk in the specified location (or current directory by default)

### What You'll Get

**A markdown file** saved in your chosen location with:

- **Clear title and metadata** - Organized for Obsidian
- **Learning path** - Logical flow from basics to complexity
- **Core concepts** - Well-defined terms with context
- **Explanations** - Multiple angles and perspectives
- **Examples** - Real-world illustrations when relevant
- **Diagrams** - Visual representations (if requested or needed)
- **Connections** - Links to related topics via WikiLinks
- **Glossary** - Quick reference for terminology
- **Review section** - Bullet points for quick recall

Claude will decide what's most valuable—more examples, deeper theory, practical applications, or visual aids—based on your topic and flags.

**The file is immediately usable:**

- Open in Obsidian, VS Code, or any markdown editor
- Works with markdown viewers and note-taking apps
- Can be moved, copied, or integrated into your vault later
- Properly formatted with working links and syntax

### Why This Works for Learning

Well-structured notes support learning naturally:

- **Progressive disclosure** - Build from simple to complex at your own pace
- **Multiple formats** - Different people learn through text, visuals, examples, analogies
- **Connections** - Understanding grows when you see how ideas relate
- **Retrieval practice** - Glossaries and summary sections aid recall
- **Relevance** - Real examples and applications stick in memory
- **Organization** - Clear structure reduces cognitive load

When you use `--research`, Context7 ensures information is current and validated—particularly important for rapidly-changing fields.

When you use `--exam-ready`, Claude focuses on comprehensive, logical coverage suitable for assessment.

### Usage Patterns

**For quick notes:**

```bash
/obsidian-note "Rough thoughts on topic X"
```

Claude organizes and enhances.

**For learning prep:**

```bash
/obsidian-note --exam-ready "Topic Y"
```

Claude ensures comprehensive, logical coverage.

**For current research:**

```bash
/obsidian-note --research "New technology or concept"
```

Claude integrates the latest information from Context7.

**For visual learners:**

```bash
/obsidian-note --diagram "Process or relationship"
```

Claude creates helpful diagrams.

**For focused learning:**

```bash
/obsidian-note --depth detailed "Beginner-friendly overview"
/obsidian-note --depth expert "Advanced deep-dive"
```

Claude adjusts complexity.

**Combine flags as needed** — the command adapts to your needs, not vice versa.

### Available Flags

**`--research`** - Integrate Context7 libraries for authoritative, current information. Useful for topics that evolve quickly or need validation.

**`--exam-ready`** - Structure content for comprehensive learning coverage. Helpful when preparing for assessment or wanting complete understanding.

**`--diagram`** - Generate visual representations. Use when the topic benefits from structure visualization (processes, relationships, hierarchies).

**`--depth [detailed|comprehensive|expert]`**

- `detailed` - Accessible explanations, essential concepts, 1000-1500 words
- `comprehensive` - Balanced depth and breadth, multiple perspectives, 2000-3500 words (default)
- `expert` - Advanced theory, nuanced discussion, professional level, 3500+ words

**`--vault [path]`** - Specify which Obsidian vault to use

**`--folder [path]`** - Organize note in a specific folder structure

**`--tags [tag1,tag2]`** - Add custom tags for organization and retrieval

These are suggestions—Claude can be creative and work without them.

### Practical Examples

**Language Learning:**

```bash
/obsidian-note "French: passe compose tense, irregular verbs, usage examples"
```

**Science Topics:**

```bash
/obsidian-note --research --diagram "Cellular respiration and ATP production"
```

**History:**

```bash
/obsidian-note --research "Industrial Revolution: causes, effects, key figures"
```

**Technical Skills:**

```bash
/obsidian-note --research --exam-ready "OAuth 2.0 authentication flows"
```

**Advanced Concepts:**

```bash
/obsidian-note --depth expert --research "Quantum entanglement in modern physics"
```

**Quick Learning:**

```bash
/obsidian-note --depth detailed "Introduction to machine learning basics"
```

Claude creates well-organized, comprehensive notes from whatever you provide.

### File Creation

**The command must create a markdown file.** Here's how it works:

**Default behavior** - File saves to current directory:

```bash
/obsidian-note "Your topic"
# Creates: ./Topic-Name.md in current directory
```

**Custom vault/folder** - File saves to specified location:

```bash
/obsidian-note --vault "~/Documents/Obsidian" --folder "Learning/Biology" "Photosynthesis"
# Creates: ~/Documents/Obsidian/Learning/Biology/Photosynthesis.md
```

**Current directory with custom name** - Just use the content:

```bash
/obsidian-note "Python decorators explained"
# Creates: ./Python-Decorators-Explained.md
```

The filename is automatically generated from the topic/title, sanitized for filesystem safety. Claude will:

- Create all necessary directories if they don't exist
- Use descriptive, readable filenames
- Ensure the .md file is ready to open immediately
- Confirm the file path where it was saved

### Integration

Works seamlessly with:

- Obsidian vaults
- Markdown editors
- Git-based note management
- Mermaid diagram rendering

### Tips & Best Practices

**For best results:**

- Be specific about your topic—more detail helps Claude understand context
- Mention your audience or use case if relevant ("for college students," "for certification," "for beginners")
- Use `--research` for current events, technology, or rapidly-evolving fields
- Use `--exam-ready` when you want thorough, structured coverage
- Use `--diagram` for visual topics like processes, anatomy, or relationships
- Combine flags based on your needs—there's no single "right way"

**Iterating:**

- If the first result isn't quite right, ask Claude to adjust the depth, add more examples, or refocus on specific aspects
- Notes can be updated and regenerated to match your learning goals

**Organization:**

- Use `--folder` to keep notes organized by subject or purpose
- Use `--tags` to make notes easily discoverable later
