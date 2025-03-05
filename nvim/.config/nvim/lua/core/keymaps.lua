-- lua/core/keymaps.lua
local map = vim.keymap.set

-- Set leader key
vim.g.mapleader = ' '

-- Insert mode: fast escape
map('i', 'jj', '<Esc>', {noremap = true, silent = true})

-- Window navigation
map('n', '<leader>wl', '<C-W>l', {noremap = true})
map('n', '<leader>wj', '<C-W>j', {noremap = true})
map('n', '<leader>wk', '<C-W>k', {noremap = true})
map('n', '<leader>wh', '<C-W>h', {noremap = true})
map('n', '<leader>wo', '<C-W>o', {noremap = true})

-- Quick quit and save
map('n', '<leader>q', ':q<CR>', {noremap = true, silent = true})
map('n', '<leader>w', ':w<CR>', {noremap = true, silent = true})

-- Basic buffer navigation
map('n', '<leader>bn', ':bn<CR>', {noremap = true})
map('n', '<leader>bp', ':bp<CR>', {noremap = true})
map('n', '<leader>bd', ':bd<CR>', {noremap = true})
