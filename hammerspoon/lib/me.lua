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
