-- SEAL
local secret = require('secret')
if spoon.Seal then
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
    ["Make Code Block With Date"] = {
      keyword = "cbld",
      fn = function(str)
        local pasteboard = hs.pasteboard.getContents()
        local cur_datetime = os.date("%d/%m/%Y %H:%M:%S")
        local codeblock = string.format("```\n%s\n%s\n```",cur_datetime,pasteboard)
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
end
