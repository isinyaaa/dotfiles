return {
    { "nvim-telescope/telescope-live-grep-args.nvim" },
    { "nvim-telescope/telescope-media-files.nvim" },
    { "nvim-telescope/telescope-file-browser.nvim" },

    {
        "telescope.nvim",
        dependencies = {
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                config = function()
                    require("telescope").load_extension("fzf")
                end,
            },
            {
                "nvim-telescope/telescope-live-grep-args.nvim",
                config = function()
                    require("telescope").load_extension("live_grep_args")
                end,
            },
            {
                "nvim-telescope/telescope-media-files.nvim",
                config = function()
                    require("telescope").load_extension("media_files")
                end,
            },
            {
                "nvim-telescope/telescope-file-browser.nvim",
                config = function()
                    local telescope = require("telescope")
                    telescope.load_extension("file_browser")
                end,
            },
        },
        opts = function(_, opts)
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

            opts.pickers = {
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
            }
        end,
    },
}
