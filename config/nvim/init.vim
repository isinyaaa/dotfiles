if exists('g:vscode')
    " VSCode extension
else
    call plug#begin('~/.vim/plugged')

        """" Basic functionality

        Plug 'mileszs/ack.vim'                  " enabling ack (better than grep.vim)
        Plug 'tpope/vim-apathy'                 " file searching help
        Plug 'tpope/vim-commentary'             " comment/uncomment stuff
        Plug 'tpope/vim-fugitive'               " git wrapper
        Plug 'junegunn/fzf.vim', { 'do': { -> fzf#install() } } " fzf: more intuitive search than CtrlP
        Plug 'airblade/vim-gitgutter'           " +- and hunk management
        Plug 'scrooloose/nerdtree'              " nerdtree plugin
        Plug 'tpope/vim-unimpaired'             " handy shortcuts
        Plug 'tpope/vim-repeat'                 " enable repeating supported plugins (not just native last command)
        Plug 'tpope/vim-rhubarb'                " vim-fugitive plugin for opening file on Github, using :Gbrowse
        Plug 'tpope/vim-sleuth'                 " auto set tab stops
        Plug 'wakatime/vim-wakatime'
        Plug 'mbledkowski/neuleetcode.vim'      " leetcode
        Plug 'junegunn/vim-emoji'               " Emoji support
        " Plug 'jiangmiao/auto-pairs'           " auto pairs for (), [], {}, '', \"\"
        Plug 'sbdchd/neoformat'                 " auto format code
        Plug 'terryma/vim-multiple-cursors'
        " Plug 'SirVer/ultisnips'               " snippets engine
        " Plug 'honza/vim-snippets'

        """" Lang support

        Plug 'dense-analysis/ale'
        Plug 'dpelle/vim-LanguageTool'
        Plug 'github/copilot.vim'
        Plug 'plasticboy/vim-markdown'

        Plug 'joe-skb7/cscope-maps'             " cscope shortcuts
        Plug 'inkch/vim-fish'
        " Plug 'rust-lang/rust.vim'               " rust development plugin

        Plug 'vivien/vim-linux-coding-style'

        """" Prettify

        Plug 'karb94/neoscroll.nvim'            " smooth scrolling
        Plug 'vim-airline/vim-airline'          " status/tabline
        Plug 'vim-airline/vim-airline-themes'
        Plug 'liuchengxu/space-vim-theme'
        " Plug 'rakr/vim-one'
        " Plug 'liuchengxu/space-vim-dark'
        " Plug 'drewtempelmeyer/palenight.vim'
        " Plug 'jpo/vim-railscasts-theme'       " railscasts-theme

        """" Still not sure

        Plug 'majutsushi/tagbar'                " overview of current file structure
        " Plug 'tpope/vim-surround'               " manage surroundings (parenthesis, brackets, quotes, XML tags, etc.)
        " Plug 'elzr/vim-json'                    " json filetype plugin
        " Plug 'godlygeek/tabular'                " dependency for vim-markdown
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

    set colorcolumn=81

    set spelllang+=pt_br

    " Whitespace management
    set hlsearch
    highlight ExtraWhitespace ctermbg=red guibg=red
    autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
    autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    autocmd InsertLeave * match ExtraWhitespace /\s\+$/
    autocmd BufWinLeave * call clearmatches()

    nmap ghw :%s/\s\+$//e<CR>
    "BufWritePre *

    set path+=**

    let NERDTreeShowHidden=1
    nmap <C-n> :NERDTreeToggle<CR>

    " CTags Settings
    " Refer: http://ctags.sourceforge.net/ or `man ctags`
    " enabling CTags
    set tags=tags;                               " tags file within project directory
    map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>

    " ack.vim Settings
    cnoreabbrev Ack Ack!
    let g:ackhighlight = 1                              " highlight matches
    let g:ackprg = 'ag --nogroup --nocolor --column'    " Ag support

    nmap ghp <Plug>(GitGutterPreviewHunk)
    nmap ghs <Plug>(GitGutterStageHunk)
    nmap ghu <Plug>(GitGutterUndoHunk)
    nmap [h <Plug>(GitGutterPrevHunk)
    nmap ]h <Plug>(GitGutterNextHunk)

    let g:leetcode_browser = 'firefox'
    let g:leetcode_solution_filetype = 'c'
    let g:leetcode_hide_paid_only = 1

    nnoremap gll :LeetCodeList<cr>
    nnoremap glt :LeetCodeTest<cr>
    nnoremap gls :LeetCodeSubmit<cr>
    nnoremap gli :LeetCodeSignIn<cr>

    " set completefunc=emoji#complete

    fun! <SID>Sub_movend(lineno)
            if (match(getline(a:lineno), ':\([^:]\+\):') != -1) " There is a match
                    exe a:lineno . 'su /:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/g'
                    star!
            endif
    endfun

    " let g:UltiSnipsExpandTrigger="<CR>"
    " let g:UltiSnipsJumpForwardTrigger="<c-b>"
    " let g:UltiSnipsJumpBackwardTrigger="<c-z>"

    nmap get <ESC>:call <SID>Sub_movend(line('.'))<cr>

    filetype plugin indent on
    syntax on

    if $IS_MAC == "true"
        let g:rust_clip_command = 'pbcopy'
    else
        let g:rust_clip_command = 'xclip -selection clipboard'
    endif

    "python with virtualenv support
    let python_highlight_all=1

    let g:airline#extensions#ale#enabled = 1

    let g:ale_lint_on_text_changed = 'never'
    let g:ale_lint_on_insert_leave = 0
    " You can disable this option too
    " if you don't want linters to run on opening a file
    " let g:ale_lint_on_enter = 0

    " autocmd BufNewFile,BufRead ~/shared/kworkflow/* let syntastic_sh_shellcheck_args="--external-sources --shell=bash --exclude=SC2016,SC2181,SC2034,SC2154,SC2001,SC1090,SC1091,SC2120"

    nmap gjt :ALEGoToDefinition -tab<cr>
    nmap gjd :ALEGoToDefinition<cr>
    nmap gtt :ALEGoToTypeDefinition -tab<cr>
    nmap gtd :ALEGoToTypeDefinition<cr>
    nmap gmd :ALEDetail<cr>
    nmap gfr :ALEFindReferences<cr>
    nmap grs :ALERename<cr>
    nmap gca :ALECodeAction<cr>

    nmap gst :ALEToggle<cr>
    nmap gsd :let g:ale_disable_lsp=1<cr>:ALELint<cr>
    nmap gse :let g:ale_disable_lsp=0<cr>gstgst

    nmap [a :ALEPreviousWrap<cr>
    nmap ]a :ALENextWrap<cr>

    let g:ale_linters = {
    \   'bash': ['shellcheck'],
    \   'fish': ['fish'],
    \   'c': ['clangtidy', 'cppcheck', 'clangd'],
    \   'cpp': ['clangtidy', 'cppcheck', 'clangd'],
    \   'python': ['flake8', 'pylsp'],
    \}
    let g:ale_linters_explicit = 1

    let g:languagetool_jar='$HOME/LanguageTool-5.7-stable/languagetool-commandline.jar'
    let g:languagetool_enable_rules='PASSIVE_VOICE'

    nmap glc :LanguageToolCheck<cr>
    nmap gle :LanguageToolClear<cr>
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
