vim.keymap.set("n", "<leader>hw", [[:%s/\s\+$//e<CR>]])
vim.keymap.set("n", "<leader>ml", [[:set nowrapscan<CR>/[\.?!>]$<CR>jV/^\s*[A-Z<]<CR>kgq<Esc>:noh<CR>:set wrapscan<CR>]])

-- create a map to run %s/:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/g
vim.keymap.set("n", "<leader>re", [[:%s/:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/g<CR>]])
