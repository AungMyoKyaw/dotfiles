-- hammerspoon/automation.lua
-- Automated workflows for resource-intensive tasks (safer and more robust)
local M = {}

-- Timer for periodic cleanup
local cleanupTimer = nil
local idleChecker = nil
local lastInputEpoch = hs.timer.secondsSinceEpoch()
local inputEventtap = nil

-- Update last input timestamp on user interactions
local function startInputWatcher()
  if inputEventtap then return end
  inputEventtap = hs.eventtap.new({
    hs.eventtap.event.types.keyDown,
    hs.eventtap.event.types.leftMouseDown,
    hs.eventtap.event.types.rightMouseDown,
    hs.eventtap.event.types.mouseMoved
  }, function()
    lastInputEpoch = hs.timer.secondsSinceEpoch()
    return false
  end)
  inputEventtap:start()
end

local function stopInputWatcher()
  if inputEventtap then
    inputEventtap:stop()
    inputEventtap = nil
  end
end

-- Safe execute helper: run command and return success(boolean) and output (string)
local function safeExecute(cmd)
  local ok, out = pcall(hs.execute, cmd, true)
  if not ok then return false, tostring(out) end
  -- hs.execute may return empty string on success; treat any non-nil as success
  return true, out or ""
end

-- Function to check system resources and trigger cleanup if needed
local function checkSystemResources()
  local cpuThreshold = 80 -- percent
  local memThreshold = 85 -- percent

  local cpuActive = 0
  local usedPercent = 0

  local ok, cpu = pcall(function() return hs.host.cpuUsage() end)
  if ok and cpu and cpu.overall and cpu.overall.active then
    cpuActive = cpu.overall.active
  end

  -- Calculate memory usage (best-effort)
  local totalBytes = 0
  if type(hs.host.physicalMemory) == "function" then
    totalBytes = hs.host.physicalMemory() or 0
  end

  local pageSize = tonumber((hs.execute("sysctl -n hw.pagesize") or "4096")) or
                       4096
  local ok2, vmout = pcall(hs.execute, "vm_stat")
  local freePages, inactivePages = 0, 0
  if ok2 and vmout then
    local freeMatch = vmout:match("Pages free:%s+(%d+)")
    local inactiveMatch = vmout:match("Pages inactive:%s+(%d+)")
    freePages = tonumber(freeMatch) or 0
    inactivePages = tonumber(inactiveMatch) or 0
  else
    local vm = hs.host.vmStat()
    freePages = tonumber(vm.free) or 0
    inactivePages = tonumber(vm.inactive) or 0
  end
  local freeBytes = (freePages + inactivePages) * pageSize
  if totalBytes > 0 then
    usedPercent = ((totalBytes - freeBytes) / totalBytes) * 100
  end

  -- If resources are high, perform cleanup (non-destructive attempts)
  if cpuActive > cpuThreshold or usedPercent > memThreshold then
    hs.alert.show("High resource usage detected, performing automated cleanup")

    -- Trigger cache cleanup (best-effort, non-recursive to limit risk)
    local cacheCmd = "find \"$HOME/Library/Caches\" -type f -mtime +7 -delete"
    safeExecute(cacheCmd)

    -- Clean temporary files
    local tempCmd =
        "find /tmp -type f -mtime +1 -delete && find /private/var/tmp -type f -mtime +1 -delete"
    safeExecute(tempCmd)
  end
end

-- Function to monitor and optimize application memory usage
local function monitorAndOptimizeApps()
  local highCpuApps = {}
  local ok, out = pcall(hs.execute,
                        "ps -eo pid,pcpu,comm --sort=-pcpu | head -11", true)
  if ok and out then
    for line in out:gmatch("[^\r\n]+") do
      if not line:match("PID") then
        local pid, cpu, comm = line:match("(%d+)%s+([%d%.]+)%s+(.+)")
        if pid and cpu and tonumber(cpu) and tonumber(cpu) > 50 then
          table.insert(highCpuApps,
                       {pid = pid, cpu = tonumber(cpu), comm = comm})
        end
      end
    end

    if #highCpuApps > 0 then
      local alertMsg = "High CPU processes found:\n"
      for i, app in ipairs(highCpuApps) do
        if i > 5 then break end
        alertMsg = alertMsg .. string.format("%s: %.1f%%\n", app.comm, app.cpu)
      end
      hs.alert.show(alertMsg)
    end
  end
end

-- Function to set up automated maintenance
local function setupAutomatedMaintenance()
  -- Run cleanup every 30 minutes
  if cleanupTimer then cleanupTimer:stop() end
  cleanupTimer = hs.timer.doEvery(1800, function()
    checkSystemResources()
    monitorAndOptimizeApps()
  end)
end

-- Function to optimize system when idle
local function optimizeOnIdle()
  hs.alert.show("Optimizing system during idle time...")

  -- Clear caches (non-destructive approach)
  safeExecute("find \"$HOME/Library/Caches\" -type f -mtime +1 -delete")

  -- Try to purge inactive memory without sudo if available
  local ok, _ = pcall(hs.execute, "purge")
  if not ok then
    hs.alert.show("Skipping purge: requires privileges or not available")
  end
end

-- Function to set up an idle watcher (triggers after 10 minutes of inactivity)
local function setupIdleWatcher()
  local idleTimeThreshold = 600 -- 10 minutes
  startInputWatcher()
  if idleChecker then idleChecker:stop() end
  idleChecker = hs.timer.new(60, function()
    if (hs.timer.secondsSinceEpoch() - lastInputEpoch) > idleTimeThreshold then
      optimizeOnIdle()
    end
  end)
  idleChecker:start()
end

-- Function to manage application groups for better performance
local function setupAppGroups()
  local appGroups = {
    work = {"Visual Studio Code", "iTerm", "Safari", "Slack"},
    media = {"Preview", "QuickTime Player", "Music", "Photos"},
    communication = {"Messages", "Mail", "Calendar"}
  }

  local function launchAppGroup(groupName)
    if appGroups[groupName] then
      for _, appName in ipairs(appGroups[groupName]) do
        hs.application.launchOrFocus(appName)
      end
      hs.alert.show("Launched " .. groupName .. " apps")
    end
  end

  local function quitAppGroup(groupName)
    if appGroups[groupName] then
      for _, appName in ipairs(appGroups[groupName]) do
        local app = hs.application.find(appName)
        if app then app:kill() end
      end
      hs.alert.show("Quit " .. groupName .. " apps")
    end
  end

  hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W",
                 function() launchAppGroup("work") end)
  hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, "W",
                 function() quitAppGroup("work") end)
  hs.hotkey.bind({"cmd", "alt", "ctrl"}, "M",
                 function() launchAppGroup("media") end)
  hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, "M",
                 function() quitAppGroup("media") end)
  hs.hotkey.bind({"cmd", "alt", "ctrl"}, "C",
                 function() launchAppGroup("communication") end)
  hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, "C",
                 function() quitAppGroup("communication") end)
end

function M.start()
  setupAutomatedMaintenance()
  setupIdleWatcher()
  setupAppGroups()
end

function M.stop()
  if cleanupTimer then
    cleanupTimer:stop()
    cleanupTimer = nil
  end
  if idleChecker then
    idleChecker:stop()
    idleChecker = nil
  end
  stopInputWatcher()
end

function M.init(hyper)
  M.start()

  -- Manual trigger for system optimization (Hyper + O)
  hs.hotkey.bind(hyper, "o", function()
    hs.alert.show("Manual system optimization...")
    checkSystemResources()
    monitorAndOptimizeApps()
  end)

  -- Hotkey to manually run maintenance (Hyper + Shift + O)
  hs.hotkey.bind({"cmd", "alt", "shift"}, "O", function()
    hs.alert.show("Running manual maintenance...")
    safeExecute("find \"$HOME/Library/Caches\" -type f -mtime +1 -delete")
    hs.alert.show("Maintenance completed")
  end)
end

return M
