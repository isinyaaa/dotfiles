return {
    "tpope/vim-apathy",
    "micarmst/vim-spellsync",
    "will133/vim-dirdiff",
    "wakatime/vim-wakatime",
    "blankname/vim-fish",
    "tpope/vim-fugitive",
    "junegunn/goyo.vim",
    {
        "mbbill/undotree",
        config = function()
            vim.keymap.set("n", "<leader>U", ":UndotreeToggle<CR>")
        end,
    },
    {
        "Einenlum/yaml-revealer",
        config = function()
            vim.keymap.set("n", "<leader>ygd", 'T#vt":s;/;>;g<CR>:noh<CR>gvyu:call SearchYamlKey()<CR><C-r>+<CR>')
        end,
    },
}
