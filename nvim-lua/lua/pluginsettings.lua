local vimp = require('vimp')
local gitsigns = require('gitsigns')
local g = vim.g
local opt = vim.o

-- themes
vim.cmd [[colorscheme tokyonight-moon]]
vim.cmd [[let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"]]
vim.cmd [[let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"]]
----------

require('nvim-cursorline').setup {
  cursorline = {enable = true, timeout = 0000, number = false},
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
require("nvim-tree").setup {renderer = {highlight_opened_files = "all"}}
vimp.nnoremap('<C-n>', [[:NvimTreeToggle<cr>]])

-- gitsigns
gitsigns.setup()

-- fterm
local fterm = require("FTerm")
vimp.nnoremap('<leader>ft', fterm.toggle)

-- status line setup
require('lualine').setup {options = {theme = 'tokyonight'}}

local configure_language = require('kommentary.config').configure_language
configure_language("nim", {
  single_line_comment_string = "#",
  multi_line_comment_strings = {"#[", "]#"},
  prefer_single_line_comments = true
})
configure_language("default", {prefer_single_line_comments = true})

-- no more bufferline
opt.showtabline = 0

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

-- telescope
local builtin = require('telescope.builtin')
vimp.nnoremap('<C-p>', builtin.find_files)
vimp.nnoremap('<leader>ff', builtin.find_files)
vimp.nnoremap('<leader>fg', builtin.live_grep)
vimp.nnoremap('<leader>fc', builtin.commands)

-- ctrlsf
vimp.nmap('<C-F>f', "<Plug>CtrlSFPrompt")
vimp.vmap('<C-F>f', "<Plug>CtrlSFVwordPath")
vimp.vmap('<C-F>F', "<Plug>CtrlSFVwordExec")
vimp.nmap('<C-F>n', "<Plug>CtrlSFCwordPath")
vimp.nmap('<C-F>p', "<Plug>CtrlSFPwordPath")
vimp.nnoremap('<C-F>o', ":CtrlSFOpen<CR>")
vimp.nnoremap('<C-F>t', ":CtrlSFToggle<CR>")
vimp.inoremap('<C-F>t', "<Esc>:CtrlSFToggle<CR>")

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

-- telescope
require('telescope').setup({
  defaults = {theme = "dropdown"}
  -- other configuration values here
})

-- nvim-treesitter

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = {
    "help", "javascript", "typescript", "c", "lua", "rust", "svelte", "vim",
    "css", "html", "json", "markdown"
  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then return true end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your esditor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = {"nim"}
  }
}

------------------------------
