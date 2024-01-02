local VimMode = hs.loadSpoon('VimMode')
local vim = VimMode:new()

-- Basic key binding to ctrl+;
-- You can choose any key binding you want here, see:
--   https://www.hammerspoon.org/docs/hs.hotkey.html#bind
--
-- disable for alacritty

vim:disableForApp('Alacritty')
vim:enableBetaFeature('block_cursor_overlay')
vim:bindHotKeys({enter = {{'ctrl'}, ';'}})
