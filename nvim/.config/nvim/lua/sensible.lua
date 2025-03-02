-- Required modules
local g = vim.g
local opt = vim.opt
local map = vim.keymap.set
local fzf = require('fzf-lua')
local Mini = {Basics = require('mini.basics'), Move = require('mini.move')}

-- Load mini.nvim modules efficiently
Mini.Basics.setup({})
Mini.Move.setup()

-- Leader key
g.mapleader = ' '

-- UI Enhancements
opt.termguicolors = true
opt.number = true
opt.relativenumber = false
opt.numberwidth = 4
opt.cursorline = true
opt.colorcolumn = '120'
opt.wrap = false

-- Clipboard
opt.clipboard = 'unnamedplus' -- Use system clipboard

-- Searching
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Performance Tweaks
opt.lazyredraw = true
opt.history = 1000
opt.updatetime = 250
opt.redrawtime = 1500
opt.autowrite = true
opt.laststatus = 3
opt.showcmd = false
opt.ttyfast = true

-- Folding
opt.foldmethod = 'indent'
opt.foldenable = false
map('n', 'zO', 'zA', {noremap = true})
map('n', 'zo', 'za', {noremap = true})

-- Indentation
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.shiftround = true
opt.autoindent = true
opt.smartindent = true
opt.backspace = 'indent,eol,start'
opt.modeline = false

-- Mouse Support
opt.mouse = 'a' -- Enable mouse in all modes

-- Keybindings
map('i', 'jj', '<Esc>', {noremap = true}) -- Fast escape

-- Window Navigation
map('n', '<leader>wl', '<C-W>l', {noremap = true})
map('n', '<leader>wj', '<C-W>j', {noremap = true})
map('n', '<leader>wk', '<C-W>k', {noremap = true})
map('n', '<leader>wh', '<C-W>h', {noremap = true})
map('n', '<leader>wo', '<C-W>o', {noremap = true})

-- Focus Mode (requires focus.nvim plugin)
map('n', '<leader>fh', ':FocusSplitLeft<CR>', {noremap = true, silent = true})
map('n', '<leader>fj', ':FocusSplitDown<CR>', {noremap = true, silent = true})
map('n', '<leader>fk', ':FocusSplitUp<CR>', {noremap = true, silent = true})
map('n', '<leader>fl', ':FocusSplitRight<CR>', {noremap = true, silent = true})
map('n', '<leader>fo', ':FocusMaximise<CR>', {noremap = true, silent = true})

-- Buffer Management
map('n', '<leader>bb', fzf.buffers, {noremap = true, silent = true})
map('n', '<leader>bn', ':bn<CR>', {noremap = true})
map('n', '<leader>bp', ':bp<CR>', {noremap = true})
map('n', '<leader>bd', ':bd<CR>', {noremap = true})

-- Config Reload
map('n', '<leader>vr', function()
  vim.cmd('silent wa')
  dofile(vim.fn.stdpath('config') .. '/init.lua')
  print('Configuration reloaded!')
end, {noremap = true})

-- MiniMove: Move Lines
map('n', '<A-j>', ':MoveLine(1)<CR>', {noremap = true, silent = true})
map('n', '<A-k>', ':MoveLine(-1)<CR>', {noremap = true, silent = true})

-- Quality of Life Improvements
map('n', '<leader>q', ':q<CR>', {noremap = true, silent = true}) -- Quick quit
map('n', '<leader>w', ':w<CR>', {noremap = true, silent = true}) -- Quick save

-- Enable persistent undo
-- opt.undofile = true
-- opt.undodir = vim.fn.stdpath('config') .. '/undo'

-- Improve splits behavior
opt.splitbelow = true
opt.splitright = true

-- Disable swap files for better performance
opt.swapfile = false
opt.backup = false
opt.writebackup = false
