hyper = {"cmd", "alt", "ctrl", "shift"}

hs.hotkey.bind(hyper,'w', function()
  hs.notify.new({title="Hammerspoon", informativeText="Hello World"}):send()
end)

hs.hotkey.bind(hyper, "R", function()
  hs.reload()
end)
hs.alert.show("Config loaded")

-- set up your windowfilter
-- https://www.hammerspoon.org/docs/hs.window.switcher.html
-- default windowfilter: only visible windows, all Spaces
switcher = hs.window.switcher.new()

-- bind to hotkeys; WARNING: at least one modifier key is required!
hs.hotkey.bind(hyper,'N', function()
  switcher:next()
end)
hs.hotkey.bind(hyper,'P', function()
  switcher:previous()
end)

hs.hotkey.bind(hyper, "H", function()
  -- https://superuser.com/questions/1150828/how-to-make-hammerspoon-resize-windows-smoothly-on-osx
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

hs.hotkey.bind(hyper, "L", function()
  -- https://superuser.com/questions/1150828/how-to-make-hammerspoon-resize-windows-smoothly-on-osx
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  f.x = max.w / 2
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

hs.hotkey.bind(hyper, "J", function()
  -- https://superuser.com/questions/1150828/how-to-make-hammerspoon-resize-windows-smoothly-on-osx
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  f.x = max.x
  f.y = max.h / 2
  f.w = max.w
  f.h = max.h / 2
  win:setFrame(f)
end)

hs.hotkey.bind(hyper, "K", function()
  -- https://superuser.com/questions/1150828/how-to-make-hammerspoon-resize-windows-smoothly-on-osx
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w
  f.h = max.h / 2
  win:setFrame(f)
end)

hs.hotkey.bind(hyper, "F", function()
  -- https://superuser.com/questions/1150828/how-to-make-hammerspoon-resize-windows-smoothly-on-osx
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w
  f.h = max.h
  win:setFrame(f)
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
  caffeine:setClickCallback(caffeineClicked)
  setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end

function applicationWatcher(appName, eventType, appObject)
  if (eventType == hs.application.watcher.activated) then
    print(appName)
    if (appName == "Finder") then
      -- Bring all Finder windows forward when one gets activated
      appObject:selectMenuItem({"Window", "Bring All to Front"})
    end
  end
end
appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()
