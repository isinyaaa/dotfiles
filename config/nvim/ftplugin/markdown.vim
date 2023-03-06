if exists('g:vscode')
    " VSCode extension
else
    set spell
    let g:copilot_filetypes = {'markdown': v:true}
endif
