HOME = vim.fn.expand("$HOME")

-- Pre-config

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.cmd([[
call plug#begin('~/.vim/plugged')

"""" Basic functionality

Plug 'nvim-lua/plenary.nvim'            " basic lua functions
Plug 'tpope/vim-repeat'                 " enable repeating supported plugins (not just native last command)
Plug 'terrortylor/nvim-comment'         " comment/uncomment stuff
Plug 'tpope/vim-apathy'                 " appends to path
Plug 'tpope/vim-fugitive'               " git wrapper
Plug 'airblade/vim-gitgutter'           " +- and hunk management
Plug 'nvim-tree/nvim-tree.lua'          " file explorer
Plug 'tpope/vim-surround'               " manage surroundings (parenthesis, brackets, quotes, XML tags, etc.)
Plug 'tpope/vim-sleuth'                 " auto set tab stops
Plug 'sbdchd/neoformat'                 " auto format code
Plug 'micarmst/vim-spellsync'
Plug 'will133/vim-dirdiff'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }   " improve telescope performance
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.1' }
" Plug 'terryma/vim-multiple-cursors'
" Plug 'SirVer/ultisnips'               " snippets engine
" Plug 'honza/vim-snippets'

"""" Useful

Plug 'junegunn/goyo.vim'                " distraction free writing
Plug 'wakatime/vim-wakatime'
Plug 'junegunn/vim-emoji'               " Emoji support
" Plug 'tpope/vim-rhubarb'                " vim-fugitive plugin for opening file on Github, using :Gbrowse

"""" Lang support

Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'

" Plug 'dense-analysis/ale'
Plug 'dpelle/vim-LanguageTool' " TODO: replace with grammarous

Plug 'jose-elias-alvarez/null-ls.nvim'  " LSP linter
Plug 'jay-babu/mason-null-ls.nvim'
" Plug 'mfussenegger/nvim-dap'            " debug adapter protocol
" Plug 'jay-babu/mason-nvim-dap.nvim'

Plug 'github/copilot.vim'

" Plug 'godlygeek/tabular'                " dependency for vim-markdown
" Plug 'plasticboy/vim-markdown'

Plug 'blankname/vim-fish'
Plug 'vivien/vim-linux-coding-style'

"""" Prettify

Plug 'karb94/neoscroll.nvim'            " smooth scrolling
Plug 'vim-airline/vim-airline'          " status/tabline
Plug 'vim-airline/vim-airline-themes'
Plug 'bluz71/vim-nightfly-colors', { 'as': 'nightfly' }

"""" Still not sure

Plug 'preservim/tagbar'                " overview of current file structure
" Plug 'mbledkowski/neuleetcode.vim'
" Plug 'elzr/vim-json'
call plug#end()
]])

-- Theme stuff

vim.opt.termguicolors = true
vim.cmd.colorscheme("nightfly")

-- Basic functionality

vim.opt.updatetime = 50
vim.opt.number = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showmode = false
vim.opt.scrolloff = 5

vim.keymap.set("n", "Q", "<Nop>")

vim.opt.clipboard = "unnamedplus"
vim.opt.mouse:append("a")

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.lazyredraw = true
vim.opt.ttyfast = true

vim.opt.textwidth = 79
vim.opt.colorcolumn = "+1"

vim.opt.spelllang = { "en", "pt_br", "de" }

vim.opt.path:append("**")

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Run SpellSync automatically when Vim starts
vim.g.spellsync_run_at_startup = 1

-- Enable the Git union merge option
-- Creates a .gitattributes file in the spell directories if one does not exist
vim.g.spellsync_enable_git_union_merge = 1

-- Enable Git ignore for binary spell files
-- Creates a .gitignore file in the spell directories if one does not exist
vim.g.spellsync_enable_git_ignore = 1

vim.cmd.syntax("on")
vim.cmd.filetype("plugin", "indent", "on")

vim.g.mapleader = " "

-- reload vimrc
vim.keymap.set("n", "<leader><leader>", ":so<CR>", { silent = true })

vim.opt.hlsearch = true

-- Whitespace management
vim.cmd.highlight({ "ExtraWhitespace", "ctermbg=red", "guibg=red" })
vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = "*",
    callback = function()
        vim.cmd([[match ExtraWhitespace /\s\+$/]])
    end
}
)
vim.api.nvim_create_autocmd("InsertEnter ", {
    pattern = "*",
    callback = function()
        vim.cmd([[match ExtraWhitespace /\s\+\%#\@<!$/]])
    end
}
)
vim.api.nvim_create_autocmd("InsertLeave ", {
    pattern = "*",
    callback = function()
        vim.cmd([[match ExtraWhitespace /\s\+$/]])
    end
}
)
vim.api.nvim_create_autocmd("BufWinLeave ", {
    pattern = "*",
    callback = function()
        vim.fn.clearmatches()
    end
}
)

vim.keymap.set("n", "<leader>hw", [[:%s/\s\+$//e<CR>]])
vim.keymap.set("n", "<leader>ml", [[:set nowrapscan<CR>/[\.?!>]$<CR>jV/^\s*[A-Z<]<CR>kgq<Esc>:noh<CR>:set wrapscan<CR>]])
vim.keymap.set("n", "<leader>gm", ":Goyo<CR>")

require('nvim_comment').setup({comment_empty = false})

vim.keymap.set("n", "<leader>cc", ":CommentToggle<CR>")

require("nvim-tree").setup()

local git_top = io.popen("git -C " .. vim.fn.expand("%:p:h") .. " top"):read()

if git_top == nil or git_top == "" then
    vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")
else
    vim.keymap.set("n", "<C-n>", ":NvimTreeToggle " .. git_top .. "<CR>")
end

vim.keymap.set("n", "<C-m>", ":TagbarToggle<CR>")

vim.keymap.set("n", "]h", "<Plug>(GitGutterNextHunk)")
vim.keymap.set("n", "[h", "<Plug>(GitGutterPrevHunk)")

-- vim.g.leetcode_browser = 'brave'
-- vim.g.leetcode_solution_filetype = 'c'
-- vim.g.leetcode_hide_paid_only = 1

-- vim.keymap.set("n", "<leader>ll", ":LeetCodeList<CR>")
-- vim.keymap.set("n", "<leader>lt", ":LeetCodeTest<CR>")
-- vim.keymap.set("n", "<leader>ls", ":LeetCodeSubmit<CR>")

-- create a map to run %s/:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/g
vim.keymap.set("n", "<leader>re", [[:%s/:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/g<CR>]])

require('telescope').load_extension('fzf')

vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { silent = true })
vim.keymap.set("n", "<leader>lg", ":Telescope live_grep<CR>", { silent = true })
vim.keymap.set("n", "<leader>tb", ":Telescope buffers<CR>", { silent = true })
vim.keymap.set("n", "<leader>ht", ":Telescope help_tags<CR>", { silent = true })

------ Tree sitter ------

require'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the four listed parsers should always be installed)
    ensure_installed = { "bash", "c", "cpp", "fish", "markdown", "python", "lua", "vim" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    -- List of parsers to ignore installing (for "all")
    ignore_install = { "javascript" },

    ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
    -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

    highlight = {
        -- `false` will disable the whole extension
        enable = true,
        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- list of language that will be disabled
        -- disable = { "diff" },
        -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
        disable = function(lang, buf)
            -- if the buffer name ends in diff
            -- if vim.api.nvim_buf_get_name(buf):match('diff$') then
            --     return true
            -- end

            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))

            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,

        -- disable = { "html" },
    },
}

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = vim.fn['nvim_treesitter#foldexpr']()
vim.opt.foldenable = false  -- Disable folding at startup

------ LSP config ------

require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = {
        "bashls",
        "clangd",
        "lua_ls",
        "pylyzer",
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
        new_client.offset_encoding = 'utf-32'
    end,
})

local lspconfig = require("lspconfig")
lspconfig.bashls.setup {}
lspconfig.clangd.setup {}
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
lspconfig.pylyzer.setup {}
lspconfig.rust_analyzer.setup {}
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
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
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

------ Prettify ------

require('neoscroll').setup()

-- Neoformat
-- Enable alignment
vim.g.neoformat_basic_format_align = 1

-- Enable tab to space conversion
vim.g.neoformat_basic_format_retab = 1

-- Enable trimmming of trailing whitespace
vim.g.neoformat_basic_format_trim = 1
