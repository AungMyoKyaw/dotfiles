local packer = require('packer')
local startup = packer.startup

startup({
  function(use)
    -- Packer can manage itself
    use {'wbthomason/packer.nvim'}
    ---------------------------
    use {'lewis6991/impatient.nvim'}
    use {'b3nj5m1n/kommentary'}
    use {'dbeniamine/cheat.sh-vim'}
    use {'dense-analysis/ale'}
    use {'easymotion/vim-easymotion'}
    use {'editorconfig/editorconfig-vim'}
    use {'jiangmiao/auto-pairs'}
    use {'junegunn/vim-easy-align'}
    use {'kyazdani42/nvim-tree.lua'}
    use {'lukas-reineke/indent-blankline.nvim'}
    use {'folke/tokyonight.nvim'}
    -- use {'rafamadriz/neon'}
    -- use {'projekt0n/github-nvim-theme'}
    use {'mattn/emmet-vim'}
    use {'prettier/vim-prettier'}
    use {'sheerun/vim-polyglot'}
    use {'tpope/vim-fugitive'}
    use {'tpope/vim-sensible'}
    use {'tpope/vim-surround'}
    use {'vim-scripts/BufOnly.vim'}
    use {'vimwiki/vimwiki'}
    use {'yamatsum/nvim-cursorline'}
    use {'feline-nvim/feline.nvim'}
    use {'folke/which-key.nvim'}
    use {
      'akinsho/bufferline.nvim',
      tag = "v2.*",
      requires = 'kyazdani42/nvim-web-devicons'
    }
    use {
      'goolord/alpha-nvim',
      requires = {'kyazdani42/nvim-web-devicons'},
      config = function()
        require'alpha'.setup(require'alpha.themes.startify'.config)
      end
    }
    use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'}}
    use {'numtostr/FTerm.nvim'}
    use {
      'nvim-telescope/telescope.nvim',
      requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
    }
    use {'svermeulen/vimpeccable'}
    use {'jidn/vim-dbml'}
    use {'dyng/ctrlsf.vim'}
    use {'zhaozg/vim-diagram'}
    use {'lervag/vimtex'}
    -- use {'github/copilot.vim'}
    ----------------------------
    use {'dart-lang/dart-vim-plugin'}
    use {'thosakwe/vim-flutter'}
    use {'othree/html5.vim'}
    use {'evanleck/vim-svelte'}
    --------
    -- auto complete deps
    use {'neovim/nvim-lspconfig'}
    use {'hrsh7th/cmp-nvim-lsp'}
    use {'hrsh7th/cmp-buffer'}
    use {'hrsh7th/cmp-path'}
    use {'hrsh7th/cmp-cmdline'}
    use {'hrsh7th/nvim-cmp'}

    use {"williamboman/mason.nvim"}
    use {"williamboman/mason-lspconfig.nvim"}

    -- " For vsnip users.
    use {'hrsh7th/cmp-vsnip'}
    use {'hrsh7th/vim-vsnip'}

    -- " For luasnip users.
    -- " Plug 'L3MON4D3/LuaSnip'
    -- " Plug 'saadparwaiz1/cmp_luasnip'

    -- " For ultisnips users.
    -- " Plug 'SirVer/ultisnips'
    -- " Plug 'quangnguyen30192/cmp-nvim-ultisnips'

    -- " For snippy users.
    -- " Plug 'dcampos/nvim-snippy'
    -- " Plug 'dcampos/cmp-snippy'
  end,
  config = {
    ensure_dependencies = true,
    -- max_jobs = 0,
    git = {
      clone_timeout = 60 * 10 -- Timeout, in seconds, for git clones
    }
  }
})
