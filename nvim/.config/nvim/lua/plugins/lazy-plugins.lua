-- lua/plugins/lazy-plugins.lua
local lazy = require("lazy")

local plugins = {
  -- Treesitter for enhanced syntax and parsing
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdateSync",
    event = "BufReadPost",
    opts = {
      ensure_installed = {
        "swift",
        "c",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "javascript",
        "typescript",
        "html",
        "css",
        "json",
        "markdown"
      },
      highlight = {enable = true, additional_vim_regex_highlighting = false},
      indent = {enable = true}
    }
  },

  -- UI Enhancements
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true -- Load when needed by other plugins
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false -- Load immediately to apply the theme early
  },
  {"kyazdani42/nvim-tree.lua", cmd = {"NvimTreeToggle", "NvimTreeFocus"}},
  {
    "lewis6991/gitsigns.nvim",
    dependencies = {"nvim-lua/plenary.nvim"},
    event = "BufReadPre"
  },
  {"ibhagwan/fzf-lua", cmd = "FzfLua"},
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {"nvim-lua/plenary.nvim"},
    cmd = "Telescope"
  },
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "ibhagwan/fzf-lua"
    }
  },
  {"jidn/vim-dbml", ft = "dbml"},
  {
    "MagicDuck/grug-far.nvim",
    dependencies = {"nvim-lua/plenary.nvim"},
    cmd = "GrugFar"
  },
  {"alaviss/nim.nvim", ft = "nim"},

  -- Obsidian note-taking plugin
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    ft = "markdown",
    dependencies = {"nvim-lua/plenary.nvim"}
  },

  -- Terminal integration
  {"akinsho/toggleterm.nvim", version = "*", cmd = "ToggleTerm"},

  -- Jupyter Notebook integration
  {"GCBallesteros/jupytext.nvim", ft = "python"},

  -- LSP and Autocompletion
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    dependencies = {
      {"williamboman/mason.nvim"},
      {"williamboman/mason-lspconfig.nvim"},
      {"neovim/nvim-lspconfig"},
      {"hrsh7th/nvim-cmp"},
      {"hrsh7th/cmp-nvim-lsp"},
      {"L3MON4D3/LuaSnip"},
      {"hrsh7th/cmp-path"}
    },
    event = "BufReadPre"
  },

  -- AI-powered coding assistance
  {"github/copilot.vim"},
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
      "nvim-telescope/telescope.nvim" -- Optional: For using slash commands
    },
    config = function()
      require("codecompanion").setup({
        adapters = {
          http = {
            copilot = function()
              return require("codecompanion.adapters").extend("copilot", {
                schema = {model = {default = "gpt-5-mini"}}
              })
            end
          }
        },
        strategies = {
          chat = {adapter = "copilot"},
          inline = {adapter = "copilot"}
        }
      })
    end
  },

  -- Lightweight utilities and enhancements
  {"echasnovski/mini.nvim", event = "VeryLazy"},

  -- vim-prettier for additional filetypes
  {
    "stevearc/conform.nvim",
    ft = {"javascript", "typescript", "css", "json", "markdown"},
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          javascript = {"prettier"},
          typescript = {"prettier"},
          css = {"prettier"},
          json = {"prettier"},
          markdown = {"prettier"}
        }
      })
    end
  },

  -- which-key for keybinding discovery
  {"folke/which-key.nvim", event = "VeryLazy"},

  {"windwp/nvim-autopairs", event = "InsertEnter"},

  {"kylechui/nvim-surround", event = "ModeChanged"},

  {"nvim-lualine/lualine.nvim", event = "VeryLazy"}
}

local opts = {
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin"
      }
    }
  }
}

lazy.setup(plugins, opts)
