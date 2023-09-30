-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- get rid of trailing whitespace
vim.keymap.set("n", "<leader>hw", [[:%s/\s\+$//e<CR>]])

-- fix text formatting on html files
-- vim.keymap.set(
--     "n",
--     "<leader>ml",
--     [[:set nowrapscan<CR>/[\.?!>]$<CR>jV/^\s*[A-Z<]<CR>kgq<Esc>:noh<CR>:set wrapscan<CR>]]
-- )
