-- hammerspoon/apps.lua
-- Small helper module to launch / focus apps and provide a quick launcher
local hyper = {"cmd", "alt", "ctrl", "shift"}

-- List of favorite apps and single-key bindings
local apps = {
  t = "iTerm",
  s = "Safari",
  e = "Visual Studio Code",
  n = "Notes",
  f = "Finder"
}

-- Launcher: Hyper + Space -> show chooser
hs.hotkey.bind(hyper, "space", function()
  local choices = {}
  for k, v in pairs(apps) do
    table.insert(choices, {text = v, subText = "Open/focus " .. v})
  end
  local chooser = hs.chooser.new(function(choice)
    if not choice then return end
    hs.application.launchOrFocus(choice.text)
  end)
  chooser:choices(choices)
  chooser:show()
end)

-- Single-key app focus bindings: Hyper + <key>
for key, appName in pairs(apps) do
  hs.hotkey.bind(hyper, key,
                 function() hs.application.launchOrFocus(appName) end)
end

-- Quick toggle for Finder hidden files (example utility)
hs.hotkey.bind(hyper, "h", function()
  local cmd =
      "/usr/bin/defaults write com.apple.finder AppleShowAllFiles -bool true; killall Finder"
  hs.execute(cmd, true)
  hs.alert.show("Toggled Finder hidden files (run Finder)")
end)

return true
