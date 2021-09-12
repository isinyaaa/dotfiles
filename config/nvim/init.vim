set number
set relativenumber

set ignorecase
set smartcase

nmap Q <Nop>

set mouse+=a

" reminders to not use arrow keys
nnoremap <Left>  :echoe "Use h"<CR>    
nnoremap <Right> :echoe "Use l"<CR>    
nnoremap <Up>    :echoe "Use k"<CR>    
nnoremap <Down>  :echoe "Use j"<CR>    
inoremap <Left>  <ESC>:echoe "Use h"<CR>    
inoremap <Right> <ESC>:echoe "Use l"<CR>    
inoremap <Up>    <ESC>:echoe "Use k"<CR>    
inoremap <Down>  <ESC>:echoe "Use j"<CR>