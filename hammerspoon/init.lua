--------------------------------------------------------------------------------
-- import
--------------------------------------------------------------------------------
local secret = require('secret')
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local hyper = {"cmd", "alt", "ctrl", "shift"}
local hswhints_keys = {"alt", "tab"}
hs.window.animationDuration = 0
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
hs.loadSpoon('SpoonInstall')
local function installSpoons()
  local spoons_list = {
    "AClock",
    "Caffeine",
    "FadeLogo",
    "HoldToQuit",
    "KSheet",
    "ModalMgr",
    "RoundedCorners",
    "Seal",
    "WinWin"
  }
  for i = 1, #spoons_list do
    spoon.SpoonInstall:andUse(spoons_list[i])
  end
end
installSpoons()

local function reloadConfig()
  if spoon.Seal.chooser then
    spoon.Seal.chooser:hide()
    spoon.Seal.chooser:delete()
  end
  spoon.SpoonInstall:asyncUpdateAllRepos()
  hs.reload()
end
hs.hotkey.bind(hyper, "r", 'reload config', reloadConfig)
hs.loadSpoon('FadeLogo'):start()

local function showConsole()
  hs.application.launchOrFocusByBundleID('org.hammerspoon.Hammerspoon')
end
hs.hotkey.bind(hyper, "o", 'show console', showConsole)

spoon.AClock.format = "%I:%M %p"
spoon.AClock.width = 800
local function toggleClock()
  spoon.AClock:toggleShowPersistent()
end
hs.hotkey.bind(hyper, "t", 'SHOW-CLOCK', toggleClock)

-- window-search-switch
local windowSwitcherChooser = hs.chooser.new(function(choice)
  hs.application.launchOrFocusByBundleID(choice.bundleID)
end);

local function winSwitcher ()
  -- https://github.com/evantravers/hammerspoon-config/blob/a85100b138/movewindows.lua
  local visible = windowSwitcherChooser:isVisible()
  if visible then
    return windowSwitcherChooser:hide()
  end
  local windows = hs.fnutils.map(hs.window.filter.new():getWindows(), function(win)
    if win ~= hs.window.focusedWindow() then
      return {
        text = win:title(),
        subText = win:application():title(),
        image = hs.image.imageFromAppBundle(win:application():bundleID()),
        id = win:id(),
        bundleID = win:application():bundleID()
      }
    end
  end)
  windowSwitcherChooser:placeholderText('Search App to swtich')
  windowSwitcherChooser:choices(windows)
  windowSwitcherChooser:rows(10)
  windowSwitcherChooser:searchSubText(true)
  windowSwitcherChooser:show()
end
hs.hotkey.bind(hyper, 'n', 'window switcher', winSwitcher)

--------------------------------------------------------------------------------
-- https://github.com/ashfinal/awesome-hammerspoon
--------------------------------------------------------------------------------

spoon.ModalMgr:new("w_management")
local w_management = spoon.ModalMgr.modal_list["w_management"]
w_management:bind('', 'escape', 'w_management', function()
  spoon.ModalMgr:deactivate({"w_management"})
end)

w_management:bind('', 'h','W_LEFT_ALIGN', function()
  spoon.WinWin:moveAndResize("halfleft")
end)

w_management:bind('shift', 'h','W_LEFT_RESIZE', function()
  spoon.WinWin:stepResize("left")
end)

w_management:bind('', 'l', 'W_RIGHT_ALIGN', function()
  spoon.WinWin:moveAndResize("halfright")
end)

w_management:bind('shift', 'l', 'W_RIGHT_RESIZE', function()
  spoon.WinWin:stepResize("right")
end)

w_management:bind('', 'j', 'W_DOWN_ALIGN', function()
  spoon.WinWin:moveAndResize("halfdown")
end)

w_management:bind('shift', 'j', 'W_DOWN_RESIZE', function()
  spoon.WinWin:stepResize("down")
end)

w_management:bind('', 'k','W_UP_ALIGN', function()
  spoon.WinWin:moveAndResize("halfup")
end)

w_management:bind('shift', 'k','W_UP_RESIZE', function()
  spoon.WinWin:stepResize("up")
end)

w_management:bind('', 'f', 'W_MAXIMIZE', function()
  spoon.WinWin:moveAndResize('maximize')
end)

w_management:bind('', '-', 'W_SHRINK', function()
  spoon.WinWin:moveAndResize("shrink")
end)

w_management:bind('', '=', 'W_EXPAND', function()
  spoon.WinWin:moveAndResize("expand")
end)

w_management:bind('', 'c', 'W_CENTER', function()
  spoon.WinWin:moveAndResize("center")
end)

w_management:bind('', 'y', 'W_NORTHWEST_CORNER', function()
  spoon.WinWin:moveAndResize("cornerNW")
end)

w_management:bind('', 'o', 'W_NORTHEAST_CORNER', function()
  spoon.WinWin:moveAndResize("cornerNE")
end)

w_management:bind('', 'u', 'W_SOUTHWEST_CORNER', function()
  spoon.WinWin:moveAndResize("cornerSW")
end)

w_management:bind('', 'i', 'W_SOUTHEAST_CORNER', function()
  spoon.WinWin:moveAndResize("cornerSE")
end)

w_management:bind('', 'left', 'W_LEFT_MOVE', function()
  spoon.WinWin:stepMove("left")
end,nil,function()
  spoon.WinWin:stepMove("left")
end)

w_management:bind('', 'right', 'W_RIGHT_MOVE', function()
  spoon.WinWin:stepMove("right")
end,nil,function()
  spoon.WinWin:stepMove("right")
end)

w_management:bind('', 'up', 'W_UP_MOVE', function()
  spoon.WinWin:stepMove("up")
end,nil,function()
  spoon.WinWin:stepMove("up")
end)

w_management:bind('', 'down', 'W_DOWN_MOVE', function()
  spoon.WinWin:stepMove("down")
end,nil,function()
  spoon.WinWin:stepMove("down")
end)

-- show window hint
-- w_management:bind('w', 'h', nil, function()
--   spoon.KSheet:toggle()
-- end)

spoon.ModalMgr.supervisor:bind(hyper,'m', "enter w_management", function()
  spoon.ModalMgr:deactivateAll()
  spoon.ModalMgr:activate({"w_management"}, "#B22222")
end)

spoon.ModalMgr.supervisor:enter()

-- CAFFEINE
spoon.Caffeine:start()
spoon.Caffeine:setState(true)

-- hold to quit
spoon.HoldToQuit:start()

-- hammerspoon rounded corners
spoon.RoundedCorners:start()

-- work/life

local function isInOfficeHours()
  local no_of_sec_for_hour = 60*60
  local current_hour = hs.timer.localTime()/no_of_sec_for_hour;
  local inOfficeHours = current_hour >= 8.5 and current_hour <=17.5
  return inOfficeHours
end

local function open_my_apps()
  local my_apps = {}
  if secret.my_apps then
    my_apps = secret.my_apps
  end
  for i = 1, #my_apps do
    hs.application.launchOrFocusByBundleID(my_apps[i])
  end
end

local function open_my_life_apps()
  local my_life_apps = {}
  if secret.my_life_apps then
    my_life_apps = secret.my_life_apps
  end
  for i = 1, #my_life_apps do
    hs.application.launchOrFocusByBundleID(my_life_apps[i])
  end
end

local function openApps()
  if isInOfficeHours() then
    open_my_apps()
  else
    hs.alert.show('opeining my app ')
    open_my_life_apps()
  end
end

if isInOfficeHours() then
  hs.dockicon.setBadge('WORK')
else
  hs.dockicon.setBadge('LIFE')
end
-- set time for switching life
-- https://github.com/Hammerspoon/hammerspoon/issues/2416
mytimer = hs.timer.doAt("17:30",function()
  hs.dockicon.bounce()
  hs.dockicon.setBadge('LIFE')
end):start()

-- SEAL

spoon.Seal:bindHotkeys({ toggle = { {"cmd"}, "Space" }})
spoon.Seal:loadPlugins({"apps", "screencapture", "calc", "useractions", "pasteboard"})
spoon.Seal.plugins.useractions.actions =
{
  ["Tell me something"] = {
    keyword = "tellme",
    fn = function(str)
      hs.alert.show(str)
    end,
  },
  ["Show Clock"] = {
    keyword = "aclock",
    fn = function(str)
      spoon.AClock:toggleShowPersistent()
    end,
  },
  ["amk"] = {
    keyword = "amk",
    fn = function(str)
      local cur_datetime = os.date("%d+%m+%Y+%H+%M+%S")
      local rdm_mail = string.format("%s+%s@%s",secret.username,cur_datetime,secret.tld)
      hs.pasteboard.setContents(rdm_mail)
      hs.alert.show(rdm_mail)
    end,
  },
  ["fu"] = {
    keyword = "fu",
    fn = function(str)
      local cur_datetime = os.date("%d+%m+%Y+%H+%M+%S")
      local rdm_mail = string.format("%s+%s@%s","amk",cur_datetime,"amk")
      hs.pasteboard.setContents(rdm_mail)
      hs.alert.show(rdm_mail)
    end,
  },
  ["random"] = {
    keyword = "random",
    fn = function(str)
      local number = tonumber(str)
      local random_number = math.random(number)
      hs.pasteboard.setContents(random_number)
      hs.alert.show(random_number)
    end,
  },
  ["date"] = {
    keyword = "date",
    fn = function(str)
      local cur_datetime = os.date("%d/%m/%Y %H:%M:%S")
      hs.pasteboard.setContents(cur_datetime)
      hs.alert.show(cur_datetime)
    end,
  },
  ["flb"] = {
    keyword = "flb",
    fn = function(str)
      local minute = tonumber(str)
      if minute == nil then
        minute = 60
      end
      local cur_datetime = os.date("%d/%m/%Y %H:%M:%S")
      local next_time = os.time()+minute*60;
      local fu_datetime = os.date("%d/%m/%Y %H:%M:%S",next_time)
      local my_date_time = string.format("%s - %s",cur_datetime,fu_datetime)
      hs.pasteboard.setContents(my_date_time)
      hs.alert.show(my_date_time)
    end,
  },
  ["win"] = {
    keyword = "win",
    fn = winSwitcher
  },
  ["Make Code Block"] = {
    keyword = "cbl",
    fn = function(str)
      local pasteboard = hs.pasteboard.getContents()
      local codeblock = string.format("```\n%s\n```",pasteboard)
      hs.pasteboard.setContents(codeblock)
    end
  },
  ["Color Dialog"] = {
    keyword = "color",
    fn = function(str)
      hs.dialog.color.show()
    end
  },
  ["Open Apps"] = {
    keyword = "apps",
    fn = openApps
  }
}
spoon.Seal.plugins.pasteboard.historySize=4000
spoon.Seal.chooser:placeholderText("Aung Myo Kyaw")
spoon.Seal.chooser:searchSubText(true)
spoon.Seal:start()
