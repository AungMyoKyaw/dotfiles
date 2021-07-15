local vimp = require('vimp')
local g    = vim.g
local opt  = vim.o

-- Leader
g.mapleader = " "

g.termguicolors = true

-- clipboard
opt.clipboard="unnamed,unnamedplus"

-- remap jj to <esc>
vimp.inoremap('jj','<esc>')

-- Split Navigation
vimp.nnoremap('<C-J>','<C-W><C-J>')
vimp.nnoremap('<C-K>','<C-W><C-K>')
vimp.nnoremap('<C-L>','<C-W><C-L>')
vimp.nnoremap('<C-H>','<C-W><C-H>')
-- vimp.nnoremap('<C-O>','<C-W><C-O>')

-- Folding
opt.fdm        = "indent"
opt.foldenable = false
vimp.nnoremap('zO','zA')
vimp.nnoremap('zo','za')

-- Numbers
opt.number      = true
opt.numberwidth = 4
opt.textwidth   = 80
opt.colorcolumn = "120"

-- Control + s for vim
vimp.inoremap('<C-S>','<esc>:w<cr>i')

-- next buffer
vimp.nnoremap('<leader>bn',':bn<cr>')
vimp.nnoremap('<leader>bp',':bp<cr>')

-- delete buffer
vimp.nnoremap('<leader>bd', function()
  vim.cmd('bd')
end)

-- delete other buffer
vimp.nnoremap('<leader>bD', function()
  vim.cmd('BufOnly')
end)

-- buffer list
vimp.nnoremap('<leader>bb', function()
  -- vim.cmd("lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown({}))")
  vim.cmd("lua require('telescope.builtin').buffers()")
end)

-- reload vimrc
vimp.nnoremap('<leader>vr', function()
  -- Remove all previously added vimpeccable maps
  vimp.unmap_all()
  -- Unload the lua namespace so that the next time require('config.X') is called
  -- it will reload the file
  -- require("config.util").unload_lua_namespace('config')
  -- Make sure all open buffers are saved
  vim.cmd('silent wa')
  -- Execute our vimrc lua file again to add back our maps
  dofile(vim.fn.stdpath('config') .. '/init.lua')
  print("Reloaded vimrc!")
end)

opt.cul      = true
opt.hlsearch = true

-- CASE INSENSITIVE COMMANDS
opt.ignorecase = true
opt.smartcase  = true

-- enable tty fast
opt.ttyfast=true

-- lazyredraw
opt.lazyredraw = true

-- redrawtime
opt.redrawtime = 10000

-- nowrap
opt.wrap = false

-- thoughtbot
opt.backspace   = '2'
opt.backup      = false
opt.writebackup = false
opt.swapfile    = false
opt.history     = 50
opt.ruler       = true
opt.showcmd     = true
opt.incsearch   = true
opt.laststatus  = 2
opt.autowrite   = true
opt.modelines   = 0
opt.modeline    = false

-- vim sensible
vim.cmd('runtime! plugin/sensible.vim')
