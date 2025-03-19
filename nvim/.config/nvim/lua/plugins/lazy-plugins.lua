-- lua/plugins/lazy-plugins.lua
local lazy = require('lazy')

local plugins = {
  -- Treesitter for enhanced syntax and parsing
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdateSync',
    event = 'BufReadPost'
  },

  -- UI Enhancements
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false -- Load immediately to apply the theme early
  },
  {'kyazdani42/nvim-tree.lua', cmd = 'NvimTreeToggle'},
  {
    'lewis6991/gitsigns.nvim',
    dependencies = {'nvim-lua/plenary.nvim'},
    event = 'BufReadPre'
  },
  {'ibhagwan/fzf-lua', cmd = 'FzfLua'},
  {'tpope/vim-fugitive', cmd = 'Git'},
  {'jidn/vim-dbml', ft = 'dbml'},
  {
    'MagicDuck/grug-far.nvim',
    dependencies = {'nvim-lua/plenary.nvim'},
    cmd = 'GrugFar'
  },
  {'alaviss/nim.nvim', ft = 'nim'},

  -- Obsidian note-taking plugin
  {
    'epwalsh/obsidian.nvim',
    version = '*',
    ft = 'markdown',
    dependencies = {'nvim-lua/plenary.nvim'}
  },

  -- Terminal integration
  {'akinsho/toggleterm.nvim', version = '*', cmd = 'ToggleTerm'},

  -- Jupyter Notebook integration
  {'GCBallesteros/jupytext.nvim', ft = 'python'},

  -- LSP and Autocompletion
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},
      {'neovim/nvim-lspconfig'},
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'L3MON4D3/LuaSnip'},
      {'hrsh7th/cmp-path'}
    },
    event = 'BufReadPre'
  },

  -- AI-powered coding assistance
  {'github/copilot.vim'},

  -- Lightweight utilities and enhancements
  {'echasnovski/mini.nvim', event = 'VeryLazy'},

  -- vim-prettier for additional filetypes
  {'prettier/vim-prettier'},

  -- which-key for keybinding discovery
  {'folke/which-key.nvim'},

  {'windwp/nvim-autopairs'},

  {'kylechui/nvim-surround'}
}

local opts = {
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin'
      }
    }
  }
}

lazy.setup(plugins, opts)
