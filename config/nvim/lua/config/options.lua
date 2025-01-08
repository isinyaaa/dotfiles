-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

HOME = vim.fn.expand("$HOME/")

-- Pre-config

-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

-- Basic functionality

-- vim.opt.updatetime = 50

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.relativenumber = false

-- vim.opt.lazyredraw = true
vim.opt.ttyfast = true

vim.opt.textwidth = 119
vim.opt.colorcolumn = "+1"

vim.opt.spelllang = { "en", "pt_br", "de" }

vim.opt.path:append("**")

local osc52 = require('vim.ui.clipboard.osc52')

vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
        ['+'] = osc52.copy('+'),
        ['*'] = osc52.copy('*'),
    },
    paste = {
        ['+'] = osc52.paste('+'),
        ['*'] = osc52.paste('*'),
    },
}

vim.opt.clipboard:append("unnamedplus")


-- Run SpellSync automatically when Vim starts
-- vim.g.spellsync_run_at_startup = 1

-- Enable the Git union merge option
-- Creates a .gitattributes file in the spell directories if one does not exist
-- vim.g.spellsync_enable_git_union_merge = 1

-- Enable Git ignore for binary spell files
-- Creates a .gitignore file in the spell directories if one does not exist
-- vim.g.spellsync_enable_git_ignore = 1

-- vim.cmd.syntax("on")
-- vim.cmd.filetype("plugin", "indent", "on")
