-- WORK/LIFE
local function isInOfficeHours()
  local no_of_sec_for_hour = 60 * 60
  local current_hour = hs.timer.localTime() / no_of_sec_for_hour;
  local inOfficeHours = current_hour >= 8.5 and current_hour <= 17.5
  local weekday_no = tonumber(os.date('%w'))
  local inWeekEnd = weekday_no == 0 or weekday_no == 6
  return inOfficeHours and not inWeekEnd
end

local function open_my_apps()
  local my_apps = {}
  if secret.my_apps then my_apps = secret.my_apps end
  for i = 1, #my_apps do hs.application.launchOrFocusByBundleID(my_apps[i]) end
end

local function open_my_life_apps()
  local my_life_apps = {}
  if secret.my_life_apps then my_life_apps = secret.my_life_apps end
  for i = 1, #my_life_apps do
    hs.application.launchOrFocusByBundleID(my_life_apps[i])
  end
end

function openApps()
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
lifetimenow = hs.timer.doAt('17:30', function()
  hs.dockicon.bounce()
  hs.dockicon.setBadge('LIFE')
  local mynoti = hs.notify.new({title = 'LIFE', informativeText = 'LIFE 🥶'})
  mynoti:send()
end):start()

worktimenow = hs.timer.doAt('08:30', function()
  hs.dockicon.bounce()
  hs.dockicon.setBadge('WORK')
  local mynoti = hs.notify.new({title = 'WORK', informativeText = 'WORK 🤓'})
  mynoti:send()
end):start()
