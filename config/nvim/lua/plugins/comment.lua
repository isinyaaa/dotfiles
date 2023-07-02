require('nvim_comment').setup({comment_empty = false})

vim.keymap.set("n", "<leader>cc", ":CommentToggle<CR>")
