local hyper = {"cmd", "alt", "ctrl", "shift"}
local hswhints_keys = {"alt", "tab"}
-- hs.window.animationDuration = 0

hs.loadSpoon('SpoonInstall')
spoon.SpoonInstall:andUse('WinWin')
spoon.SpoonInstall:andUse('Caffeine')
spoon.SpoonInstall:andUse('ClipboardTool')

hs.hotkey.bind(hyper,'w', 'WINDOW_HINT', function()
  hs.hints.windowHints()
end)

hs.hotkey.bind(hyper, "R", 'CONFIG_RELOADED', function()
  spoon.SpoonInstall:asyncUpdateAllRepos()
  hs.reload()
end)
hs.alert.show("Config loaded")

-- set up your windowfilter
-- https://www.hammerspoon.org/docs/hs.window.switcher.html
-- default windowfilter: only visible windows, all Spaces
switcher = hs.window.switcher.new()
hs.window.switcher.ui.showThumbnails = false
hs.window.switcher.ui.showSelectedThumbnail = false
hs.window.switcher.ui.showSelectedTitle = false

hs.hotkey.bind(hyper,'N','NEXT', function()
  switcher:next()
end)

hs.hotkey.bind(hyper,'P','PREV', function()
  switcher:previous()
end)

hs.hotkey.bind(hyper, 'H','W_LEFT_ALIGN', function()
  spoon.WinWin:moveAndResize("halfleft")
end)

hs.hotkey.bind(hyper, 'L', 'W_RIGHT_ALIGN', function()
  spoon.WinWin:moveAndResize("halfright")
end)

hs.hotkey.bind(hyper, 'J', 'W_DOWN_ALIGN', function()
  spoon.WinWin:moveAndResize("halfdown")
end)

hs.hotkey.bind(hyper, 'K','W_UP_ALIGN', function()
  spoon.WinWin:moveAndResize("halfup")
end)

hs.hotkey.bind(hyper, 'F', 'W_MAXIMIZE', function()
  spoon.WinWin:moveAndResize('maximize')
end)

hs.hotkey.bind(hyper, '-', 'W_SHRINK', function()
  spoon.WinWin:moveAndResize("shrink")
end)

hs.hotkey.bind(hyper, '=', 'W_EXPAND', function()
  spoon.WinWin:moveAndResize("expand")
end)

hs.hotkey.bind(hyper, 'c', 'W_CENTER', function()
  spoon.WinWin:moveAndResize("center")
end)

hs.hotkey.bind(hyper, 'y', 'W_NORTHWEST_CORNER', function()
  spoon.WinWin:moveAndResize("cornerNW")
end)

hs.hotkey.bind(hyper, 'o', 'W_NORTHEAST_CORNER', function()
  spoon.WinWin:moveAndResize("cornerNE")
end)

hs.hotkey.bind(hyper, 'u', 'W_SOUTHWEST_CORNER', function()
  spoon.WinWin:moveAndResize("cornerSW")
end)

hs.hotkey.bind(hyper, 'i', 'W_SOUTHEAST_CORNER', function()
  spoon.WinWin:moveAndResize("cornerSE")
end)

-- CAFFEINE
spoon.Caffeine:start()
spoon.Caffeine:setState(true)

-- ClipboardTool
spoon.ClipboardTool:start()
