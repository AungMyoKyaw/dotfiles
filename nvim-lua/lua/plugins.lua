local packer = require('packer')
local startup = packer.startup

startup({
  function(use)
    -- Packer can manage itself
    use {'wbthomason/packer.nvim'}
    ---------------------------
    -- Treesitter
    use({'nvim-treesitter/nvim-treesitter', run = ':TSUpdateSync'})
    -- Themes
    use {'catppuccin/nvim', as = 'catppuccin'}
    use {'kyazdani42/nvim-tree.lua'}
    use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'}}
    use {'lukas-reineke/indent-blankline.nvim'}
    use {'nvim-lualine/lualine.nvim'}
    use {'junegunn/fzf'}
    use {'junegunn/fzf.vim'}
    use {'norcalli/nvim-colorizer.lua'}
    use {'xiyaowong/nvim-transparent'}
    ----------------
    use {'b3nj5m1n/kommentary'}
    use {'JoosepAlviste/nvim-ts-context-commentstring'}
    use {'dbeniamine/cheat.sh-vim'}
    use {'easymotion/vim-easymotion'}
    use {'editorconfig/editorconfig-vim'}
    use {'jiangmiao/auto-pairs'}
    use {'junegunn/vim-easy-align'}
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
    use {'danymat/neogen'}
    use {'mhartington/formatter.nvim'}
    use {'nvim-pack/nvim-spectre'}
    -- languages plugins that not supported by treesitter
    use {'jidn/vim-dbml'}
    use {'zhaozg/vim-diagram'}
    use {'alaviss/nim.nvim'}
    -- lsp and completion plugins
    use {
      'VonHeikemen/lsp-zero.nvim',
      branch = 'v3.x',
      requires = {
        --- Uncomment the two plugins below if you want to manage the language servers from neovim
        {'williamboman/mason.nvim'}, {'williamboman/mason-lspconfig.nvim'},

        {'neovim/nvim-lspconfig'}, {'hrsh7th/nvim-cmp'},
        {'hrsh7th/cmp-nvim-lsp'}, {'L3MON4D3/LuaSnip'}
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
