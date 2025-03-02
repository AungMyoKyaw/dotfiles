local map = vim.keymap.set

-- Ensure `vim` is recognized as a global
_G.vim = vim

-- Load required modules
local mini = {
  statusline = require('mini.statusline'),
  surround = require('mini.surround'),
  cursorword = require('mini.cursorword'),
  comment = require('mini.comment'),
  pairs = require('mini.pairs'),
  indentscope = require('mini.indentscope'),
  tabline = require('mini.tabline'),
  jump = require('mini.jump'),
  bufremove = require('mini.bufremove'),
  align = require('mini.align')
}

local catppuccin = require('catppuccin')
local gitsigns = require('gitsigns')
local toggleterm = require('toggleterm')
local treesitter = require('nvim-treesitter.configs')
local fzf_lua = require('fzf-lua')
local obsidian = require('obsidian')
local jupytext = require('jupytext')
local nvim_tree = require('nvim-tree')
local grug_far = require('grug-far')

-- Grug-Far setup
grug_far.setup({
  engines = {
    ripgrep = {path = 'rg', extraArgs = '--hidden --glob !.git --ignore-case'}
  }
})

-- Theme using catppuccin
catppuccin.setup({
  flavour = 'mocha',
  integrations = {
    cmp = true,
    gitsigns = true,
    mason = true,
    nvimtree = true,
    treesitter = true,
    treesitter_context = true,
    vimwiki = true,
    which_key = true
  }
})
vim.cmd.colorscheme 'catppuccin'

-- Setup mini.nvim modules
for _, mod in pairs(mini) do mod.setup() end

-- Gitsigns setup
gitsigns.setup()

-- Terminal setup
toggleterm.setup()
map('n', '<leader>ft', ':ToggleTerm<CR>', {noremap = true, silent = true})

-- Use mini.statusline instead of lualine
mini.statusline.setup()

-- Easymotion alternative using mini.jump
map('n', '<Leader><Leader>f', function() mini.jump.jump('f') end,
    {noremap = true, silent = true})

-- Treesitter setup
treesitter.setup({
  auto_install = true,
  highlight = {enable = true, additional_vim_regex_highlighting = false}
})

-- FZF-Lua and Obsidian setup
fzf_lua.setup({winopts = {preview = {hidden = 'right:0'}}})
local personal_path = os.getenv('OBSIDIAN_PERSONAL_PATH')

if personal_path and personal_path ~= '' then
  obsidian.setup({
    workspaces = {{name = 'personal', path = vim.fn.expand(personal_path)}},
    picker = {name = 'fzf-lua'},
    sort_by = 'modified',
    open_notes_in = 'vsplit',
    ui = {enable = false}
  })
end
map('n', '<leader>ww', ':ObsidianQuickSwitch<CR>',
    {noremap = true, silent = true})
map('n', '<leader>ws', ':ObsidianSearch<CR>', {noremap = true, silent = true})

-- Mini.nvim bufferline and tabline
mini.tabline.setup({show_icons = true})

-- Indent guides
mini.indentscope.setup({symbol = '│', options = {try_as_border = true}})

-- Jupytext integration
jupytext.setup({style = 'light', output_extension = 'auto'})

-- Fuzzy file finding
map('n', '<C-p>', ':FzfLua files<CR>', {noremap = true, silent = true})

-- Nvim-tree setup
nvim_tree.setup({renderer = {highlight_opened_files = 'all'}})
map('n', '<C-n>', ':NvimTreeToggle<CR>', {noremap = true, silent = true})

-- Grug-Far integration
map({'n', 'v'}, '<C-F>f', function()
  local mode, search_text = vim.fn.mode(), ''

  if mode == 'v' then
    vim.cmd('normal! "vy')
    search_text = vim.fn.getreg('v')
  else
    search_text = vim.fn.expand('<cword>') ~= '' and vim.fn.expand('<cword>') or
                      vim.fn.getreg('/')
  end

  grug_far.open({default_text = search_text})
end, {
  noremap = true,
  silent = true,
  desc = 'Open Grug-Far with selection or cursor word'
})

-- Mini.bufremove keybindings (replacing BufOnly.vim)
map('n', '<leader>bd', function() mini.bufremove.delete(0, true) end,
    {noremap = true, silent = true, desc = 'Delete current buffer'})

map('n', '<leader>bw', function() mini.bufremove.wipeout(0, true) end,
    {noremap = true, silent = true, desc = 'Wipeout current buffer'})

vim.api.nvim_create_user_command('BufOnly', function()
  local current_buf = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf) then
      mini.bufremove.delete(buf, true)
    end
  end
end, {})
