vim.g.vimtex_quickfix_mode = 0
vim.g.vimtex_syntax_enabled = 0
vim.g.vimtex_compiler_latexmk_engines = {
    _ = '-xelatex',
}
if vim.fn.has('mac') == 1 then
    vim.g.vimtex_view_general_viewer = 'open'
end
