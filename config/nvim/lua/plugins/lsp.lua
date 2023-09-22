require("mason").setup()
local lspconfig = require("lspconfig")
require("mason-lspconfig").setup {
    ensure_installed = {
        "bashls",
        "clangd",
        "ltex",
        "lua_ls",
        "pyright",
        "pylsp",
        "rust_analyzer",
        "texlab",
        "yamlls"
    },
}
require("mason-null-ls").setup({
    automatic_setup = true,
})
require("null-ls").setup({
    on_init = function(new_client, _)
        new_client.offset_encoding = 'utf-16'
    end,
})

lspconfig.bashls.setup {}
lspconfig.clangd.setup {}
lspconfig.ltex.setup {}
lspconfig.lua_ls.setup {
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'},
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}
lspconfig.pylsp.setup {
    settings = {
        pylsp = {
            configurationSources = {"flake8"},
            plugins = {
                flake8 = {
                    enabled = true,
                },
                jedi_completion = { enabled = false },
                pycodestyle = { enabled = false },
                mccabe = { enabled = false },
                pyflakes = { enabled = false },
            },
        },
    },
}
lspconfig.pyright.setup {}

-- See https://rust-analyzer.github.io/manual.html#nvim-lsp
local opts = {
    tools = {
        runnables = {
            use_telescope = true,
        },
        inlay_hints = {
            auto = true,
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    server = {
        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy",
                },
            },
        },
    },
}

require("rust-tools").setup(opts)

lspconfig.texlab.setup {
    settings = {
        latex = {
            build = {
                args = {"-xelatex", "-interaction=nonstopmode", "-synctex=1", "%f"},
            },
        },
    },
}
lspconfig.yamlls.setup {}

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, {silent = true})
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, {silent = true})
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, {silent = true})
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, {silent = true})

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        -- vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', '<leader>jt', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<leader>gt', ':tab split | lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', '<leader>jD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', '<leader>jd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', '<leader>gD', ':tab split | lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', '<leader>gd', ':tab split | lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', '<leader>ji', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<leader>gi', ':tab split | lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', '<leader>jr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>gr', ':tab split | lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', '<leader>K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>k', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<leader>rs', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>f', function()
            vim.lsp.buf.format { async = true }
        end, opts)
    end,
})

require('toggle_lsp_diagnostics').init {
    underline = false,
    -- virtual_text = {
        -- prefix = 'XXX',
        -- spacing = 5
    -- }
}

vim.keymap.set('n', '<leader>dt', '<Plug>(toggle-lsp-diag)<CR>')
