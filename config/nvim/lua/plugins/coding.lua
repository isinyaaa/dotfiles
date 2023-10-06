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
        optional = true,
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
    {
        "ThePrimeagen/refactoring.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("refactoring").setup()

            vim.keymap.set("x", "<leader>re", ":Refactor extract ")
            vim.keymap.set("x", "<leader>rf", ":Refactor extract_to_file ")

            vim.keymap.set("x", "<leader>rv", ":Refactor extract_var ")

            vim.keymap.set({ "n", "x" }, "<leader>ri", ":Refactor inline_var")

            vim.keymap.set("n", "<leader>rI", ":Refactor inline_func")

            vim.keymap.set("n", "<leader>rb", ":Refactor extract_block")
            vim.keymap.set("n", "<leader>rbf", ":Refactor extract_block_to_file")
        end,
    },
    -- { import = "lazyvim.plugins.extras.lsp.none-ls" },
    { import = "lazyvim.plugins.extras.lang.clangd" },
    -- { import = "lazyvim.plugins.extras.lang.docker" },
    { import = "lazyvim.plugins.extras.lang.go" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.python" },
    { import = "lazyvim.plugins.extras.lang.rust" },
    { import = "lazyvim.plugins.extras.lang.tailwind" },
    { import = "lazyvim.plugins.extras.lang.tex" },
    { import = "lazyvim.plugins.extras.lang.yaml" },
}
