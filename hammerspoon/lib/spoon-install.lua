-- SPOON INSTALL
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
