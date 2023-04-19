if exists('g:vscode')
    " VSCode extension
else
    call plug#begin('~/.vim/plugged')

        """" Basic functionality

        Plug 'nvim-lua/plenary.nvim'            " basic lua functions
        Plug 'tpope/vim-repeat'                 " enable repeating supported plugins (not just native last command)
        Plug 'terrortylor/nvim-comment'         " comment/uncomment stuff
        Plug 'tpope/vim-apathy'                 " appends to path
        Plug 'tpope/vim-fugitive'               " git wrapper
        Plug 'airblade/vim-gitgutter'           " +- and hunk management
        Plug 'preservim/nerdtree'
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

        Plug 'dense-analysis/ale'
        Plug 'dpelle/vim-LanguageTool'
        Plug 'github/copilot.vim'

        " Plug 'godlygeek/tabular'                " dependency for vim-markdown
        " Plug 'plasticboy/vim-markdown'

        Plug 'blankname/vim-fish'
        Plug 'vivien/vim-linux-coding-style'

        """" Prettify

        Plug 'karb94/neoscroll.nvim'            " smooth scrolling
        Plug 'vim-airline/vim-airline'          " status/tabline
        Plug 'vim-airline/vim-airline-themes'
        Plug 'liuchengxu/space-vim-theme'

        """" Still not sure

        Plug 'preservim/tagbar'                " overview of current file structure
        " Plug 'mbledkowski/neuleetcode.vim'
        " Plug 'elzr/vim-json'
    call plug#end()

    """" Theme stuff

    if has('termguicolors')
        set termguicolors
    endif
    colorscheme space_vim_theme
    hi Comment cterm=italic

    """" Basic functionality

    set number

    set ignorecase
    set smartcase

    nmap Q <Nop>

    set mouse+=a
    set expandtab
    set shiftwidth=4
    set softtabstop=4
    set lazyredraw
    set ttyfast
    set noshowmode

    set textwidth=79
    set colorcolumn=+1

    set spelllang=en,pt_br,de

    set path+=**

    nnoremap <C-h> <C-w>h
    nnoremap <C-j> <C-w>j
    nnoremap <C-k> <C-w>k
    nnoremap <C-l> <C-w>l

    " Run SpellSync automatically when Vim starts
    let g:spellsync_run_at_startup = 1

    " Enable the Git union merge option
    " Creates a .gitattributes file in the spell directories if one does not exist
    let g:spellsync_enable_git_union_merge = 1

    " Enable Git ignore for binary spell files
    " Creates a .gitignore file in the spell directories if one does not exist
    let g:spellsync_enable_git_ignore = 1


    syntax on
    filetype plugin indent on

    let mapleader = " "

    " reload vimrc
    nnoremap <silent> <Leader><Leader> :source $MYVIMRC<CR>:noh<CR>

    set hlsearch

    " Whitespace management
    highlight ExtraWhitespace ctermbg=red guibg=red
    autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
    autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    autocmd InsertLeave * match ExtraWhitespace /\s\+$/
    autocmd BufWinLeave * call clearmatches()

    nmap <leader>hw :%s/\s\+$//e<CR>
    "BufWritePre *

    nmap <leader>ml :set nowrapscan<CR>/[\.?!>]$<CR>jV/^\s*[A-Z<]<CR>kgq<Esc>:noh<CR>:set wrapscan<CR>

    nmap <leader>gm :Goyo<CR>

    lua require('nvim_comment').setup({comment_empty = false})

    let NERDTreeShowHidden=1
    nmap <C-n> :NERDTreeToggle<CR>

    nmap [h <Plug>(GitGutterPrevHunk)
    nmap ]h <Plug>(GitGutterNextHunk)

    " let g:leetcode_browser = 'firefox'
    " let g:leetcode_solution_filetype = 'c'
    " let g:leetcode_hide_paid_only = 1

    " nnoremap <leader>ll :LeetCodeList<cr>
    " nnoremap <leader>lt :LeetCodeTest<cr>
    " nnoremap <leader>ls :LeetCodeSubmit<cr>

    " set completefunc=emoji#complete

    fun! <SID>Sub_movend(lineno)
            if (match(getline(a:lineno), ':\([^:]\+\):') != -1) " There is a match
                    exe a:lineno . 'su /:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/g'
                    star!
            endif
    endfun

    nmap <leader>me <ESC>:call <SID>Sub_movend(line('.'))<cr>

    lua require('telescope').load_extension('fzf')

    " Find files using Telescope command-line sugar.
    nnoremap <leader>ff <cmd>Telescope find_files<cr>
    nnoremap <leader>lg <cmd>Telescope live_grep<cr>
    nnoremap <leader>tb <cmd>Telescope buffers<cr>
    nnoremap <leader>ht <cmd>Telescope help_tags<cr>

    """" LSP config

    let g:airline#extensions#ale#enabled = 1

    let g:ale_lint_on_text_changed = 'never'
    let g:ale_lint_on_insert_leave = 0
    " You can disable this option too
    " if you don't want linters to run on opening a file
    " let g:ale_lint_on_enter = 0

    " autocmd BufNewFile,BufRead ~/shared/kworkflow/* let syntastic_sh_shellcheck_args="--external-sources --shell=bash --exclude=SC2016,SC2181,SC2034,SC2154,SC2001,SC1090,SC1091,SC2120"

    nmap <leader>jt :ALEGoToDefinition -tab<cr>
    nmap <leader>jd :ALEGoToDefinition<cr>
    nmap <leader>tt :ALEGoToTypeDefinition -tab<cr>
    nmap <leader>td :ALEGoToTypeDefinition<cr>
    nmap <leader>ft :ALEFindReferences -tab<cr>
    nmap <leader>fr :ALEFindReferences<cr>
    nmap <leader>md :ALEDetail<cr>
    nmap <leader>rs :ALERename<cr>
    nmap <leader>ca :ALECodeAction<cr>

    nmap <leader>st :ALEToggle<cr>
    nmap <leader>sd :let g:ale_disable_lsp=1<cr>:ALELint<cr>
    nmap <leader>se :let g:ale_disable_lsp=0<cr>gstgst

    nmap [a :ALEPreviousWrap<cr>
    nmap ]a :ALENextWrap<cr>

    let g:ale_linters = {
    \   'fish': ['fish'],
    \   'c': ['clangd', 'cppcheck'],
    \   'cpp': ['clangtidy', 'cppcheck', 'clangd'],
    \   'python': ['flake8', 'pylsp'],
    \   'rust': ['analyzer'],
    \   'sh': ['shellcheck'],
    \}

    let g:ale_fixers = {
    \   'c': ['clangtidy', 'clangd'],
    \   'cpp': ['clangtidy', 'clangd'],
    \   'python': ['black', 'isort'],
    \   'rust': ['rustfmt']
    \}
    let g:ale_linters_explicit = 1

    let g:languagetool_jar='$HOME/LanguageTool-5.7-stable/languagetool-commandline.jar'
    let g:languagetool_enable_rules='PASSIVE_VOICE'

    nmap <leader>lc :LanguageToolCheck<cr>
    nmap <leader>le :LanguageToolClear<cr>
    nmap [l :lpr<cr>
    nmap ]l :lne<cr>

    """" Prettify

    lua require('neoscroll').setup()

    """ Neoformat
    " Enable alignment
    let g:neoformat_basic_format_align = 1

    " Enable tab to space conversion
    let g:neoformat_basic_format_retab = 1

    " Enable trimmming of trailing whitespace
    let g:neoformat_basic_format_trim = 1
endif

set clipboard=unnamedplus
