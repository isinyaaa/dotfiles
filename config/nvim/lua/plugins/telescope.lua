require('telescope').load_extension('fzf')

vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { silent = true })
vim.keymap.set("n", "<leader>lg", ":Telescope live_grep<CR>", { silent = true })
vim.keymap.set("n", "<leader>tb", ":Telescope buffers<CR>", { silent = true })
vim.keymap.set("n", "<leader>ht", ":Telescope help_tags<CR>", { silent = true })
