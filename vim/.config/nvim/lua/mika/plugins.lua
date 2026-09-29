-- This file can be loaded by calling `lua require('plugins')` from your init.vim
-- Once you're happy with this file, you can run `:PackerInstall` from the command line to install the plugins

-- Bootstrap packer on a fresh machine: clone it if missing so `packadd`/`require`
-- below don't fail with "directory not found for packpath".
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    print('Cloning packer.nvim...')
    fn.system({ 'git', 'clone', '--depth', '1',
      'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'folke/tokyonight.nvim'
  use {'neoclide/coc.nvim', branch='release'}
  use "nvim-lua/plenary.nvim"
  use {'nvim-telescope/telescope.nvim', tag = '0.1.8',
      -- or                            , branch = '0.1.x',
       requires = { {'nvim-lua/plenary.nvim'} } }
  use 'github/copilot.vim'
  use { 'junegunn/fzf', run = ":call fzf#install()" }
  use { 'junegunn/fzf.vim' }
  use {
      "ThePrimeagen/harpoon",
      branch = "harpoon2",
      requires = { { "nvim-lua/plenary.nvim" } }
  }

  -- For some reason Packer can't resolve the username or something... So I ran this instead
  -- git clone https://github.com/fatih/vim-go.git ~/.local/share/nvim/site/pack/plugins/start/vim-go
  -- use 'fatih/vim-go.nvim'

  -- On a fresh machine (packer was just cloned above), install everything now.
  if packer_bootstrap then
    require('packer').sync()
  end
end)

