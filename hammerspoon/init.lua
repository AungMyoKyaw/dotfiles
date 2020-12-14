local hyper = {"cmd", "alt", "ctrl", "shift"}
local hswhints_keys = {"alt", "tab"}
hs.window.animationDuration = 0

hs.loadSpoon('SpoonInstall')
local spoons_list = {
  "Caffeine",
  "ClipboardTool",
  "FadeLogo",
  "HoldToQuit",
  "KSheet",
  "ModalMgr",
  "SpeedMenu",
  "WinWin"
}
for i = 1, #spoons_list do
  spoon.SpoonInstall:andUse(spoons_list[i])
end

-- hs.hotkey.bind(hyper,'w', 'WINDOW_HINT', function()
--   spoon.KSheet:toggle()
-- end)

hs.hotkey.bind(hyper, "R", 'CONFIG_RELOADED', function()
  spoon.SpoonInstall:asyncUpdateAllRepos()
  hs.reload()
end)
hs.loadSpoon('FadeLogo'):start()

-- set up your windowfilter
-- https://www.hammerspoon.org/docs/hs.window.switcher.html
-- default windowfilter: only visible windows, all Spaces
switcher = hs.window.switcher.new()
hs.window.switcher.ui.showThumbnails = false
hs.window.switcher.ui.showSelectedThumbnail = false
hs.window.switcher.ui.showSelectedTitle = true

hs.hotkey.bind(hyper,'N','NEXT', function()
  switcher:next()
end)

hs.hotkey.bind(hyper,'P','PREV', function()
  switcher:previous()
end)

hs.hotkey.bind('alt','tab','Next window',function()
  switcher:next()
end)
hs.hotkey.bind('alt-shift','tab','Prev window',function()
  switcher:previous()
end)

----------------------------------------------------------------------------------------------------
-- https://github.com/ashfinal/awesome-hammerspoon
----------------------------------------------------------------------------------------------------
spoon.ModalMgr:new("w_management")
local w_management = spoon.ModalMgr.modal_list["w_management"]
w_management:bind('', 'escape', 'w_management', function()
  spoon.ModalMgr:deactivate({"w_management"})
end)

w_management:bind('', 'h','W_LEFT_ALIGN', function()
  spoon.WinWin:moveAndResize("halfleft")
end)

w_management:bind('shift', 'h','W_LEFT_RESIZE', function()
  spoon.WinWin:stepResize("left")
end)

w_management:bind('', 'l', 'W_RIGHT_ALIGN', function()
  spoon.WinWin:moveAndResize("halfright")
end)

w_management:bind('shift', 'l', 'W_RIGHT_RESIZE', function()
  spoon.WinWin:stepResize("right")
end)

w_management:bind('', 'j', 'W_DOWN_ALIGN', function()
  spoon.WinWin:moveAndResize("halfdown")
end)

w_management:bind('shift', 'j', 'W_DOWN_RESIZE', function()
  spoon.WinWin:stepResize("down")
end)

w_management:bind('', 'k','W_UP_ALIGN', function()
  spoon.WinWin:moveAndResize("halfup")
end)

w_management:bind('shift', 'k','W_UP_RESIZE', function()
  spoon.WinWin:stepResize("up")
end)

w_management:bind('', 'f', 'W_MAXIMIZE', function()
  spoon.WinWin:moveAndResize('maximize')
end)

w_management:bind('', '-', 'W_SHRINK', function()
  spoon.WinWin:moveAndResize("shrink")
end)

w_management:bind('', '=', 'W_EXPAND', function()
  spoon.WinWin:moveAndResize("expand")
end)

w_management:bind('', 'c', 'W_CENTER', function()
  spoon.WinWin:moveAndResize("center")
end)

w_management:bind('', 'y', 'W_NORTHWEST_CORNER', function()
  spoon.WinWin:moveAndResize("cornerNW")
end)

w_management:bind('', 'o', 'W_NORTHEAST_CORNER', function()
  spoon.WinWin:moveAndResize("cornerNE")
end)

w_management:bind('', 'u', 'W_SOUTHWEST_CORNER', function()
  spoon.WinWin:moveAndResize("cornerSW")
end)

w_management:bind('', 'i', 'W_SOUTHEAST_CORNER', function()
  spoon.WinWin:moveAndResize("cornerSE")
end)

spoon.ModalMgr.supervisor:bind(hyper,'w', "enter w_management", function()
  spoon.ModalMgr:deactivateAll()
  spoon.ModalMgr:activate({"w_management"}, "#B22222")
end)

-- CAFFEINE
spoon.Caffeine:start()
spoon.Caffeine:setState(true)

-- ClipboardTool
spoon.ClipboardTool:start()

-- speedmenu
spoon.SpeedMenu:start()

-- hold to quit
spoon.HoldToQuit:start()

spoon.ModalMgr.supervisor:enter()
