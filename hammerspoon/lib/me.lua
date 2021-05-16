local function reloadConfig()
  if spoon.Seal.chooser then
    spoon.Seal.chooser:hide()
    spoon.Seal.chooser:delete()
  end
  spoon.SpoonInstall:asyncUpdateAllRepos()
  hs.reload()
end
hs.hotkey.bind(hyper, "r", 'reload config', reloadConfig)
hs.loadSpoon('FadeLogo'):start()

local function showConsole()
  hs.application.launchOrFocusByBundleID('org.hammerspoon.Hammerspoon')
end
hs.hotkey.bind(hyper, "o", 'show console', showConsole)

-- cpu usage

cpuUsageMenuBar = hs.menubar.new()
local function  query()
  hs.host.cpuUsage(1,function(data)
    cpuUsageMenuBar:setTitle("cpu : "..string.format("%.4f", data.overall.active))
  end)
end
query()
cpuusageTimer = hs.timer.doEvery(1,query)
cpuusageTimer:start()
