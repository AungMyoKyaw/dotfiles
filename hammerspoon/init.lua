-- Hammerspoon init.lua
-- Window management with vim/tmux-inspired keybindings
-- Define Hyper key (Cmd+Alt+Ctrl)
-- Define Hyper key (Cmd+Alt+Ctrl+Shift)
local hyper = {"cmd", "alt", "ctrl", "shift"}

-- Load window management module
require "window_management"

-- Reload config with Hyper+R
hs.hotkey.bind(hyper, "r", function()
  hs.reload()
  hs.alert.show("Hammerspoon config reloaded")
end)

-- Auto-reload when init.lua changes
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", hs.reload):start()
hs.alert.show("Hammerspoon config loaded")
