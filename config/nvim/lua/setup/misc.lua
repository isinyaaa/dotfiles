-- get rid of trailing whitespace
vim.keymap.set("n", "<leader>hw", [[:%s/\s\+$//e<CR>]])

-- fix text formatting on html files
vim.keymap.set("n", "<leader>ml", [[:set nowrapscan<CR>/[\.?!>]$<CR>jV/^\s*[A-Z<]<CR>kgq<Esc>:noh<CR>:set wrapscan<CR>]])

-- substitute emoji codes with actual emoji
vim.keymap.set("n", "<leader>re", [[:%s/:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/g<CR>]])

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
    pattern="*.jjdescription",
    command = "set filetype=gitcommit",
})
