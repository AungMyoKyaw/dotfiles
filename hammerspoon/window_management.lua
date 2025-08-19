-- hammerspoon/window_management.lua
-- Window management modal with vim/tmux-inspired keybindings
-- Define Hyper key (Cmd+Alt+Ctrl+Shift)
local hyper = {"cmd", "alt", "ctrl", "shift"}

-- Create modal for window management
local windowManagement = hs.hotkey.modal.new(hyper, "m",
                                             "Window Management Mode")

-- On-screen indicator for window management mode
local indicator = nil
local hideTimer = nil

local function showIndicator()
  if indicator then return end
  if hideTimer then
    hideTimer:stop();
    hideTimer = nil
  end
  local screenFrame = hs.screen.mainScreen():frame()
  local w, h = 350, 80
  local x = screenFrame.x + (screenFrame.w - w) / 2
  local y = screenFrame.y + 20
  -- background panel
  local bg = hs.drawing.rectangle({x = x, y = y, w = w, h = h})
  bg:setFillColor({hex = "#000000", alpha = 0.6}):setLevel(hs.drawing
                                                               .windowLevels
                                                               .overlay)
      :setRoundedRectRadii(10, 10):setBehaviorByLabels({"canJoinAllSpaces"})
      :show()
  -- text overlay with key hints
  local txt = hs.drawing.text({x = x, y = y, w = w, h = h},
                              "Window Management Mode\n" ..
                                  "h/j/k/l: snap  f: max  c: center  -/+: resize  =: reset  q/Esc: exit")
  txt:setTextSize(14):setTextFont("Menlo"):setTextColor({white = 1}):setLevel(
      hs.drawing.windowLevels.overlay):setBehaviorByLabels({"canJoinAllSpaces"})
      :show()
  indicator = {bg = bg, txt = txt}
  -- auto-hide after delay
  hideTimer = hs.timer.doAfter(4, function()
    if indicator then hideIndicator() end
  end)
end

local function hideIndicator()
  if hideTimer then
    hideTimer:stop();
    hideTimer = nil
  end
  if not indicator then return end
  indicator.bg:delete()
  indicator.txt:delete()
  indicator = nil
end

function windowManagement:entered()
  -- Save initial frame for reset
  local win = hs.window.focusedWindow()
  if win then self.initialFrame = win:frame() end
  -- Show on-screen mode indicator with key hints
  showIndicator()
end

function windowManagement:exited()
  -- Hide on-screen indicator
  hideIndicator()
  hs.alert.show("Exited Window Management Mode")
end

-- Helper to snap window to half screen
local function moveWindow(direction)
  local win = hs.window.focusedWindow()
  if not win then return end
  local f = win:frame()
  local screen = win:screen():frame()

  if direction == "left" then
    f.x, f.y, f.w, f.h = screen.x, screen.y, screen.w / 2, screen.h
  elseif direction == "right" then
    f.x, f.y, f.w, f.h = screen.x + screen.w / 2, screen.y, screen.w / 2,
                         screen.h
  elseif direction == "up" then
    f.x, f.y, f.w, f.h = screen.x, screen.y, screen.w, screen.h / 2
  elseif direction == "down" then
    f.x, f.y, f.w, f.h = screen.x, screen.y + screen.h / 2, screen.w,
                         screen.h / 2
  end

  win:setFrame(f)
end

-- Center and resizing helpers
local function centerWindow()
  local win = hs.window.focusedWindow()
  if not win then return end
  local f = win:frame()
  local screen = win:screen():frame()
  f.x = screen.x + (screen.w - f.w) / 2
  f.y = screen.y + (screen.h - f.h) / 2
  win:setFrame(f)
end

local function resizeWindow(factor)
  local win = hs.window.focusedWindow()
  if not win then return end
  local f = win:frame()
  local oldW, oldH = f.w, f.h
  local newW, newH = oldW * factor, oldH * factor
  f.w, f.h = newW, newH
  f.x = f.x - (newW - oldW) / 2
  f.y = f.y - (newH - oldH) / 2
  win:setFrame(f)
end

-- Bind vim-style keys in window management mode
windowManagement:bind("", "h", function() moveWindow("left") end)
windowManagement:bind("", "l", function() moveWindow("right") end)
windowManagement:bind("", "k", function() moveWindow("up") end)
windowManagement:bind("", "j", function() moveWindow("down") end)

-- Maximize window (full screen)
windowManagement:bind("", "f", function()
  local win = hs.window.focusedWindow()
  if win then win:maximize() end
end)

-- Exit mode
windowManagement:bind("", "q", function() windowManagement:exit() end)
windowManagement:bind("", "escape", function() windowManagement:exit() end)

-- Center window in screen
windowManagement:bind("", "c", function() centerWindow() end)
-- Resize down by 10%
windowManagement:bind("", "-", function() resizeWindow(0.9) end)
-- Resize up by 10%
windowManagement:bind({"shift"}, "=", function() resizeWindow(1.1) end)
-- Reset window to original size
windowManagement:bind("", "=", function()
  local win = hs.window.focusedWindow()
  if win and windowManagement.initialFrame then
    win:setFrame(windowManagement.initialFrame)
  end
end)
-- Optional: bind arrow keys as well
windowManagement:bind("", "left", function() moveWindow("left") end)
windowManagement:bind("", "right", function() moveWindow("right") end)
windowManagement:bind("", "up", function() moveWindow("up") end)
windowManagement:bind("", "down", function() moveWindow("down") end)

-- Move focused window to next screen (useful for multi-monitor)
windowManagement:bind({"shift"}, "n", function()
  local win = hs.window.focusedWindow()
  if not win then return end
  local nextScreen = win:screen():next()
  if nextScreen then win:moveToScreen(nextScreen) end
end)

return windowManagement
