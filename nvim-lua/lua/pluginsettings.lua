local vimp = require('vimp')
local gitsigns = require('gitsigns')
local g = vim.g
local opt = vim.o

-- themes
-- vim.cmd [[colorscheme tokyonight]]
vim.g.neon_style = "default"
-- default, doom, dark and light
vim.g.neon_bold = true
vim.cmd [[colorscheme neon]]
vim.cmd [[set termguicolors]]
vim.cmd [[let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"]]
vim.cmd [[let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"]]
vim.opt.termguicolors = true
vim.g.tokyonight_style = "night"
----------

require('nvim-cursorline').setup {
  cursorline = {enable = true, timeout = 1000, number = false},
  cursorword = {enable = true, min_length = 3, hl = {underline = true}}
}

-- which key
require("which-key").setup {
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
}

-- vim.cmd [[call FlutterMenu()]]

-- require("focus").setup()

-- nvim tree setup
require'nvim-tree'.setup()
vimp.nnoremap('<C-n>', [[:NvimTreeToggle<cr>]])

-- gitsigns
gitsigns.setup()

-- fterm
vimp.nmap('<leader>ft', "<cmd>lua require('FTerm').toggle()<cr>")

-- status line setup
require('feline').setup()

local configure_language = require('kommentary.config').configure_language
configure_language("nim", {
  single_line_comment_string = "#",
  multi_line_comment_strings = {"#[", "]#"},
  prefer_single_line_comments = true
})
configure_language("default", {prefer_single_line_comments = true})

-- Themes
opt.showtabline = 2

-- bufferline
vim.opt.termguicolors = true
require("bufferline").setup {
  options = {
    show_tab_indicators = true,
    separator_style = 'thick',
    indicator = {
      -- icon = '▎', -- this should be omitted if indicator style is not 'icon'
      style = 'underline'
    }
  }
}

-- macvim  conf
opt.background = "dark"
opt.guifont = "FiraCode Nerd Font Mono:h25"

-- vim easy align
-- Start interactive EasyAlign in visual mode (e.g. vipga)
vimp.xmap('ga', '<Plug>(EasyAlign)')

-- Start interactive EasyAlign for a motion/text object (e.g. gaip)
vimp.nmap('ga', '<Plug>(EasyAlign)')

-- easy motion
vimp.nmap('<Leader><Leader>f', '<Plug>(easymotion-overwin-f)')

-- s{char}{char} to move to {char}{char}
vimp.nmap('s', '<Plug>(easymotion-overwin-f2)')

-- Move to line
vimp.nmap('<Leader><Leader>L', '<Plug>(easymotion-overwin-line)')

-- " Move to word
vimp.nmap('<Leader><Leader>w', '<Plug>(easymotion-overwin-w)')

-- " Turn on case-insensitive feature
g.EasyMotion_smartcase = 1

-- js-docs
g.jsdoc_allow_input_prompt = 1
g.jsdoc_enable_es6 = 1
g.jsdoc_input_description = 1

-- CtrlP
-- vimp.nmap('<C-p>',"<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown({}))<cr>")
vimp.nmap('<C-p>', "<cmd>lua require('telescope.builtin').find_files()<cr>")
vimp.nmap('<leader>ff', "<cmd>lua require('telescope.builtin').find_files()<cr>")

-- " ALE Settings
g.ale_fixers = {'prettier', 'eslint', 'trim_whitespace'}
g.ale_javascript_prettier_options = '--single-quote --trailing-comma none'
g.ale_javascript_prettier_use_local_config = 1
g.ale_disable_lsp = 1
g.ale_fixers.markdown = {'prettier'}
-- " let g:ale_completion_enabled                   = 1
-- " let g:ale_completion_autoimport                = 1
-- " let g:ale_hover_cursor                         = 1
-- " let g:ale_fix_on_save                          = 1

-- ctrlsf
-- vimp.nnoremap('<C-F>f',"<cmd>lua require('telescope.builtin').live_grep()<cr>")
--
vimp.nmap('<C-F>f', "<Plug>CtrlSFPrompt")
vimp.vmap('<C-F>f', "<Plug>CtrlSFVwordPath")
vimp.vmap('<C-F>F', "<Plug>CtrlSFVwordExec")
vimp.nmap('<C-F>n', "<Plug>CtrlSFCwordPath")
vimp.nmap('<C-F>p', "<Plug>CtrlSFPwordPath")
vimp.nnoremap('<C-F>o', ":CtrlSFOpen<CR>")
vimp.nnoremap('<C-F>t', ":CtrlSFToggle<CR>")
vimp.inoremap('<C-F>t', "<Esc>:CtrlSFToggle<CR>")

vimp.nnoremap('<leader>fg',
              "<cmd>lua require('telescope.builtin').live_grep()<cr>")

-- telescope commands
vimp.nnoremap('<leader>fc',
              "<cmd>lua require('telescope.builtin').commands()<cr>")

-- ----------------------------------------------------------------------------------------------------
-- VIM WIKI
-- ----------------------------------------------------------------------------------------------------
g.vimwiki_global_ext = 0
local mywiki = {}
mywiki.path = '/Users/aungmyokyaw/MEGAsync/aungmyokyaw/MyWiki'
mywiki.syntax = 'markdown'
mywiki.ext = '.md'
g.vimwiki_list = {mywiki}
g.vimwiki_folding = 'expr'

-- vim rest setting
g.vrc_curl_opts = {}
g.vrc_curl_opts['-i'] = ''

-- " vim polyglot
g.vim_markdown_conceal = 0
g.vim_markdown_conceal_code_blocks = 0

-- code completiong
g.coq_settings = {auto_start = 'shut-up'}
require("coq")
