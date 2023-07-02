set -gx IS_MAC false
# find out if we're on mac
if uname -s | grep -iq 'darwin'
    # we redefine the OSTYPE to be the same as any UNIX system
    # because MacOS doesn't have it
    set -gx OSTYPE (uname -s | tr -s '[:upper:]' '[:lower:]')(uname -r)
    set -gx IS_MAC true
end

# set user preferences
command -q bat
and set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
command -q nvim
and set -gx EDITOR (which nvim)
and set -gx VISUAL (which nvim)

# refresh sudo timeout
alias sudo 'command sudo -v; command sudo '

# set prompt variables
set -g default_user isinyaaa
set -g theme_date_timezone America/Sao_Paulo
set -g theme_date_format "+%l:%M%p"

# enable GPG agent
set -gx GPG_TTY (tty)

# update path
set -gx PATH $HOME/bin $PATH
set -gx PATH $HOME/.local/bin $PATH
set -gx PATH $HOME/.cargo/bin $PATH # rust
set -gx PATH /opt/local/bin $PATH

# kitty ssh setup
echo "$TERM" | grep -q "kitty"
and test -z "$SSH_CLIENT"
and alias ssh "kitty +kitten ssh"

# override fish greeting
function fish_greeting
    command -q colorscript
    and colorscript --exec spectrum
end

# system specific setup
if test $IS_MAC = true
    __setup_macos
else
    __setup_linux
end

# setup commands
if command -q rbenv
    __setup_rbenv
end

if command -q pyenv
end

command -q jj
and jj debug completion --fish | source

command -q zoxide
and zoxide init fish | source
