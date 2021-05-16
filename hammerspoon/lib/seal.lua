-- global var
local startplaying = true
-- SEAL
if spoon.Seal then
  spoon.Seal:bindHotkeys({ toggle = { {"cmd"}, "Space" }})
  spoon.Seal:loadPlugins({"apps", "screencapture", "calc", "useractions", "pasteboard","urlformats"})
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
    ["date and time"] = {
      keyword = "date",
      fn = function(str)
        local cur_datetime = os.date("%d-%b-%Y %H:%M:%S")
        hs.pasteboard.setContents(cur_datetime)
        hs.alert.show(cur_datetime)
      end,
    },
    ["date only"] = {
      keyword = "dateonly",
      fn = function(str)
        local cur_datetime = os.date("%d-%b-%Y")
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
        local cur_datetime = os.date("%d/%b/%Y %H:%M:%S")
        local next_time = os.time()+minute*60;
        local fu_datetime = os.date("%d/%b/%Y %H:%M:%S",next_time)
        local my_date_time = string.format("%s - %s []",cur_datetime,fu_datetime)
        hs.pasteboard.setContents(my_date_time)
        hs.alert.show(my_date_time)
      end,
    },
    ["curweek"] = {
      keyword = "curweek",
      fn = function(str)
        -- local cur_weekday = os.date("%w")
        local cur_weekday = 6
        local startOfDayTime = os.time()-(cur_weekday-1)*24*60;
        if cur_weekday==0 then
        end
        local start_date_for_week = os.date("%d/%b/%Y",startOfDayTime)
        local my_date_time = string.format("%s - %s []",start_date_for_week,start_date_for_week)
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
        hs.alert.show(codeblock)
      end
    },
    ["Make Code Block With Date"] = {
      keyword = "cbld",
      fn = function(str)
        local pasteboard = hs.pasteboard.getContents()
        local cur_datetime = os.date("%d/%m/%Y %H:%M:%S")
        local codeblock = string.format("```\n%s\n%s\n```",cur_datetime,pasteboard)
        hs.pasteboard.setContents(codeblock)
        hs.alert.show(codeblock)
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
    },
    ["fspam"] = {
      keyword = "fspam",
      fn = function(str)
        -- စာအရှေကြီး
        if str==nil then
          str = "3"
        end
        local no_of_line = tonumber(str);
        local pasteboard = hs.pasteboard.getContents()
        local spam = pasteboard
        for i=2,no_of_line,1
        do
          spam = spam .. '\n' .. pasteboard
        end
        hs.pasteboard.setContents(spam)
        hs.alert.show(pasteboard..no_of_line)
      end
    },
    ["start-playing"] = {
      keyword = "startplaying",
      fn = function(str)
        function playing()
          local mylocation = hs.mouse.getAbsolutePosition()
          mylocation.x = mylocation.x+math.random(-400,400)
          mylocation.y = mylocation.y+math.random(-400,400)
          hs.mouse.setAbsolutePosition(mylocation)
        end
        mouseplayer = hs.timer.new(1, playing)
        mouseplayer:start()
        hs.alert.show("start playing")
      end
    },
    ["stop-playing"] = {
      keyword = "stopplaying",
      fn = function(str)
        mouseplayer:stop()
        hs.alert.show("stop playing")
      end
    },
  }
  spoon.Seal.plugins.pasteboard.historySize=4000
  local urlFormatsProvidersTable = {
    google = { name = "Google", url = "http://google.com/search?q=%s"},
  }
  spoon.Seal.plugins.urlformats:providersTable(urlFormatsProvidersTable)

  spoon.Seal.chooser:placeholderText("Aung Myo Kyaw")
  spoon.Seal.chooser:searchSubText(true)
  spoon.Seal:start()
end
