momentStep = 30

hyper = {"cmd", "alt", "ctrl", "shift"}

hs.hotkey.bind(hyper,'w', function()
  hs.notify.new({title="Hammerspoon", informativeText="Hello World"}):send()
end)

hs.hotkey.bind(hyper, "R", function()
  hs.reload()
end)
hs.alert.show("Config loaded")


hs.hotkey.bind(hyper, "H", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x - momentStep
  win:setFrame(f)
end)

hs.hotkey.bind(hyper, "L", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x + momentStep
  win:setFrame(f)
end)

hs.hotkey.bind(hyper, "J", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.y = f.y - momentStep
  win:setFrame(f)
end)

hs.hotkey.bind(hyper, "K", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.y = f.y + momentStep
  win:setFrame(f)
end)

-- hs.hotkey.bind({"alt", "ctrl"}, "K","K", function()
-- hs.spotify.displayCurrentTrack()
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
