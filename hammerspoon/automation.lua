-- hammerspoon/automation.lua
-- Automated workflows for resource-intensive tasks
local obj = {}

-- Timer for periodic cleanup
local cleanupTimer = nil

-- Function to check system resources and trigger cleanup if needed
local function checkSystemResources()
  local cpuThreshold = 80 -- percent
  local memThreshold = 85 -- percent

  local cpuActive, usedPercent = hs.host.cpuUsage().overall.active, 0

  -- Calculate memory usage
  local mem = hs.host.vmStat()
  local totalBytes = hs.host.physicalMemory()
  local pageSize = tonumber((hs.execute("sysctl -n hw.pagesize") or "4096")) or
                       4096
  local freePages = tonumber((hs.execute(
                                 "vm_stat | grep 'Pages free:' | awk '{print $3}'") or
                                 "0")) or 0
  local inactivePages = tonumber((hs.execute(
                                     "vm_stat | grep 'Pages inactive:' | awk '{print $3}'") or
                                     "0")) or 0
  local freeBytes = (freePages + inactivePages) * pageSize
  if totalBytes > 0 then
    usedPercent = ((totalBytes - freeBytes) / totalBytes) * 100
  end

  -- If resources are high, perform cleanup
  if cpuActive > cpuThreshold or usedPercent > memThreshold then
    hs.alert.show("High resource usage detected, performing automated cleanup")

    -- Trigger cache cleanup
    local cacheCmd = "find ~/Library/Caches -type f -mtime +7 -delete"
    hs.execute(cacheCmd)

    -- Clean temporary files
    local tempCmd =
        "find /tmp -type f -mtime +1 -delete && find /private/var/tmp -type f -mtime +1 -delete"
    hs.execute(tempCmd)
  end
end

-- Function to monitor and optimize application memory usage
local function monitorAndOptimizeApps()
  -- Kill applications that have been using high CPU for a sustained period
  local highCpuApps = {}
  local psOutput = hs.execute("ps -eo pid,pcpu,comm --sort=-pcpu | head -11")

  if psOutput then
    for line in psOutput:gmatch("[^\r\n]+") do
      if not line:match("PID") then -- Skip header
        local pid, cpu, comm = line:match("(%d+)%s+([%d%.]+)%s+(.+)")
        if pid and cpu and tonumber(cpu) and tonumber(cpu) > 50 then -- More than 50% CPU
          table.insert(highCpuApps,
                       {pid = pid, cpu = tonumber(cpu), comm = comm})
        end
      end
    end

    -- Alert if we found high CPU processes
    if #highCpuApps > 0 then
      local alertMsg = "High CPU processes found:\n"
      for i, app in ipairs(highCpuApps) do
        if i > 5 then break end -- Limit to top 5
        alertMsg = alertMsg .. string.format("%s: %.1f%%\n", app.comm, app.cpu)
      end
      hs.alert.show(alertMsg)
    end
  end
end

-- Function to set up automated maintenance
local function setupAutomatedMaintenance()
  -- Run cleanup every 30 minutes
  cleanupTimer = hs.timer.doEvery(1800, function() -- 30 minutes = 1800 seconds
    checkSystemResources()
    monitorAndOptimizeApps()
  end)
end

-- Function to optimize system when idle
local function optimizeOnIdle()
  -- This function will be called when the system is detected as idle
  hs.alert.show("Optimizing system during idle time...")

  -- Clear caches
  hs.execute("find ~/Library/Caches -type f -mtime +1 -delete")

  -- Purge memory
  hs.execute("sudo purge") -- Only works if user has passwordless sudo access for purge command
end

-- Function to set up an idle watcher (triggers after 10 minutes of inactivity)
local function setupIdleWatcher()
  local idleTimeThreshold = 600 -- 10 minutes in seconds
  local idleChecker = hs.timer.new(60, function() -- Check every minute
    if hs.timer.secondsSinceLastActivity() > idleTimeThreshold then
      optimizeOnIdle()
    end
  end)
  idleChecker:start()
end

-- Function to manage application groups for better performance
local function setupAppGroups()
  -- Create function to quickly launch/quit app groups
  local appGroups = {
    work = {"Visual Studio Code", "iTerm", "Safari", "Slack"},
    media = {"Preview", "QuickTime Player", "Music", "Photos"},
    communication = {"Messages", "Mail", "Calendar"}
  }

  -- Function to launch app group
  local function launchAppGroup(groupName)
    if appGroups[groupName] then
      for _, appName in ipairs(appGroups[groupName]) do
        hs.application.launchOrFocus(appName)
      end
      hs.alert.show("Launched " .. groupName .. " apps")
    end
  end

  -- Function to quit app group
  local function quitAppGroup(groupName)
    if appGroups[groupName] then
      for _, appName in ipairs(appGroups[groupName]) do
        local app = hs.application.find(appName)
        if app then app:kill() end
      end
      hs.alert.show("Quit " .. groupName .. " apps")
    end
  end

  -- Register hotkeys for app groups
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

function obj.start()
  setupAutomatedMaintenance()
  setupIdleWatcher()
  setupAppGroups()
end

function obj.stop()
  if cleanupTimer then
    cleanupTimer:stop()
    cleanupTimer = nil
  end
end

function obj.init(hyper)
  obj.start()

  -- Manual trigger for system optimization (Hyper + O)
  hs.hotkey.bind(hyper, "o", function()
    hs.alert.show("Manual system optimization...")
    checkSystemResources()
    monitorAndOptimizeApps()
  end)

  -- Hotkey to manually run maintenance (Hyper + Shift + O)
  hs.hotkey.bind({"cmd", "alt", "shift"}, "O", function()
    hs.alert.show("Running manual maintenance...")
    local cacheCmd = "find ~/Library/Caches -type f -mtime +1 -delete"
    hs.execute(cacheCmd)
    hs.alert.show("Maintenance completed")
  end)
end

return obj
