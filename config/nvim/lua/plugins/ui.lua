return {
    {
        "LostNeophyte/neoscroll.nvim",
        branch = "fix/eof",
        config = function()
            require("neoscroll").setup()

            local t = {
                ["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "350" } },
                ["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "350" } },
                ["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "500" } },
                ["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "500" } },
                ["<C-y>"] = { "scroll", { "-0.10", "false", "100" } },
                ["<C-e>"] = { "scroll", { "0.10", "false", "100" } },
                ["zt"] = { "zt", { "300" } },
                ["zz"] = { "zz", { "300" } },
                ["zb"] = { "zb", { "300" } },
            }

            require("neoscroll.config").set_mappings(t)
        end,
    },
}
