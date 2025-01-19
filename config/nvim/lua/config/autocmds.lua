vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.jjdescription",
    command = "set filetype=gitcommit",
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.xit",
    command = "set filetype=xit",
})
