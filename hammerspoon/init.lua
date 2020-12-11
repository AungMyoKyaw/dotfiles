local hyper = {"cmd", "alt", "ctrl", "shift"}
local hswhints_keys = {"alt", "tab"}
local momentstop = 3000
hs.window.animationDuration = 0
hs.hints.showTitleThresh=1

-- hs.hotkey.bind(hswhints_keys, function()
hs.hotkey.bind(hyper,'w', 'WINDOW_HINT', function()
  hs.hints.windowHints()
end)

hs.hotkey.bind(hyper, "R", 'WINDOW_RELOAD', function()
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
  -- https://superuser.com/questions/1150828/how-to-make-hammerspoon-resize-windows-smoothly-on-osx
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f,0)
end)

hs.hotkey.bind(hyper, 'L', 'W_RIGHT_ALIGN', function()
  -- https://superuser.com/questions/1150828/how-to-make-hammerspoon-resize-windows-smoothly-on-osx
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  f.x = max.w / 2
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f,0)
end)

hs.hotkey.bind(hyper, 'J', 'W_DOWN_ALIGN', function()

  -- https://superuser.com/questions/1150828/how-to-make-hammerspoon-resize-windows-smoothly-on-osx
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  f.x = max.x
  f.y = max.h / 2
  f.w = max.w
  f.h = max.h / 2
  win:setFrame(f,0)
end)

hs.hotkey.bind(hyper, 'K','W_UP_ALIGN', function()
  -- https://superuser.com/questions/1150828/how-to-make-hammerspoon-resize-windows-smoothly-on-osx
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w
  f.h = max.h / 2
  win:setFrame(f,0)
end)

hs.hotkey.bind(hyper, 'F', 'W_MAXIMIZE', function()
  -- https://superuser.com/questions/1150828/how-to-make-hammerspoon-resize-windows-smoothly-on-osx
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w
  f.h = max.h
  win:setFrame(f,0)
end)

-- hs.hotkey.bind({"alt", "ctrl"}, "K","K", function()
--   hs.spotify.displayCurrentTrack()
-- end)

caffeine = hs.menubar.new()
function setCaffeineDisplay(state)
  if state then
    caffeine:setTitle("AWAKE🥶")
  else
    caffeine:setTitle("SLEEPY💤")
  end
end

function caffeineClicked()
  setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
  local display_status = hs.caffeinate.get("displayIdle")
  if display_status == false then
    hs.caffeinate.toggle("displayIdle")
  end

  display_status = hs.caffeinate.get("displayIdle")
  caffeine:setClickCallback(caffeineClicked)
  setCaffeineDisplay(display_status)
end
