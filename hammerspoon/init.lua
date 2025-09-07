-- Hammerspoon init.lua
-- Main entry point for the configuration.
-- Define Hyper key (Cmd+Alt+Ctrl+Shift)
local hyper = {"cmd", "alt", "ctrl", "shift"}

-- Load modules and initialize them with the hyper key
require("window_management").init(hyper)
require("apps").init(hyper)
require("performance").init(hyper)

-- Reload config with Hyper+R
hs.hotkey.bind(hyper, "r", function()
  hs.reload()
  hs.alert.show("Hammerspoon config reloaded")
end)

-- Auto-reload when configuration files change
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
