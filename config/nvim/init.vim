if exists('g:vscode')
    " VSCode extension
else
    " ordinary neovim
    set number

    set ignorecase
    set smartcase

    nmap Q <Nop>

    set mouse+=a
    set expandtab
    set shiftwidth=4
    set softtabstop=4

    " 80 characters line
    set colorcolumn=81
    "execute "set colorcolumn=" . join(range(81,335), ',')
    "highlight ColorColumn ctermbg=Black ctermfg=DarkRed

    highlight ExtraWhitespace ctermbg=red guibg=red
    match ExtraWhitespace /\s\+$/
    autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
    autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    autocmd InsertLeave * match ExtraWhitespace /\s\+$/
    autocmd BufWinLeave * call clearmatches()

    filetype plugin on
    filetype plugin indent on
    syntax on

    call plug#begin('~/.vim/plugged')
    Plug 'wakatime/vim-wakatime'
    Plug 'tpope/vim-fugitive'                   " git wrapper
    Plug 'airblade/vim-gitgutter'
    Plug 'vim-airline/vim-airline'              " status/tabline
    Plug 'vim-airline/vim-airline-themes'
    Plug 'tpope/vim-sleuth'

    "Plug 'drewtempelmeyer/palenight.vim'
    "Plug 'rakr/vim-one'
    Plug 'liuchengxu/space-vim-theme'
    "Plug 'liuchengxu/space-vim-dark'

    Plug 'tpope/vim-rhubarb'                    " vim-fugitive plugin for opening file on Github, using :Gbrowse
    Plug 'mileszs/ack.vim'                      " enabling ack (better than grep.vim)
    Plug 'scrooloose/nerdtree'                  " nerdtree plugin
    Plug 'tpope/vim-commentary'                 " comment/uncomment stuff
    Plug 'majutsushi/tagbar'                    " overview of current file structure
    Plug 'joe-skb7/cscope-maps'                 " cscope shortcuts

    Plug 'vivien/vim-linux-coding-style'

    "Plug 'ctrlpvim/ctrlp.vim'                   " fuzzy search
    Plug 'junegunn/fzf.vim', { 'do': { -> fzf#install() } } " fzf: more intuitive search than CtrlP
    "Plugin 'tpope/vim-surround'                  " manage surroundings (parenthesis, brackets, quotes, XML tags, etc.)
    Plug 'tpope/vim-repeat'                    " enable repeating supported plugin (not just native last command)
    "Plugin 'scrooloose/syntastic'                " syntax checking
    "Plugin 'psf/black'                           " Python code formatter: Black
    "Plugin 'elzr/vim-json'                       " json filetype plugin
    "Plugin 'google/vim-jsonnet'                  " jsonnet filetype plugin
    "Plugin 'rust-lang/rust.vim'                  " rust development plugin
    "Plugin 'godlygeek/tabular'                   " dependency for vim-markdown
    "Plugin 'plasticboy/vim-markdown'             " vim-markdown
    "Plugin 'jpo/vim-railscasts-theme'            " railscasts-theme
    call plug#end()

    let NERDTreeShowHidden=1

    nmap <C-n> <ESC>:NERDTreeToggle<CR>

    " CTags Settings
    " Refer: http://ctags.sourceforge.net/ or `man ctags`
    " enabling CTags
    set tags=tags;                               " tags file within project directory
    " open ctag in new tab
    map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
    " list all mapping using `:map`
    " if you do `Ctrl-k` and then press a key, the vim
    " will tell you how this key is know to vim

    " ack.vim Settings
    cnoreabbrev Ack Ack!
    " Shortcut for `:Ack! ` as `<Leader>a`
    nnoremap <Leader>a :Ack!<Space>
    let g:ackhighlight = 1                              " hightlight matches
    let g:ackprg = 'ag --nogroup --nocolor --column'    " Ag support

    " == THEME SETUP ==

    "colorscheme space-vim-dark
    colorscheme space_vim_theme
    hi Comment cterm=italic

    nmap ghp <Plug>(GitGutterPreviewHunk)
    nmap ghs <Plug>(GitGutterStageHunk)
    nmap ghu <Plug>(GitGutterUndoHunk)
    nmap ]h <Plug>(GitGutterNextHunk)
    nmap [h <Plug>(GitGutterPrevHunk)

    nmap ghw <ESC>:%s/\s\+$//e<CR>
    "BufWritePre * 
    "let g:airline_theme='space-vim-theme'

    " ==== vim-one ====
    "Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
    "If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
    "(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
    "if (empty($TMUX))
    "    if (has("nvim"))
    "        "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    "        let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    "  endif
      "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
      "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
      " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
    "    if (has("termguicolors"))
    "        set termguicolors
    "    endif
    "endif

    "set background=dark " for the dark version
    "set background=light " for the light version

    " ==== jellybeans ====

    "let g:jellybeans_overrides = {
    "\    'background': { 'ctermbg': 'none', '256ctermbg': 'none' },
    "\}
    "if has('termguicolors') && &termguicolors
    "    let g:jellybeans_overrides['background']['guibg'] = 'none'
    "endif

    " ==== space-vim-dark ====
    "hi Comment guifg=#5C6370 ctermfg=59

    " to set transparent BG
    function! AdaptColorscheme()
        highlight clear CursorLine
        highlight Normal ctermbg=none guibg=none
        highlight LineNr ctermbg=none
        highlight Folded ctermbg=none
        highlight NonText ctermbg=none
        highlight SpecialKey ctermbg=none
        highlight VertSplit ctermbg=none
        highlight SignColumn ctermbg=none
    endfunction
    "autocmd ColorScheme * call AdaptColorscheme()
endif

set clipboard=unnamedplus
