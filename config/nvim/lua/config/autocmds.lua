-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.jjdescription",
    command = "set filetype=gitcommit",
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.xit",
    command = "set filetype=xit",
})

-- vim.cmd.highlight({ "ExtraWhitespace", "ctermbg=red", "guibg=red" })
-- vim.api.nvim_create_autocmd("BufWinEnter", {
--   pattern = "*",
--   callback = function()
--     vim.cmd([[match ExtraWhitespace /\s\+$/]])
--   end,
-- })
-- vim.api.nvim_create_autocmd("InsertEnter ", {
--   pattern = "*",
--   callback = function()
--     vim.cmd([[match ExtraWhitespace /\s\+\%#\@<!$/]])
--   end,
-- })
-- vim.api.nvim_create_autocmd("InsertLeave ", {
--   pattern = "*",
--   callback = function()
--     vim.cmd([[match ExtraWhitespace /\s\+$/]])
--   end,
-- })
-- vim.api.nvim_create_autocmd("BufWinLeave ", {
--   pattern = "*",
--   callback = function()
--     vim.fn.clearmatches()
--   end,
-- })
