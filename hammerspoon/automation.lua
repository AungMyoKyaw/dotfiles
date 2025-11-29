-- hammerspoon/automation.lua
-- Automated workflows for resource-intensive tasks (safer and more robust)
local M = {}

-- Timer for periodic cleanup
local cleanupTimer = nil
local idleChecker = nil
local lastInputEpoch = hs.timer.secondsSinceEpoch()
local inputEventtap = nil

-- Timers for scheduled updates
local macUpdateTimer = nil
local aiToolsUpdateTimer = nil
local lastUpdateDate = nil
local lastAiUpdateDate = nil

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

-- Function to check if update should run (twice daily on machine startup)
local function shouldRunUpdate(lastUpdateStr, maxHours)
  if not lastUpdateStr then return true end
  
  -- Parse date string (YYYY-MM-DD format)
  local year, month, day = lastUpdateStr:match("(%d+)-(%d+)-(%d+)")
  if not year or not month or not day then return true end
  
  local lastUpdate = {
    year = tonumber(year),
    month = tonumber(month),
    day = tonumber(day),
    hour = 0,
    min = 0,
    sec = 0
  }
  
  local now = os.date("*t")
  local hoursDiff = os.difftime(os.time(now), os.time(lastUpdate)) / 3600
  
  return hoursDiff >= maxHours
end

-- Function to run updates on startup with smart scheduling
local function runStartupUpdates()
  local currentDate = os.date("%Y-%m-%d")
  local currentHour = tonumber(os.date("%H"))
  
  -- Check if we should run mac_update (twice daily, at least 8 hours apart)
  if shouldRunUpdate(lastUpdateDate, 8) then
    hs.alert.show("Running startup mac_update...")
    local ok, out = safeExecute("source ~/.zshrc && mac_update")
    if ok then
      hs.alert.show("Startup mac_update completed")
      lastUpdateDate = currentDate
    else
      hs.alert.show("Startup mac_update failed")
    end
  end
  
  -- Check if we should run AI tools update (once daily)
  if shouldRunUpdate(lastAiUpdateDate, 20) then
    hs.alert.show("Running startup AI tools update...")
    local ok, out = safeExecute("source ~/.zshrc && update_ai_tools")
    if ok then
      hs.alert.show("Startup AI tools update completed")
      lastAiUpdateDate = currentDate
    else
      hs.alert.show("Startup AI tools update failed")
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

  -- Run startup updates after 2 minutes delay (to let system settle)
  hs.timer.doAfter(120, function()
    runStartupUpdates()
  end)

  -- Check every hour for missed updates (in case machine was sleeping)
  local hourlyCheck = hs.timer.doEvery(3600, function()
    local currentHour = tonumber(os.date("%H"))
    
    -- Run mac_update at 9 AM and 6 PM if not already run
    if (currentHour == 9 or currentHour == 18) and shouldRunUpdate(lastUpdateDate, 8) then
      hs.alert.show("Running scheduled mac_update...")
      local ok, out = safeExecute("source ~/.zshrc && mac_update")
      if ok then
        hs.alert.show("Scheduled mac_update completed")
        lastUpdateDate = os.date("%Y-%m-%d")
      else
        hs.alert.show("Scheduled mac_update failed")
      end
    end
    
    -- Run AI tools update at 10 AM if not already run today
    if currentHour == 10 and shouldRunUpdate(lastAiUpdateDate, 20) then
      hs.alert.show("Running scheduled AI tools update...")
      local ok, out = safeExecute("source ~/.zshrc && update_ai_tools")
      if ok then
        hs.alert.show("Scheduled AI tools update completed")
        lastAiUpdateDate = os.date("%Y-%m-%d")
      else
        hs.alert.show("Scheduled AI tools update failed")
      end
    end
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

  -- Hotkey to run mac_update command (Hyper + U)
  hs.hotkey.bind(hyper, "u", function()
    hs.alert.show("Running mac_update...")
    local ok, out = safeExecute("source ~/.zshrc && mac_update")
    if ok then
      hs.alert.show("mac_update completed successfully")
    else
      hs.alert.show("mac_update failed: " .. (out or "Unknown error"))
    end
  end)

  -- Hotkey to run update_ai_tools command (Hyper + Shift + U)
  hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, "u", function()
    hs.alert.show("Updating AI tools...")
    local ok, out = safeExecute("source ~/.zshrc && update_ai_tools")
    if ok then
      hs.alert.show("AI tools updated successfully")
    else
      hs.alert.show("AI tools update failed: " .. (out or "Unknown error"))
    end
  end)
end

return M
