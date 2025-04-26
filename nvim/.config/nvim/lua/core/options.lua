-- lua/core/options.lua
local opt = vim.opt

-- Ensure `vim` is recognized as a global
_G.vim = vim

-- UI Options
opt.termguicolors = true
opt.number = true
opt.numberwidth = 4
opt.cursorline = true
opt.colorcolumn = "120"
opt.wrap = false

-- Clipboard
opt.clipboard = "unnamedplus"

-- Search settings
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Performance tweaks
opt.lazyredraw = true
opt.history = 1000
opt.updatetime = 250
opt.redrawtime = 1500
opt.autowrite = true
opt.laststatus = 3
opt.showcmd = false
opt.ttyfast = true

-- Folding
opt.foldmethod = "indent"
opt.foldenable = false

-- Indentation
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.shiftround = true
opt.autoindent = true
opt.smartindent = true
opt.backspace = "indent,eol,start"
opt.modeline = false

-- Mouse support
opt.mouse = "a"

-- Split behavior
opt.splitbelow = true
opt.splitright = true

-- Disable swap and backup files for performance
opt.swapfile = false
opt.backup = false
opt.writebackup = false
