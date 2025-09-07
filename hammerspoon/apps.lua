-- hammerspoon/apps.lua
-- Small helper module to launch / focus apps and provide a quick launcher
local M = {}

function M.init(hyper)
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
    -- This toggles the visibility and relaunches Finder.
    local state = hs.execute("defaults read com.apple.finder AppleShowAllFiles")
    local newState = (state:lower():match("true") or state:match("1")) and
                         "false" or "true"
    hs.execute("defaults write com.apple.finder AppleShowAllFiles -bool " ..
                   newState .. "; killall Finder")
    hs.alert.show("Finder hidden files: " .. newState)
  end)
end

return M
