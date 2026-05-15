vim.opt.guicursor = ""

--vim.opt.number = false 
--vim.opt.relativenumber = false
--vim.o.statuscolumn = "%s %l │ %r"

vim.opt.number = true
vim.opt.relativenumber = true
vim.o.statuscolumn = "%=%{v:lnum} │ %{v:relnum} "
vim.g.netrw_bufsettings = "noma nomod nu nobl nowrap ro rnu"


vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.g.mapleader = ' '
