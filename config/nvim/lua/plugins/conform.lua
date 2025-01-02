return {
    "stevearc/conform.nvim",
    opts = {
        formatters_by_ft = {
            c = { "clang-format" },
            cpp = { "clang-format" },
            h = { "clang-format" },
            lua = { "lua-format" },
            python = { "ruff_format", "ruff_organize_imports" },
            fish = { "fish_indent" },
            sh = { "shfmt" },
        },
        formatters = {
            ["clang-format"] = {
                command = 'clang-format',
                args = '--style="{ IndentWidth: 4 }"',
            }
        }
    },
}
