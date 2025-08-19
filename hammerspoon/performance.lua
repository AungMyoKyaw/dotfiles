-- hammerspoon/performance.lua
-- Lightweight performance helpers: menubar CPU/memory, caffeinate on external display+AC,
-- Activity Monitor launcher, and a safe top-process inspector.
local obj = {}
local hyper = {"cmd", "alt", "ctrl", "shift"}
-- Compact menubar mode: show small icon instead of full text
local compactMode = true
local monitoringEnabled = true

-- Config
local sampleInterval = 5 -- seconds
local cpuAlertThreshold = 85 -- percent
local memoryAlertThreshold = 90 -- percent of physical memory

local menubar = hs.menubar.new()
local cpuTimer = nil

-- Helpers
local function formatPercent(n) return
    string.format("%d%%", math.floor(n + 0.5)) end

-- Helper to retrieve CPU and memory stats (so menu and updater can share)
local function getStats()
  local cpu = hs.host.cpuUsage()
  -- Memory computation similar to updateMenubar
  local mem = hs.host.vmStat()
  local totalBytes = nil
  if hs.host.physicalMemory and type(hs.host.physicalMemory) == "function" then
    totalBytes = hs.host.physicalMemory()
  else
    local ok, out = pcall(hs.execute, "sysctl -n hw.memsize")
    totalBytes = tonumber(out) or 0
  end
  local pageSize = tonumber((hs.execute("sysctl -n hw.pagesize") or "4096")) or
                       4096
  local freePages = 0
  local inactivePages = 0
  local ok, vmout = pcall(hs.execute, "vm_stat")
  if ok and vmout then
    local freeMatch = vmout:match("Pages free:%s+(%d+)")
    local inactiveMatch = vmout:match("Pages inactive:%s+(%d+)")
    freePages = tonumber(freeMatch) or 0
    inactivePages = tonumber(inactiveMatch) or 0
  else
    freePages = (mem.free and tonumber(mem.free)) or 0
    inactivePages = (mem.inactive and tonumber(mem.inactive)) or 0
  end
  local freeBytes = (freePages + inactivePages) * pageSize
  local usedPercent = 0
  if totalBytes > 0 then
    usedPercent = ((totalBytes - freeBytes) / totalBytes) * 100
  end
  return cpu.overall.active, usedPercent
end

local function updateMenubar()
  if not monitoringEnabled then
    menubar:setTitle(compactMode and "⚡ (off)" or "MONITOR OFF")
    return
  end
  local cpuActive, usedPercent = getStats()
  if compactMode then
    -- small icon-only representation
    menubar:setTitle("⚡")
    menubar:setTooltip(string.format("CPU %s | MEM %s",
                                     formatPercent(cpuActive),
                                     formatPercent(usedPercent)))
  else
    local title = string.format("CPU %s | MEM %s", formatPercent(cpuActive),
                                formatPercent(usedPercent))
    menubar:setTitle(title)
    menubar:setTooltip(nil)
  end

  -- Alerts
  if cpuActive >= cpuAlertThreshold then
    hs.notify.new({
      title = "High CPU",
      informativeText = string.format("CPU at %s", formatPercent(cpuActive))
    }):send()
  end
  if usedPercent >= memoryAlertThreshold then
    hs.notify.new({
      title = "High Memory",
      informativeText = string.format("Memory at %s", formatPercent(usedPercent))
    }):send()
  end
end

local function startMonitoring()
  if cpuTimer then return end
  updateMenubar()
  cpuTimer = hs.timer.doEvery(sampleInterval, updateMenubar)
end

local function stopMonitoring()
  if cpuTimer then
    cpuTimer:stop()
    cpuTimer = nil
  end
  monitoringEnabled = false
  -- keep menubar but mark as off
  if menubar then
    menubar:setTitle(compactMode and "⚡ (off)" or "MONITOR OFF")
  end
end

-- Auto caffeinate when external display connected and AC power
local function checkCaffeinateOnDisplay()
  local screens = hs.screen.allScreens()
  local hasExternal = #screens > 1
  local power = hs.battery.powerSource() -- "AC Power" or "Battery Power" or nil
  if hasExternal and power == "AC Power" then
    hs.caffeinate.set("displayIdle", true)
    hs.alert.show("Auto Caffeinate: ON (external display + AC)")
  else
    hs.caffeinate.set("displayIdle", false)
  end
end

-- Activity Monitor launcher
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "A",
               function() hs.application.launchOrFocus("Activity Monitor") end)

-- Top-process inspector (safe: chooser + optional kill)
local function showTopProcessesChooser()
  local choices = {}
  local ok, out = hs.execute("ps -Ao pid,pcpu,pmem,comm --sort=-pcpu", true)
  if ok and out then
    local i = 0
    for line in out:gmatch("([^\n]+)\n") do
      i = i + 1
      if i == 1 then goto continue end -- header
      local pid, pcpu, pmem, cmd = line:match(
                                       "%s*(%d+)%s+([%d%.]+)%s+([%d%.]+)%s+(.+)")
      if pid and cmd and i <= 21 then
        table.insert(choices, {
          text = string.format("%s — %s%% CPU %s%% MEM", pid, pcpu, pmem),
          subText = cmd,
          pid = pid
        })
      end
      ::continue::
    end
  end
  local chooser = hs.chooser.new(function(choice)
    if not choice then return end
    local pid = choice.pid
    hs.alert.show(string.format("Kill PID %s? (Press OK to send SIGTERM)", pid),
                  {}, hs.alert.defaultStyle, 3)
    hs.execute("kill -15 " .. pid)
  end)
  chooser:choices(choices)
  chooser:placeholderText("Top CPU processes (select to SIGTERM)")
  chooser:show()
end

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "K", function()
  local procs = hs.processInfo("all")
  showTopProcessesChooser()
end)

-- Watchers
local screenWatcher = hs.screen.watcher.new(
                          function() checkCaffeinateOnDisplay() end)
local powerWatcher = hs.battery.watcher.new(
                         function() checkCaffeinateOnDisplay() end)

-- Build menubar menu (shows full stats and actions)
local function buildMenu()
  local cpuActive, usedPercent = getStats()
  local menu = {
    {
      title = string.format("CPU: %s", formatPercent(cpuActive)),
      disabled = true
    },
    {
      title = string.format("Memory: %s", formatPercent(usedPercent)),
      disabled = true
    },
    {title = "-"},
    {
      title = monitoringEnabled and "Stop Monitoring" or "Start Monitoring",
      fn = function()
        if monitoringEnabled then
          stopMonitoring()
        else
          monitoringEnabled = true
          startMonitoring()
        end
      end
    },
    {
      title = "Open Activity Monitor",
      fn = function() hs.application.launchOrFocus("Activity Monitor") end
    },
    {
      title = "Top CPU processes...",
      fn = function() showTopProcessesChooser() end
    },
    {title = "-"},
    {
      title = "Toggle compact display (Hyper+P)",
      fn = function()
        compactMode = not compactMode
        updateMenubar()
      end
    }
  }
  return menu
end

-- Set initial menubar menu
menubar:setMenu(buildMenu)

-- Toggle compact display hotkey: Hyper+P
hs.hotkey.bind(hyper, "p", function()
  compactMode = not compactMode
  updateMenubar()
end)

function obj.start()
  startMonitoring()
  screenWatcher:start()
  powerWatcher:start()
  checkCaffeinateOnDisplay()
end

function obj.stop()
  stopMonitoring()
  screenWatcher:stop()
  powerWatcher:stop()
end

-- Start automatically
obj.start()

return obj
