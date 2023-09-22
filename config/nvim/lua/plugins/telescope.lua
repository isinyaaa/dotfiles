local telescope = require('telescope')
telescope.load_extension('fzf')
telescope.load_extension('media_files')
telescope.load_extension('live_grep_args')

local select_dir_for_grep = function(prompt_bufnr)
    local action_state = require("telescope.actions.state")
    local fb = require("telescope").extensions.file_browser
    local lga = require("telescope").extensions.live_grep_args
    local current_line = action_state.get_current_line()

    fb.file_browser({
        files = false,
        depth = false,
        attach_mappings = function(prompt_bufnr)
            require("telescope.actions").select_default:replace(function()
                local entry_path = action_state.get_selected_entry().Path
                local dir = entry_path:is_dir() and entry_path or entry_path:parent()
                local relative = dir:make_relative(vim.fn.getcwd())
                local absolute = dir:absolute()

                lga.live_grep_args({
                    results_title = relative .. "/",
                    cwd = absolute,
                    default_text = current_line,
                })
            end)

            return true
        end,
    })
end

telescope.setup({
    extensions = {
        file_browser = {
            -- hidden = true,
            hijack_netrw = true,
            -- disable_devicons = false,
        },
        media_files = {
            -- filetypes = { "png", "webp", "jpg", "jpeg" },
            -- find_cmd = "rg",
        },
    },
    pickers = {
        live_grep = {
            mappings = {
                i = {
                    ["<C-f>"] = select_dir_for_grep,
                },
                n = {
                    ["<C-f>"] = select_dir_for_grep,
                },
            },
        },
    },
})

vim.keymap.set("n", "<leader>ga", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", { silent = true })
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { silent = true })
vim.keymap.set("n", "<leader>lg", ":Telescope live_grep<CR>", { silent = true })
vim.keymap.set("n", "<leader>tb", ":Telescope buffers<CR>", { silent = true })
vim.keymap.set("n", "<leader>ht", ":Telescope help_tags<CR>", { silent = true })
