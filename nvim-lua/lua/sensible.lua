local vimp = require('vimp')
local g = vim.g
local opt = vim.opt

-- vim sensible
vim.cmd('runtime! plugin/sensible.vim')

-- Leader
g.mapleader = " "

g.termguicolors = true

-- clipboard
opt.clipboard = "unnamed,unnamedplus"

-- remap jj to <esc>
vimp.inoremap('jj', '<esc>')

-- Split Navigation
-- vim.cmd[[nnoremap <C-L> <C-W><C-L>]]
-- vim.cmd[[nnoremap <C-J> <C-W><C-J>]]
-- vim.cmd[[nnoremap <C-K> <C-W><C-K>]]
-- vim.cmd[[nnoremap <C-H> <C-W><C-H>]]
-- vim.cmd[[nnoremap <C-O> <C-W><C-O>]]
vim.cmd [[nnoremap <leader>wl <C-W><C-L>]]
vim.cmd [[nnoremap <leader>wj <C-W><C-J>]]
vim.cmd [[nnoremap <leader>wk <C-W><C-K>]]
vim.cmd [[nnoremap <leader>wh <C-W><C-H>]]
vim.cmd [[nnoremap <leader>wo <C-W><C-O>]]
-- vimp.nnoremap('<C-j>','<C-W><C-J>')
-- vimp.nnoremap('<C-k>','<C-W><C-K>')
-- vimp.nnoremap('<C-l>','<C-W><C-L>')
-- vimp.nnoremap('<C-h>','<C-W><C-H>')
-- vimp.nnoremap('<C-o>','<C-W><C-O>')

vimp.nmap('<leader>fh', ':FocusSplitLeft<CR>')
vimp.nmap('<leader>fj', ':FocusSplitDown<CR>')
vimp.nmap('<leader>fk', ':FocusSplitUp<CR>')
vimp.nmap('<leader>fl', ':FocusSplitRight<CR>')
vimp.nmap('<leader>fo', ':FocusMaximise<CR>')

-- Folding
opt.fdm = "indent"
opt.foldenable = false
vimp.nnoremap('zO', 'zA')
vimp.nnoremap('zo', 'za')

-- Numbers
opt.number = true
opt.numberwidth = 4
opt.textwidth = 80
opt.colorcolumn = "120"

-- Control + s for vim
vimp.inoremap('<C-S>', '<esc>:w<cr>i')

-- next buffer
vimp.nnoremap('<leader>bn', ':bn<cr>')
vimp.nnoremap('<leader>bp', ':bp<cr>')

-- delete buffer
vimp.nnoremap('<leader>bd', function() vim.cmd('bd') end)

-- delete other buffer
vimp.nnoremap('<leader>bD', function() vim.cmd('BufOnly') end)

-- buffer list
vimp.nnoremap('<leader>bb', function()
  -- vim.cmd("lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown({}))")
  -- vim.cmd("lua require('telescope.builtin').buffers({ sort_lastused = true, ignore_current_buffer = true })")
  vim.cmd(
      "lua require('telescope.builtin').buffers({ sort_mru = true, ignore_current_buffer = true })")
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

opt.cul = true
opt.hlsearch = true

-- CASE INSENSITIVE COMMANDS
opt.ignorecase = true
opt.smartcase = true

-- enable tty fast
opt.ttyfast = true

-- lazyredraw
opt.lazyredraw = true

-- redrawtime
opt.redrawtime = 10000

-- nowrap
opt.wrap = false

-- thoughtbot
opt.backspace = '2'
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.history = 50
opt.ruler = true
opt.showcmd = true
opt.incsearch = true
opt.laststatus = 2
opt.autowrite = true
opt.modelines = 0
opt.modeline = false

-- indent size
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2 -- Tab key indents by 2 spaces.
opt.shiftwidth = 2 -- >> indents by 2 spaces.
opt.shiftround = true -- >> indents to next multiple of 'shiftwidth'.
opt.autoindent = true
opt.smartindent = true

--- nvim tree
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
