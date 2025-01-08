return {
    "tpope/vim-apathy",
    "micarmst/vim-spellsync",
    "will133/vim-dirdiff",
    "wakatime/vim-wakatime",
    "blankname/vim-fish",
    "tpope/vim-fugitive",
    "junegunn/goyo.vim",
    {
        "ojroques/nvim-osc52",
        config = function()
            vim.keymap.set('n', '<leader>c', require('osc52').copy_operator, { expr = true })
            vim.keymap.set('n', '<leader>cc', '<leader>c_', { remap = true })
            vim.keymap.set('v', '<leader>c', require('osc52').copy_visual)
            require('osc52').setup {
                max_length = 0,           -- Maximum length of selection (0 for no limit)
                silent = false,           -- Disable message on successful copy
                trim = false,             -- Trim surrounding whitespaces before copy
                tmux_passthrough = false, -- Use tmux passthrough (requires tmux: set -g allow-passthrough on)
            }
        end,
    },
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
    {
        "zk-org/zk-nvim",
        config = function()
            require("zk").setup({
                picker = "telescope",
            })
        end,
    },
}
