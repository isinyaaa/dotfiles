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
                ltex = {
                    settings = {
                        ltex = {
                            language = "auto",
                        },
                    },
                },
                zls = { mason = false },
            },
        },
    },
}
