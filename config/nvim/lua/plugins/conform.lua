return {
    "stevearc/conform.nvim",
    opts = {
        formatters_by_ft = {
            lua = { "lua-format" },
            python = { "ruff_format", "ruff_organize_imports" },
            fish = { "fish_indent" },
            sh = { "shfmt" },
        },
    },
}
