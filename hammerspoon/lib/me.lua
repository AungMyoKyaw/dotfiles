date = require('date')
local function reloadConfig()
  if spoon.Seal.chooser then
    spoon.Seal.chooser:hide()
    spoon.Seal.chooser:delete()
  end
  spoon.SpoonInstall:asyncUpdateAllRepos()
  hs.reload()
end
hs.hotkey.bind(hyper, "r", 'reload config', reloadConfig)

spoon.FadeLogo.image = hs.image.imageFromName(hs.image.systemImageNames.ApplicationIcon)
spoon.FadeLogo:start()

local function showConsole()
  hs.application.launchOrFocusByBundleID('org.hammerspoon.Hammerspoon')
end
hs.hotkey.bind(hyper, "o", 'show console', showConsole)

-- cpu usage
local function cpuTimer()
  hs.host.cpuUsage(1,function(data)
    hs.dockicon.setBadge(string.format("%02d", math.floor(data.overall.active)))
  end)
end
cpuTimer()
cpuusageTimer = hs.timer.doEvery(1,cpuTimer)
cpuusageTimer:start()

-- local function  clock()
--   hs.dockicon.setBadge(date():fmt("%I:%M %p"))
-- end
-- clock()
-- dockclock = hs.timer.doEvery(1,clock)
-- dockclock:start()

local timersec = -1
local stopWatch = false
local mybar = hs.menubar.new()
function setTimer()
  -- todo: timer
  local textPromptMessage = "TIMER"
  local promptInformativeText = "SET IN MIN"
  local minute = hs.dialog.textPrompt(textPromptMessage, promptInformativeText, "0")
end

function setStopWatch()
  stopWatch = true
  timersec = -1
end

function setPomodoroMin(num)
  timersec = num*60
  spoon.FadeLogo.image = hs.image.imageFromURL("https://avatars.githubusercontent.com/u/9404824?v=4")
  spoon.FadeLogo:start()
end

function startPomodoroMenu()
  setPomodoroMin(45)
end

function startPomodoroBreakMenu()
  setPomodoroMin(10)
end

function resetPomodoroBreakMenu()
  setPomodoroMin(-1)
  stopWatch = false
end

local function startPlay()
  function playing()
    local mylocation = hs.mouse.getAbsolutePosition()
    mylocation.x = mylocation.x+math.random(-400,400)
    mylocation.y = mylocation.y+math.random(-400,400)
    -- hs.mouse.setAbsolutePosition(mylocation)
    -- local lorem = hs.http.doRequest("http://metaphorpsum.com/sentences/3","GET")
    local lorem = hs.execute("curl http://metaphorpsum.com/sentences/3")
    -- local lorem = "A nest is a towered muscle."
    -- hs.inspect.inspect(lorem)
    hs.eventtap.keyStrokes(lorem)
  end
  typistplayer = hs.timer.new(10, playing)
  typistplayer:start()
  hs.alert.show("start playing")
end

local function stopPlay()
  mouseplayer:stop()
  hs.alert.show("stop playing")
end

menuTable =  {
  { title = "START POMODORO", fn = startPomodoroMenu },
  { title = "START POMODORO BREAK", fn = startPomodoroBreakMenu },
  { title = "-" },
  { title = "STOPWATCH", fn = setStopWatch },
  { title = "TIMER", fn = setTimer },
  { title = "-" },
  { title = "RESET", fn = resetPomodoroBreakMenu },
  { title = "-" },
  -- { title = "start-play", fn = startPlay },
  -- { title = "stop-play", fn = stopPlay },
}
mybar:setMenu(menuTable)
local function playSessionEndSound()
  print('playing')
end

local function formatTime(num)
  local timeFormatStr = ""
  local noOfSecondsInMinute = 60
  local minute = math.floor(num/noOfSecondsInMinute)
  local second = num%noOfSecondsInMinute
  timeFormatStr = string.format("%02d",minute) .. ":".. string.format("%02d",second)
  return timeFormatStr
end

local function updateTimeOnMenuBar()
  if timersec < 0 then
    mybar:setTitle("👨🏻‍💻✨👩🏻‍💻")
  else
    -- todo: animate
    mybar:setTitle("working => "..formatTime(timersec))
  end
end

local function Pomodoro()
  -- todo: persistent data
  if timersec > 0 and not stopWatch then
    timersec = timersec - 1
  end
  if stopWatch then
    timersec = timersec + 1
  end
  if timersec == 0 and not stopWatch then
    spoon.FadeLogo:start()
    timersec = -1
  end
  updateTimeOnMenuBar()
end
Pomodoro()
pomodoroTimer = hs.timer.doEvery(1,Pomodoro)
pomodoroTimer:start()

hs.hotkey.bind(hyper, 'v', 'type-pastes', function()
  hs.eventtap.keyStrokes(hs.pasteboard.getContents())
end)

hs.hotkey.bind(hyper, 'a', 'type-pastes', function()
  hs.alert("updating brew")
  local shellresult = hs.execute("brew_update")
end)

