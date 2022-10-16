if exists('g:vscode')
    " VSCode extension
else
    set list
    set shiftwidth=8
    set tabstop=8
    set softtabstop=8
    set noexpandtab

    let g:neoformat_basic_format_align = 0
    let g:neoformat_basic_format_retab = 0
    let g:neoformat_basic_format_trim = 0

    " let g:ycm_language_server =
    "   \ [{
    "   \   'name': 'ccls',
    "   \   'cmdline': [ 'ccls' ],
    "   \   'filetypes': [ 'c', 'cpp', 'cuda', 'objc', 'objcpp' ],
    "   \   'project_root_files': [ '.ccls-root', 'compile_commands.json' ]
    "   \ }]

endif
