vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "Q", "<Nop>")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Those don't work with neoscroll
-- vim.keymap.set("n", "<C-d>", "<C-d>zz", { silent = true, noremap = false })
-- vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- vim.keymap.set("n", "n", "nzzzv")
-- vim.keymap.set("n", "N", "Nzzzv")
