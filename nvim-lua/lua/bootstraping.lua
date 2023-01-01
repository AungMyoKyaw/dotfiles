local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({
    'git', 'clone', 'git@github.com:wbthomason/packer.nvim.git', install_path
  })
  execute 'packadd packer.nvim'
end
