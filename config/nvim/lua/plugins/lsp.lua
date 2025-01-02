return {
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
        opts = {
            ensure_installed = {
                "bashls",
                "clangd",
                "ltex",
                "lua_ls",
                "pbls",
                "ruff",
                "rust_analyzer",
                "tinymist",
                "texlab",
                "yamlls",
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        opts = {
            document_highlight = {
                enabled = false,
            },
            servers = {
                bashls = {},
                clangd = {
                    filetypes = { "c", "cpp", "objc", "objcpp", "h", "hpp" },
                },
                mojo = {},
                pbls = {},
                ltex = {
                    settings = {
                        ltex = {
                            checkFrequency = "save",
                            language = "auto",
                        },
                    },
                },
                zls = { mason = false },
                tinymist = {
                    --- todo: these configuration from lspconfig maybe broken
                    single_file_support = true,
                    root_dir = function()
                        return vim.fn.getcwd()
                    end,
                    --- See [Tinymist Server Configuration](https://github.com/Myriad-Dreamin/tinymist/blob/main/Configuration.md) for references.
                    settings = {}
                },
            },
        },
    },
}
