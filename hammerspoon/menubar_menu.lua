-- Generic menubar menu helper for Hammerspoon
-- Provides reusable menubar functionality with title, tooltip, and menu management
local menubarMenu = {}

-- Helper to format percentage
function menubarMenu.formatPercent(n)
  return string.format("%d%%", math.floor(n + 0.5))
end

-- Helper to create styled text with optional color
function menubarMenu.createStyledText(text, color)
  if color then
    return hs.styledtext.new(text, {color = color})
  else
    return hs.styledtext.new(text)
  end
end

-- Helper to concat styled text elements
function menubarMenu.concatStyledText(elements)
  return hs.styledtext.concat(elements)
end

-- Create a new menubar instance
function menubarMenu.new(config)
  config = config or {}

  local instance = {
    menubar = hs.menubar.new(),
    title = config.title or "",
    tooltip = config.tooltip or nil,
    compactMode = config.compactMode ~= false, -- default to true
    enabled = config.enabled ~= false, -- default to true
    updateInterval = config.updateInterval or 5,
    timer = nil,
    menuItems = {},
    statusColors = config.statusColors or {
      normal = nil,
      warning = {red = 0.9, green = 0.4, blue = 0.4},
      good = {red = 0.4, green = 0.8, blue = 0.4}
    },
    onUpdate = config.onUpdate or function() end,
    onMenuBuild = config.onMenuBuild or function() return {} end
  }

  return instance
end

-- Update menubar title and tooltip
function menubarMenu.updateTitle(instance, titleText, tooltipText, statusColor)
  if not instance.menubar then return end

  if not instance.enabled then
    local offText = instance.compactMode and "⚡ (off)" or "MONITOR OFF"
    instance.menubar:setTitle(menubarMenu.createStyledText(offText))
    instance.menubar:setTooltip(nil)
    return
  end

  local title = titleText or instance.title
  local tooltip = tooltipText or instance.tooltip

  if title then
    if statusColor then
      instance.menubar:setTitle(menubarMenu.createStyledText(title, statusColor))
    else
      instance.menubar:setTitle(menubarMenu.createStyledText(title))
    end
  end

  instance.menubar:setTooltip(tooltip)
end

-- Update menubar title with multiple styled elements
function menubarMenu.updateStyledTitle(instance, elements, tooltipText)
  if not instance.menubar then return end

  if not instance.enabled then
    local offText = instance.compactMode and "⚡ (off)" or "MONITOR OFF"
    instance.menubar:setTitle(menubarMenu.createStyledText(offText))
    instance.menubar:setTooltip(nil)
    return
  end

  if elements and #elements > 0 then
    local title = menubarMenu.concatStyledText(elements)
    instance.menubar:setTitle(title)
  end

  instance.menubar:setTooltip(tooltipText)
end

-- Set menu items
function menubarMenu.setMenu(instance, items)
  if not instance.menubar then return end

  local menu = items or {}
  if type(menu) == "function" then menu = menu() end

  instance.menubar:setMenu(menu)
  instance.menuItems = menu
end

-- Add menu item helper
function menubarMenu.addMenuItem(instance, item)
  if not instance.menuItems then instance.menuItems = {} end
  table.insert(instance.menuItems, item)
  menubarMenu.setMenu(instance, instance.menuItems)
end

-- Add separator to menu
function menubarMenu.addSeparator(instance)
  menubarMenu.addMenuItem(instance, {title = "-"})
end

-- Add toggle item to menu
function menubarMenu.addToggleItem(instance, title, getState, toggleState,
                                   refreshFn)
  local item = {
    title = title,
    fn = function()
      toggleState()
      if refreshFn then refreshFn() end
      menubarMenu.setMenu(instance, instance.onMenuBuild())
    end
  }
  menubarMenu.addMenuItem(instance, item)
  return item
end

-- Start automatic updates
function menubarMenu.startUpdates(instance)
  if instance.timer then return end

  instance.onUpdate()
  instance.timer = hs.timer.doEvery(instance.updateInterval,
                                    function() instance.onUpdate() end)
end

-- Stop automatic updates
function menubarMenu.stopUpdates(instance)
  if instance.timer then
    instance.timer:stop()
    instance.timer = nil
  end
end

-- Enable/disable menubar
function menubarMenu.setEnabled(instance, enabled)
  instance.enabled = enabled
  instance.onUpdate()
end

-- Toggle compact mode
function menubarMenu.toggleCompactMode(instance)
  instance.compactMode = not instance.compactMode
  instance.onUpdate()
end

-- Cleanup resources
function menubarMenu.cleanup(instance)
  menubarMenu.stopUpdates(instance)
  if instance.menubar then
    instance.menubar:delete()
    instance.menubar = nil
  end
end

-- Helper to create status-aware title
function menubarMenu.createStatusTitle(instance, status, compactText, fullText,
                                       tooltipText)
  local color = nil
  if status == "warning" then
    color = instance.statusColors.warning
  elseif status == "good" then
    color = instance.statusColors.good
  elseif status == "normal" then
    color = instance.statusColors.normal
  end

  if instance.compactMode then
    menubarMenu.updateTitle(instance, compactText, tooltipText, color)
  else
    menubarMenu.updateTitle(instance, fullText, tooltipText, color)
  end
end

-- Helper to create menu with standard sections
function menubarMenu.createStandardMenu(instance, sections)
  local menu = {}

  -- Add status section if provided
  if sections.status then
    for _, item in ipairs(sections.status) do table.insert(menu, item) end
    table.insert(menu, {title = "-"})
  end

  -- Add actions section if provided
  if sections.actions then
    for _, item in ipairs(sections.actions) do table.insert(menu, item) end
    table.insert(menu, {title = "-"})
  end

  -- Add options section if provided
  if sections.options then
    for _, item in ipairs(sections.options) do table.insert(menu, item) end
  end

  return menu
end

return menubarMenu
