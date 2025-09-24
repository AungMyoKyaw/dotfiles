-- hammerspoon/autoquit.lua
-- Automatically quit unused applications to free up system resources
local obj = {}
local applicationWatcher = nil
local appTimers = {} -- { app_name = { timer, last_focus_time } }
local idleTimeThreshold = 300 -- 5 minutes in seconds

-- Applications to monitor for auto-quitting
local monitoredApps = {
  "Safari",
  "iTerm",
  "Visual Studio Code",
  "Finder",
  "Mail",
  "Messages",
  "Preview",
  "TextEdit",
  "Calculator",
  "Notes"
}

-- Function to quit an application
local function quitApp(appName)
  local app = hs.application.find(appName)
  if app then
    local windows = app:allWindows()
    -- Only quit if no visible windows remain
    if not windows or #windows == 0 or not app:mainWindow() then
      app:kill()
      hs.alert.show(appName .. " quit automatically")
    end
  end
end

-- Function to reset the idle timer for an app
local function resetAppTimer(appName)
  if appTimers[appName] then appTimers[appName].timer:stop() end

  appTimers[appName] = {
    last_focus_time = hs.timer.secondsSinceEpoch(),
    timer = hs.timer.doAfter(idleTimeThreshold, function()
      quitApp(appName)
      appTimers[appName] = nil
    end)
  }
end

-- Function to start monitoring an application
local function startMonitoringApp(appName)
  if not appTimers[appName] then
    resetAppTimer(appName)
  else
    resetAppTimer(appName)
  end
end

-- Application watcher callback
local function appWatcherCallback(appName, eventType, appObject)
  -- Only respond to focus events
  if eventType == hs.application.watcher.activated then
    if monitoredApps[appName] then resetAppTimer(appName) end
  end
end

function obj.start()
  -- Convert monitoredApps to a lookup table for faster checking
  local lookupTable = {}
  for _, appName in ipairs(monitoredApps) do lookupTable[appName] = true end
  monitoredApps = lookupTable

  -- Start the application watcher
  applicationWatcher = hs.application.watcher.new(appWatcherCallback)
  applicationWatcher:start()

  -- Set up initial timers for already running apps
  for appName, _ in pairs(monitoredApps) do
    local app = hs.application.find(appName)
    if app then resetAppTimer(appName) end
  end
end

function obj.stop()
  if applicationWatcher then
    applicationWatcher:stop()
    applicationWatcher = nil
  end

  -- Stop all timers
  for _, timerInfo in pairs(appTimers) do timerInfo.timer:stop() end
  appTimers = {}
end

function obj.init(hyper)
  obj.start()

  -- Add a hotkey to manually quit idle apps
  hs.hotkey.bind(hyper, "q", function()
    local appsToQuit = {}
    for appName, timerInfo in pairs(appTimers) do
      local app = hs.application.find(appName)
      if app then
        local timeSinceFocus = hs.timer.secondsSinceEpoch() -
                                   timerInfo.last_focus_time
        if timeSinceFocus >= idleTimeThreshold then
          table.insert(appsToQuit, appName)
        end
      end
    end

    if #appsToQuit > 0 then
      for _, appName in ipairs(appsToQuit) do
        quitApp(appName)
        appTimers[appName] = nil
      end
      hs.alert.show("Quit " .. #appsToQuit .. " idle apps")
    else
      hs.alert.show("No idle apps to quit")
    end
  end)

  -- Hotkey to show currently monitored apps
  hs.hotkey.bind(hyper, "i", function() -- i for info
    local activeApps = {}
    for appName, timerInfo in pairs(appTimers) do
      local app = hs.application.find(appName)
      if app then
        local timeSinceFocus = math.floor(
                                   hs.timer.secondsSinceEpoch() -
                                       timerInfo.last_focus_time)
        table.insert(activeApps,
                     string.format("%s (%ds)", appName, timeSinceFocus))
      end
    end

    if #activeApps > 0 then
      hs.alert.show("Monitored apps:\n" .. table.concat(activeApps, "\n"))
    else
      hs.alert.show("No monitored apps currently running")
    end
  end)
end

return obj
