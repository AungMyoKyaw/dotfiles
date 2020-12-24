-- CAFFEINE
spoon.Caffeine:start()
spoon.Caffeine:setState(true)

-- HOLD TO QUIT
spoon.HoldToQuit:start()

-- HAMMERSPOON ROUNDED CORNERS
spoon.RoundedCorners:start()

-- ACLOCK
spoon.AClock.format = "%I:%M %p"
spoon.AClock.width = 800
local function toggleClock()
  spoon.AClock:toggleShowPersistent()
end
hs.hotkey.bind(hyper, "t", 'SHOW-CLOCK', toggleClock)
