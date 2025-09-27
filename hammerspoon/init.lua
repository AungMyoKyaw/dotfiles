-- Hammerspoon init.lua
-- Main entry point for the configuration.
-- Define Hyper key (Cmd+Alt+Ctrl+Shift)
local hyper = {"cmd", "alt", "ctrl", "shift"}

-- Load modules and initialize them with the hyper key
require("apps").init(hyper)
require("performance").init(hyper)
require("autoquit").init(hyper)
require("cleanup").init(hyper)
require("automation").init(hyper)
require("window_management").init(hyper)

-- Reload config with Hyper+R
hs.hotkey.bind(hyper, "r", function()
  hs.reload()
  hs.alert.show("Hammerspoon config reloaded")
end)

-- Auto-reload when configuration files change
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", hs.reload):start()
hs.alert.show("Hammerspoon config loaded")
