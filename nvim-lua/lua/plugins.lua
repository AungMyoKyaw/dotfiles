local packer = require('packer')
local startup = packer.startup

startup({function(use)
  -- Packer can manage itself
  use {'wbthomason/packer.nvim'}
  ---------------------------
  use	{'b3nj5m1n/kommentary'}
  use	{'dbeniamine/cheat.sh-vim'}
  use	{'dense-analysis/ale'}
  use	{'easymotion/vim-easymotion'}
  use	{'editorconfig/editorconfig-vim'}
  use	{'jiangmiao/auto-pairs'}
  use	{'junegunn/vim-easy-align'}
  use	{'kyazdani42/nvim-tree.lua'}
  use	{'lukas-reineke/indent-blankline.nvim'}
  use	{'bluz71/vim-nightfly-guicolors'}
  use	{'mattn/emmet-vim'}
  use	{'prettier/vim-prettier'}
  use	{'sheerun/vim-polyglot'}
  use	{'tpope/vim-fugitive'}
  use	{'tpope/vim-sensible'}
  use	{'tpope/vim-surround'}
  use	{'vim-scripts/BufOnly.vim'}
  use	{'vimwiki/vimwiki'}
  use	{'yamatsum/nvim-cursorline'}
  use { 'hoob3rt/lualine.nvim', requires = {'kyazdani42/nvim-web-devicons', opt = true}}
  use {'akinsho/nvim-bufferline.lua', requires = 'kyazdani42/nvim-web-devicons'}
  use {'glepnir/dashboard-nvim'}
  use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'}}
  use {'numtostr/FTerm.nvim'}
  use {'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/popup.nvim'},{'nvim-lua/plenary.nvim'}}}
  use {'svermeulen/vimpeccable'}
  use {'jidn/vim-dbml'}
  use {'dyng/ctrlsf.vim'}
  use {'zhaozg/vim-diagram'}
  use {'github/copilot.vim'}
  -- use { "beauwilliams/focus.nvim" }
end,
config = {
  ensure_dependencies = true,
  -- max_jobs = 0,
  git = {
    clone_timeout = 60*10, -- Timeout, in seconds, for git clones
  },
}})
