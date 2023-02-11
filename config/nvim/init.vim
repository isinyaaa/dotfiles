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
        Plug 'nvim-lua/plenary.nvim'            " dependency for telescope
        " Plug 'TimUntersberger/neogit'
        Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.1' }

        """" Lang support

        Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
        Plug 'dense-analysis/ale'
        Plug 'dpelle/vim-LanguageTool'
        Plug 'github/copilot.vim'
        " Plug 'plasticboy/vim-markdown'

        Plug 'joe-skb7/cscope-maps'             " cscope shortcuts
        " Plug 'inkch/vim-fish'
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

    set foldmethod=expr
    set foldexpr=nvim_treesitter#foldexpr()
    set nofoldenable                     " Disable folding at startup.

    let mapleader = " "

    set hlsearch
    nmap <leader>h :noh<CR>

    " Whitespace management
    highlight ExtraWhitespace ctermbg=red guibg=red
    autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
    autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    autocmd InsertLeave * match ExtraWhitespace /\s\+$/
    autocmd BufWinLeave * call clearmatches()

    nmap <leader>hw :%s/\s\+$//e<CR>
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

    " filetype plugin indent on
    " syntax on

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
    nmap <leader>md :ALEDetail<cr>
    nmap <leader>fr :ALEFindReferences<cr>
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
    \   'c': ['clangtidy', 'cppcheck', 'clangd'],
    \   'cpp': ['clangtidy', 'cppcheck', 'clangd'],
    \   'python': ['flake8', 'pylsp'],
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
    nnoremap <leader>fg <cmd>Telescope live_grep<cr>
    nnoremap <leader>fb <cmd>Telescope buffers<cr>
    nnoremap <leader>fh <cmd>Telescope help_tags<cr>

    lua << EOF
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the four listed parsers should always be installed)
  ensure_installed = { "bash", "c", "cpp", "fish", "markdown", "python", "lua", "vim", "help" },

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
    -- disable = { "c", "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
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
    enable = true
  },
}
EOF
endif

set clipboard=unnamedplus
