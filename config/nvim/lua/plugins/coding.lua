return {
    {
        "simrat39/symbols-outline.nvim",
        cmd = "SymbolsOutline",
        keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
        config = true,
    },
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        build = ":Copilot auth<cr>:Copilot enable<cr>",
        event = "InsertEnter",
        opts = {
            suggestion = {
                enabled = false,
                -- auto_trigger = true,
                -- keymap = {
                --     accept = "<tab>",
                -- },
            },
            panel = { enabled = false },
            -- ft_disable = { "markdown", "terraform", "cpp" },
        },
    },
    {
        "zbirenbaum/copilot-cmp",
        dependencies = {
            "zbirenbaum/copilot.lua",
        },
        config = function()
            require("copilot_cmp").setup()
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "zbirenbaum/copilot-cmp",
            "hrsh7th/cmp-emoji",
        },
        ---@param opts cmp.ConfigSchema
        opts = function(_, opts)
            local cmp = require("cmp")
            opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
                { name = "copilot" },
                { name = "emoji" },
            }))
        end,
    },
    { import = "lazyvim.plugins.extras.lang.clangd" },
    { import = "lazyvim.plugins.extras.lang.docker" },
    { import = "lazyvim.plugins.extras.lang.go" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.python" },
    { import = "lazyvim.plugins.extras.lang.rust" },
    { import = "lazyvim.plugins.extras.lang.tailwind" },
    { import = "lazyvim.plugins.extras.lang.tex" },
    { import = "lazyvim.plugins.extras.lang.yaml" },
}
