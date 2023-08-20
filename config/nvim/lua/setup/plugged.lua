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
" Plug 'SirVer/ultisnips'               " snippets engine
" Plug 'honza/vim-snippets'

"""" Useful

Plug 'junegunn/goyo.vim'                " distraction free writing
Plug 'wakatime/vim-wakatime'
Plug 'junegunn/vim-emoji'
Plug 'epwalsh/obsidian.nvim'

"""" Lang support

Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'simrat39/rust-tools.nvim'

Plug 'dpelle/vim-LanguageTool' " TODO: replace with grammarous

Plug 'jose-elias-alvarez/null-ls.nvim'  " LSP linter
Plug 'jay-babu/mason-null-ls.nvim'
" Plug 'mfussenegger/nvim-dap'            " debug adapter protocol
" Plug 'jay-babu/mason-nvim-dap.nvim'

Plug 'github/copilot.vim'

Plug 'lervag/vimtex'

" Plug 'godlygeek/tabular'                " dependency for vim-markdown
" Plug 'plasticboy/vim-markdown'

Plug 'blankname/vim-fish'
Plug 'vivien/vim-linux-coding-style'

"""" Prettify

Plug 'LostNeophyte/neoscroll.nvim', { 'branch': 'fix/eof' }  " smooth scrolling
Plug 'vim-airline/vim-airline'          " status/tabline
Plug 'vim-airline/vim-airline-themes'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'bluz71/vim-nightfly-colors', { 'as': 'nightfly' }

"""" Still not sure

Plug 'preservim/tagbar'                " overview of current file structure
" Plug 'mbledkowski/neuleetcode.vim'
" Plug 'elzr/vim-json'
call plug#end()
]])

