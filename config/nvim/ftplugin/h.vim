if exists('g:vscode')
    " VSCode extension
else
    set list
    set shiftwidth=8
    set tabstop=8
    set softtabstop=8
    set noexpandtab

    " let g:ycm_language_server =
    "   \ [{
    "   \   'name': 'ccls',
    "   \   'cmdline': [ 'ccls' ],
    "   \   'filetypes': [ 'c', 'cpp', 'cuda', 'objc', 'objcpp' ],
    "   \   'project_root_files': [ '.ccls-root', 'compile_commands.json' ]
    "   \ }]

endif
