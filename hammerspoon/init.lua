local hyper = {"cmd", "alt", "ctrl", "shift"}
local hswhints_keys = {"alt", "tab"}
hs.window.animationDuration = 0

hs.loadSpoon('SpoonInstall')
local spoons_list = {
  "AClock",
  "Caffeine",
  "ClipboardTool",
  "Commander",
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

hs.hotkey.bind(hyper, "r", 'CONFIG_RELOADED', function()
  spoon.SpoonInstall:asyncUpdateAllRepos()
  hs.reload()
end)
hs.loadSpoon('FadeLogo'):start()

hs.hotkey.bind(hyper, "o", 'CONFIG_RELOADED', function()
  hs.application.launchOrFocusByBundleID('org.hammerspoon.Hammerspoon')
end)

spoon.AClock.format = "%I:%M %p"
spoon.AClock.width = 800
hs.hotkey.bind(hyper, "t", 'SHOW-CLOCK', function()
  spoon.AClock:toggleShowPersistent()
end)

hs.hotkey.bind(hyper, "y", 'toggle-clipboard', function()
  spoon.ClipboardTool:toggleClipboard()
end)

hs.hotkey.bind(hyper, "i", 'toggle-commander', function()
  spoon.Commander:show()
end)

-- window-search-switch
local chooser = hs.chooser.new(function(choice)
  hs.application.launchOrFocusByBundleID(choice.bundleID)
end);
hs.hotkey.bind(hyper, 'n', 'choose-and-split-vertical', function()
  -- https://github.com/evantravers/hammerspoon-config/blob/a85100b138/movewindows.lua
  local visible = chooser:isVisible()
  if visible then
    return chooser:hide()
  end
  local windows = hs.fnutils.map(hs.window.filter.new():getWindows(), function(win)
    if win ~= hs.window.focusedWindow() then
      return {
        text = win:title(),
        subText = win:application():title(),
        image = hs.image.imageFromAppBundle(win:application():bundleID()),
        id = win:id(),
        bundleID = win:application():bundleID()
      }
    end
  end)
  chooser:placeholderText('Search App to swtich')
  chooser:choices(windows)
  chooser:rows(10)
  chooser:searchSubText(true)
  chooser:show()
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

w_management:bind('', 'left', 'W_LEFT_MOVE', function()
  spoon.WinWin:stepMove("left")
end,nil,function()
  spoon.WinWin:stepMove("left")
end)

w_management:bind('', 'right', 'W_RIGHT_MOVE', function()
  spoon.WinWin:stepMove("right")
end,nil,function()
  spoon.WinWin:stepMove("right")
end)

w_management:bind('', 'up', 'W_UP_MOVE', function()
  spoon.WinWin:stepMove("up")
end,nil,function()
  spoon.WinWin:stepMove("up")
end)

w_management:bind('', 'down', 'W_DOWN_MOVE', function()
  spoon.WinWin:stepMove("down")
end,nil,function()
  spoon.WinWin:stepMove("down")
end)

-- show window hint
w_management:bind('w', 'h', nil, function()
  spoon.KSheet:toggle()
end)

spoon.ModalMgr.supervisor:bind(hyper,'m', "enter w_management", function()
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
