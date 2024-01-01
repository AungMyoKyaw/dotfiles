-- CAFFEINE
spoon.Caffeine:start()
spoon.Caffeine:setState(false)

-- HOLD TO QUIT
spoon.HoldToQuit:start()

-- HAMMERSPOON ROUNDED CORNERS
spoon.RoundedCorners:start()

-- ACLOCK
spoon.AClock.format = '%I:%M %p'
spoon.AClock.width = 700
spoon.AClock.textFont = 'Noto Sans'
local function toggleClock() spoon.AClock:toggleShowPersistent() end
-- hs.hotkey.bind(hyper, 't', toggleClock)

-- show window hint
hs.hotkey.bind(hyper, 'h', 'window hint', function() spoon.KSheet:toggle() end)

-- these are only my favourite apps, you can replace it with yours
-- local applicationHotkeys = {
--   t = 'Alacritty',
--   i = 'Toggl Track',
--   f = 'Finder'
-- }
-- for key, app in pairs(applicationHotkeys) do
--   local function launchOrFocus()
--     hs.application.launchOrFocus(app)
--   end
--   hs.hotkey.bind(hyper, key, app,launchOrFocus)
-- end
