return {
    -- {
    --     'smoka7/hop.nvim',
    --     version = "*",
    --     config = function()
    --         local hop = require('hop')
    --         hop.setup({
    --             keys = 'etovxqpdygfblzhckisuran',
    --             hl_mode = 'replace',
    --         })
    --         local directions = require('hop.hint').HintDirection
    --         vim.keymap.set('', 'f', function()
    --             hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
    --         end, { remap = true })
    --         vim.keymap.set('', 'F', function()
    --             hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
    --         end, { remap = true })
    --         vim.keymap.set('', 't', function()
    --             hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
    --         end, { remap = true })
    --         vim.keymap.set('', 'T', function()
    --             hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
    --         end, { remap = true })
    --     end
    -- },
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
    -- {
    --     "lualine.nvim",
    --     opts = function(_, _)
    --         vim.keymap.set("n", "<leader>uS", "", {
    --             callback = function()
    --                 local statusline = vim.o.statusline
    --
    --                 require("lualine").hide({
    --                     place = { "statusline" },
    --                     unhide = statusline == "" or statusline == "%#Normal#",
    --                 })
    --             end,
    --         })
    --     end,
    -- },
    -- {
    --     "kaarmu/typst.vim",
    --     ft = "typst",
    --     lazy = false,
    -- },
}
