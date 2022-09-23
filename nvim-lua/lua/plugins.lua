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
    -- use {'folke/tokyonight.nvim'}
    use {'rafamadriz/neon'}
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
    -- use {'github/copilot.vim'}
    ----------------------------
    use {'dart-lang/dart-vim-plugin'}
    use {'thosakwe/vim-flutter'}
    use {'othree/html5.vim'}
    use {'evanleck/vim-svelte'}
    --------
    -- code completion
    -- " main one
    use {'ms-jpq/coq_nvim', branch = 'coq'}
    -- " 9000+ Snippets
    use {'ms-jpq/coq.artifacts', branch = 'artifacts'}
    -- " lua & third party sources -- See https://github.com/ms-jpq/coq.thirdparty
    -- " Need to **configure separately**
    use {'ms-jpq/coq.thirdparty', branch = '3p'}
    -- " - shell repl
    -- " - nvim lua api
    -- " - scientific calculator
    -- " - comment banner
    -- " - etc
  end,
  config = {
    ensure_dependencies = true,
    -- max_jobs = 0,
    git = {
      clone_timeout = 60 * 10 -- Timeout, in seconds, for git clones
    }
  }
})
