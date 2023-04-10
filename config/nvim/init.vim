if exists('g:vscode')
    " VSCode extension
else
    call plug#begin('~/.vim/plugged')

        """" Basic functionality

        Plug 'mileszs/ack.vim'                  " enabling ack (better than grep.vim)
        Plug 'tpope/vim-apathy'                 " file searching help
        Plug 'terrortylor/nvim-comment'         " comment/uncomment stuff
        Plug 'tpope/vim-fugitive'               " git wrapper
        Plug 'junegunn/fzf.vim', { 'do': { -> fzf#install() } } " fzf: more intuitive search than CtrlP
        Plug 'airblade/vim-gitgutter'           " +- and hunk management
        Plug 'preservim/nerdtree'               " nerdtree plugin
        Plug 'tpope/vim-unimpaired'             " handy shortcuts
        Plug 'tpope/vim-repeat'                 " enable repeating supported plugins (not just native last command)
        Plug 'tpope/vim-rhubarb'                " vim-fugitive plugin for opening file on Github, using :Gbrowse
        Plug 'tpope/vim-sleuth'                 " auto set tab stops
        Plug 'wakatime/vim-wakatime'
        Plug 'mbledkowski/neuleetcode.vim'      " leetcode
        Plug 'junegunn/vim-emoji'               " Emoji support
        " Plug 'jiangmiao/auto-pairs'           " auto pairs for (), [], {}, '', \"\"
        Plug 'sbdchd/neoformat'                 " auto format code
        " Plug 'terryma/vim-multiple-cursors'
        " Plug 'SirVer/ultisnips'               " snippets engine
        " Plug 'honza/vim-snippets'
        Plug 'nvim-lua/plenary.nvim'            " dependency for telescope
        Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.1' }
        Plug 'will133/vim-dirdiff'
        Plug 'junegunn/goyo.vim'                " distraction free writing
        Plug 'micarmst/vim-spellsync'

        """" Lang support

        Plug 'dense-analysis/ale'
        Plug 'dpelle/vim-LanguageTool'
        Plug 'github/copilot.vim'
        " Plug 'plasticboy/vim-markdown'

        Plug 'isinyaaa/cscope-maps'
        Plug 'inkch/vim-fish'
        Plug 'rust-lang/rust.vim'

        Plug 'vivien/vim-linux-coding-style'

        """" Prettify

        Plug 'karb94/neoscroll.nvim'            " smooth scrolling
        Plug 'vim-airline/vim-airline'          " status/tabline
        Plug 'vim-airline/vim-airline-themes'
        Plug 'liuchengxu/space-vim-theme'

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

    " Run SpellSync automatically when Vim starts
    let g:spellsync_run_at_startup = 1

    " Enable the Git union merge option
    " Creates a .gitattributes file in the spell directories if one does not exist
    let g:spellsync_enable_git_union_merge = 1

    " Enable Git ignore for binary spell files
    " Creates a .gitignore file in the spell directories if one does not exist
    let g:spellsync_enable_git_ignore = 1

    set foldmethod=expr
    set foldexpr=nvim_treesitter#foldexpr()
    set nofoldenable                     " Disable folding at startup.

    filetype indent off
    " syntax on

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

    "function! FormatNoWrap()
    "    set nowrapscan
    "    try
    "        exe "normal" "/[\.?!>]$<CR>jV/^\s*[A-Z<]<CR>kgq"
    "    catch /^Vim\%((\a\+)\)\=:E385/
    "        " search hit BOTTOM without match
    "        " ought to print an error message here
    "    endtry
    "    exe "normal" ":noh<CR>"
    "    set wrapscan
    "endfunction

    "" auto format text
    "nmap <leader>ml :call FormatNoWrap()<CR>

    "function FindNextSentence()
    "    set nowrapscan
    "    /[\.\?!>]$
    "    j
    "    V
    "    /^\s*[A-Z<]
    "    k
    "    gq
    "    normal! ggVG
    "    :noh
    "    set wrapscan
    "endfunction

    "nnoremap <leader>ml :call FindNextSentence()<CR>

    nmap <leader>ml :set nowrapscan<CR>/[\.?!>]$<CR>jV/^\s*[A-Z<]<CR>kgq<Esc>:noh<CR>:set wrapscan<CR>

    nmap <leader>gm :Goyo<CR>

    set path+=**

    lua require('nvim_comment').setup({comment_empty = false})

    let NERDTreeShowHidden=1
    nmap <C-n> :NERDTreeToggle<CR>

    " CTags Settings
    " Refer: http://ctags.sourceforge.net/ or `man ctags`
    " enabling CTags
    " set tags=tags;                               " tags file within project directory
    " map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>

    " ack.vim Settings
    cnoreabbrev Ack Ack!
    let g:ackhighlight = 1                              " highlight matches
    let g:ackprg = 'ag --nogroup --nocolor --column'    " Ag support

    nmap <leader>hp <Plug>(GitGutterPreviewHunk)
    nmap <leader>hs <Plug>(GitGutterStageHunk)
    nmap <leader>hu <Plug>(GitGutterUndoHunk)
    nmap [h <Plug>(GitGutterPrevHunk)
    nmap ]h <Plug>(GitGutterNextHunk)

    let g:leetcode_browser = 'firefox'
    let g:leetcode_solution_filetype = 'c'
    let g:leetcode_hide_paid_only = 1

    nnoremap <leader>ll :LeetCodeList<cr>
    nnoremap <leader>lt :LeetCodeTest<cr>
    nnoremap <leader>ls :LeetCodeSubmit<cr>

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

    nmap <leader>me <ESC>:call <SID>Sub_movend(line('.'))<cr>

    if $IS_MAC == "true"
        let g:rust_clip_command = 'pbcopy'
    else
        let g:rust_clip_command = 'xclip -selection clipboard'
    endif

    "python with virtualenv support
    " let python_highlight_all=1

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
    \   'bash': ['shellcheck'],
    \   'fish': ['fish'],
    \   'c': ['clangd', 'cppcheck'],
    \   'cpp': ['clangtidy', 'cppcheck', 'clangd'],
    \   'python': ['flake8', 'pylsp'],
    \   'rust': ['analyzer'],
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

    " Find files using Telescope command-line sugar.
    nnoremap <leader>ff <cmd>Telescope find_files<cr>
    nnoremap <leader>lg <cmd>Telescope live_grep<cr>
    nnoremap <leader>tb <cmd>Telescope buffers<cr>
    nnoremap <leader>ht <cmd>Telescope help_tags<cr>
endif

set clipboard=unnamedplus
