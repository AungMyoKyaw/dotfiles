-- Hammerspoon init.lua
-- Main entry point for the configuration.
-- Enable IPC for command-line control
require("hs.ipc")

-- Define Hyper key (Cmd+Alt+Ctrl+Shift)
local hyper = {"cmd", "alt", "ctrl", "shift"}

-- Load modules and initialize them with the hyper key
require("apps").init(hyper)
require("performance").init(hyper)
require("autoquit").init(hyper)
require("cleanup").init(hyper)
require("automation").init(hyper)
require("window_management").init(hyper)
require("text_replacement").init(hyper)

-- Reload config with Hyper+R
hs.hotkey.bind(hyper, "r", function()
  hs.reload()
  hs.alert.show("Hammerspoon config reloaded")
end)

hs.alert.show("Hammerspoon config loaded")
