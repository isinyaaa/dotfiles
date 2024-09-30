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
                "ruff_lsp",
                "rust_analyzer",
                "texlab",
                "yamlls",
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
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
            },
        },
    },
}
