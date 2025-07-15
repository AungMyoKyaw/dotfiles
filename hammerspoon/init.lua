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

-- Caffeinate Menu Bar Button
local caffeinateMenu = hs.menubar.new()
local function setCaffeinateMenu()
  if hs.caffeinate.get("displayIdle") then
    caffeinateMenu:setTitle("☕️")
    caffeinateMenu:setTooltip("Caffeinate is ON. Click to turn OFF.")
  else
    caffeinateMenu:setTitle("💤")
    caffeinateMenu:setTooltip("Caffeinate is OFF. Click to turn ON.")
  end
end

local function toggleCaffeinate()
  hs.caffeinate.toggle("displayIdle")
  setCaffeinateMenu()
  if hs.caffeinate.get("displayIdle") then
    hs.alert.show("Caffeinate ON: System will not sleep")
  else
    hs.alert.show("Caffeinate OFF: System can sleep")
  end
end

caffeinateMenu:setClickCallback(toggleCaffeinate)
setCaffeinateMenu()
