-- hammerspoon/performance.lua
-- Lightweight performance helpers: menubar CPU/memory, caffeinate on external display+AC,
-- Activity Monitor launcher, and a safe top-process inspector.
local obj = {}
-- Compact menubar mode: show small icon instead of full text
local compactMode = true
local monitoringEnabled = true

-- Config
local sampleInterval = 5 -- seconds
local cpuAlertThreshold = 85 -- percent
local memoryAlertThreshold = 90 -- percent of physical memory
local alertsEnabled = false -- Set to false to disable notifications
local alertCooldown = 300 -- Seconds (e.g., 300 = 5 minutes)

local menubar = hs.menubar.new()
local cpuTimer = nil
local lastCpuAlertTime = 0
local lastMemAlertTime = 0

-- Helpers
local function formatPercent(n) return
    string.format("%d%%", math.floor(n + 0.5)) end

-- Helper to show a standard, less-intrusive notification
local function showNotification(title, message)
  hs.notify.new({title = title, informativeText = message}):send()
end

-- Helper to retrieve CPU and memory stats (reverted to original robust implementation)
local function getStats()
  local cpu = hs.host.cpuUsage()
  -- Memory computation
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
    menubar:setTitle(hs.styledtext.new(compactMode and "⚡ (off)" or
                                           "MONITOR OFF"))
    return
  end
  local cpuActive, usedPercent = getStats()

  local highCpu = cpuActive >= cpuAlertThreshold
  local highMem = usedPercent >= memoryAlertThreshold

  -- Use a subtle color to indicate high usage in the menubar
  local statusColor
  if highCpu or highMem then
    statusColor = {red = 0.9, green = 0.4, blue = 0.4} -- A noticeable but not jarring red
  end

  -- Add caffeinate status to menubar
  local caffeinateStatus = ""
  if hs.caffeinate.get("displayIdle") then caffeinateStatus = " ☕" end

  if compactMode then
    local styledTitle = hs.styledtext.new("⚡" .. caffeinateStatus,
                                          {color = statusColor})
    menubar:setTitle(styledTitle)
    menubar:setTooltip(string.format("CPU %s | MEM %s | Click for menu",
                                     formatPercent(cpuActive),
                                     formatPercent(usedPercent)))
  else
    local cpuColor = highCpu and statusColor or nil
    local memColor = highMem and statusColor or nil
    local cpuText = hs.styledtext.new(string.format("CPU %s",
                                                    formatPercent(cpuActive)),
                                      {color = cpuColor})
    local memText = hs.styledtext.new(string.format("MEM %s",
                                                    formatPercent(usedPercent)),
                                      {color = memColor})
    local caffeinateText = hs.styledtext.new(caffeinateStatus)
    local separator = hs.styledtext.new(" | ")
    local fullTitle = hs.styledtext.concat({
      cpuText,
      separator,
      memText,
      caffeinateText
    })
    menubar:setTitle(fullTitle)
    menubar:setTooltip(nil)
  end

  -- Send throttled alerts, which can be disabled via the menu
  if alertsEnabled then
    local now = os.time()
    if highCpu and (now - lastCpuAlertTime > alertCooldown) then
      showNotification("High CPU Usage",
                       string.format("CPU is at %s", formatPercent(cpuActive)))
      lastCpuAlertTime = now
    end
    if highMem and (now - lastMemAlertTime > alertCooldown) then
      showNotification("High Memory Usage", string.format("Memory is at %s",
                                                          formatPercent(
                                                              usedPercent)))
      lastMemAlertTime = now
    end
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
    menubar:setTitle(hs.styledtext.new(compactMode and "⚡ (off)" or
                                           "MONITOR OFF"))
  end
end

-- Track manual caffeinate override to prevent auto-caffeinate from overriding user preference
local manualCaffeinateOverride = false
local userWantsCaffeinate = false

-- Auto caffeinate when external display connected and AC power
local function checkCaffeinateOnDisplay()
  local screens = hs.screen.allScreens()
  local hasExternal = #screens > 1
  local power = hs.battery.powerSource() -- "AC Power" or "Battery Power" or nil

  -- If user manually set caffeinate, respect that setting
  if manualCaffeinateOverride then
    hs.caffeinate.set("displayIdle", userWantsCaffeinate)
    return
  end

  -- Auto caffeinate logic
  if hasExternal and power == "AC Power" then
    hs.caffeinate.set("displayIdle", true)
    hs.alert.show("Auto Caffeinate: ON", 1)
  else
    hs.caffeinate.set("displayIdle", false)
  end
end

-- Manual caffeinate toggle function
local function toggleCaffeinate()
  userWantsCaffeinate = not hs.caffeinate.get("displayIdle")
  manualCaffeinateOverride = true
  hs.caffeinate.set("displayIdle", userWantsCaffeinate)

  if userWantsCaffeinate then
    hs.alert.show("Caffeinate ON: System will not sleep")
  else
    hs.alert.show("Caffeinate OFF: System can sleep")
  end

  updateMenubar() -- Update menubar to reflect new state
end

-- Top-process inspector (safe: chooser + optional kill)
local function showTopProcessesChooser()
  local choices = {}
  local ok, out = hs.execute("ps -Ao pid,pcpu,pmem,comm --sort=-pcpu", true)
  if ok and out then
    local i = 0
    for line in out:gmatch("[^\n]+") do
      i = i + 1
      if i == 1 or line:match("^%s*$") then goto continue end -- Skip header and empty lines
      local pid, pcpu, pmem, cmd = line:match(
                                       "^%s*(%d+)%s+([%d%.]+)%s+([%d%.]+)%s+(.+)")
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

-- Watchers
local screenWatcher = hs.screen.watcher.new(
                          function() checkCaffeinateOnDisplay() end)
local powerWatcher = hs.battery.watcher.new(
                         function() checkCaffeinateOnDisplay() end)

-- Build menubar menu (shows full stats and actions)
local function buildMenu()
  local cpuActive, usedPercent = getStats()
  local isCaffeinated = hs.caffeinate.get("displayIdle")
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
      title = isCaffeinated and "Disable Caffeinate" or "Enable Caffeinate",
      fn = function()
        toggleCaffeinate()
        menubar:setMenu(buildMenu) -- Refresh menu
      end
    },
    {
      title = "Reset Auto-Caffeinate",
      fn = function()
        manualCaffeinateOverride = false
        checkCaffeinateOnDisplay()
        hs.alert.show("Auto-Caffeinate: Reset", 1)
        menubar:setMenu(buildMenu) -- Refresh menu
      end
    },
    {
      title = monitoringEnabled and "Stop Monitoring" or "Start Monitoring",
      fn = function()
        if monitoringEnabled then
          stopMonitoring()
        else
          monitoringEnabled = true
          startMonitoring()
        end
        menubar:setMenu(buildMenu) -- Refresh menu
      end
    },
    {
      title = (alertsEnabled and "Disable" or "Enable") .. " Alerts",
      fn = function()
        alertsEnabled = not alertsEnabled
        hs.alert.show("Alerts " .. (alertsEnabled and "Enabled" or "Disabled"),
                      1)
        menubar:setMenu(buildMenu) -- Refresh menu
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

function obj.start()
  -- Reset manual caffeinate override when starting
  manualCaffeinateOverride = false
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

function obj.init(hyper)
  -- Set initial menubar menu
  menubar:setMenu(buildMenu)

  -- Hotkeys
  -- Activity Monitor launcher
  hs.hotkey.bind({"cmd", "alt", "ctrl"}, "A", function()
    hs.application.launchOrFocus("Activity Monitor")
  end)
  -- Top-process inspector
  hs.hotkey.bind({"cmd", "alt", "ctrl"}, "K",
                 function() showTopProcessesChooser() end)
  -- Toggle compact display hotkey: Hyper+P
  hs.hotkey.bind(hyper, "p", function()
    compactMode = not compactMode
    updateMenubar()
  end)

  obj.start()
end

return obj
