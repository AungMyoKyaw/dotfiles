local packer = require('packer')
local startup = packer.startup

startup({
  function(use)
    -- Packer can manage itself
    use {'wbthomason/packer.nvim'}
    ---------------------------
    use {'lewis6991/impatient.nvim'}
    -- treesiter
    use({'nvim-treesitter/nvim-treesitter', run = ':TSUpdateSync'})
    -- themes
    use {'folke/tokyonight.nvim'}
    use {'nvim-lualine/lualine.nvim'}
    use {'kyazdani42/nvim-tree.lua'}
    use {'yamatsum/nvim-cursorline'}
    use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'}}
    use {
      'nvim-telescope/telescope.nvim',
      requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
    }
    ----------------
    use {'b3nj5m1n/kommentary'}
    use {'dbeniamine/cheat.sh-vim'}
    use {'easymotion/vim-easymotion'}
    use {'editorconfig/editorconfig-vim'}
    use {'jiangmiao/auto-pairs'}
    use {'junegunn/vim-easy-align'}
    use {'lukas-reineke/indent-blankline.nvim'}
    use {'mattn/emmet-vim'}
    use {'prettier/vim-prettier'}
    use {'tpope/vim-fugitive'}
    use {'tpope/vim-sensible'}
    use {'tpope/vim-surround'}
    use {'vim-scripts/BufOnly.vim'}
    use {'vimwiki/vimwiki'}
    use {'folke/which-key.nvim'}
    use {'numtostr/FTerm.nvim'}
    use {'svermeulen/vimpeccable'}
    use {'dyng/ctrlsf.vim'}
    -- languages plugins that not supported by treesitter
    use {'jidn/vim-dbml'}
    use {'zhaozg/vim-diagram'}
    use {'alaviss/nim.nvim'}
    --------------------
    -- auto complete deps
    use {
      'VonHeikemen/lsp-zero.nvim',
      requires = {
        -- LSP Support
        {'neovim/nvim-lspconfig'}, {'williamboman/mason.nvim'},
        {'williamboman/mason-lspconfig.nvim'}, -- Autocompletion
        {'hrsh7th/nvim-cmp'}, {'hrsh7th/cmp-buffer'}, {'hrsh7th/cmp-path'},
        {'saadparwaiz1/cmp_luasnip'}, {'hrsh7th/cmp-nvim-lsp'},
        {'hrsh7th/cmp-nvim-lua'}, -- Snippets
        {'L3MON4D3/LuaSnip'}, {'rafamadriz/friendly-snippets'}
      }
    }
    use {'github/copilot.vim'}
    ----------------------------
  end,
  config = {
    ensure_dependencies = true,
    -- max_jobs = 0,
    git = {
      clone_timeout = 60 * 10 -- Timeout, in seconds, for git clones
    }
  }
})
