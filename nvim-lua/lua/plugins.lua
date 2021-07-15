local packer = require('packer')
local startup = packer.startup

startup({function(use)
  -- Packer can manage itself
  use {'wbthomason/packer.nvim'}
  ---------------------------
  use	{'Yggdroot/indentLine'}
  use	{'b3nj5m1n/kommentary'}
  use	{'dbeniamine/cheat.sh-vim'}
  use	{'dense-analysis/ale'}
  use	{'easymotion/vim-easymotion'}
  use	{'editorconfig/editorconfig-vim'}
  use	{'heavenshell/vim-jsdoc'}
  use	{'jiangmiao/auto-pairs'}
  use	{'junegunn/vim-easy-align'}
  use	{'kyazdani42/nvim-tree.lua'}
  use	{'marko-cerovac/material.nvim'}
  use	{'mattn/emmet-vim'}
  use	{'neoclide/coc.nvim'}
  use	{'prettier/vim-prettier'}
  use	{'sheerun/vim-polyglot'}
  use	{'tpope/vim-fugitive'}
  use	{'tpope/vim-sensible'}
  use	{'tpope/vim-surround'}
  use	{'vim-scripts/BufOnly.vim'}
  use	{'vimwiki/vimwiki'}
  use	{'wakatime/vim-wakatime'}
  use	{'yamatsum/nvim-cursorline'}
  use {'akinsho/nvim-bufferline.lua', requires = 'kyazdani42/nvim-web-devicons'}
  use {'glepnir/dashboard-nvim'}
  use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'}}
  use {'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/popup.nvim'},{'nvim-lua/plenary.nvim'}}}
  use {'svermeulen/vimpeccable'}
end,
config = {
  ensure_dependencies = true,
  max_jobs = 4,
  git = {
    clone_timeout = 60*3, -- Timeout, in seconds, for git clones
  },
}})
