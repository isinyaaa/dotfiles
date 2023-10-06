return {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
        opts.ignore_install = { "help" }

        local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
        parser_config.xit = {
            install_info = {
                url = "~/install/tree-sitter-xit",
                files = { "src/parser.c" },
                branch = "main",
                generate_requires_npm = true,
                requires_generate_from_grammar = true,
            },
            filetype = "xit",
        }

        if type(opts.ensure_installed) == "table" then
            vim.list_extend(opts.ensure_installed, {
                "bash",
                "c",
                "cpp",
                "dockerfile",
                "fish",
                "git_config",
                "html",
                -- "javascript",
                "json",
                "lua",
                "make",
                "markdown",
                "markdown_inline",
                "python",
                "query",
                "regex",
                -- "tsx",
                -- "typescript",
                "toml",
                "typst",
                "vim",
                "vimdoc",
                "xit",
                "yaml",
            })
        end
    end,
}
