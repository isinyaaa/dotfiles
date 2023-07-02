HOME = vim.fn.expand("$HOME")

-- Pre-config

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Basic functionality

vim.opt.updatetime = 50
vim.opt.number = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showmode = false
vim.opt.scrolloff = 5

vim.opt.clipboard = "unnamedplus"
vim.opt.mouse:append("a")

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.lazyredraw = true
vim.opt.ttyfast = true

vim.opt.textwidth = 79
vim.opt.colorcolumn = "+1"

vim.opt.spelllang = { "en", "pt_br", "de" }

vim.opt.path:append("**")

-- Run SpellSync automatically when Vim starts
vim.g.spellsync_run_at_startup = 1

-- Enable the Git union merge option
-- Creates a .gitattributes file in the spell directories if one does not exist
vim.g.spellsync_enable_git_union_merge = 1

-- Enable Git ignore for binary spell files
-- Creates a .gitignore file in the spell directories if one does not exist
vim.g.spellsync_enable_git_ignore = 1

vim.cmd.syntax("on")
vim.cmd.filetype("plugin", "indent", "on")
