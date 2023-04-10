set -gx IS_MAC false
# find out if we're on mac
if uname -s | grep -iq 'darwin'
    # we redefine the OSTYPE to be the same as any UNIX system
    # because MacOS doesn't have it
    set -gx OSTYPE (uname -s | tr -s '[:upper:]' '[:lower:]')(uname -r)
    set -gx IS_MAC true
end

# set user preferences
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -gx EDITOR (which nvim)

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

# system specific setup
if test $IS_MAC = true
    set -gx PATH /opt/homebrew/opt/python@3.10/bin $PATH # python 3.10
    set -gx PATH $HOME/.gem/ruby/2.6.0/bin $PATH # ruby gems
    set -gx PATH $HOME/go/bin $PATH # go

    # copilot needs node@16
    set -gx PATH /opt/homebrew/opt/node@16/bin $PATH

    # locale variables
    set -gx LC_CTYPE en_US.UTF-8
    set -gx LC_ALL en_US.UTF-8
else
    # we need to start the gnome keyring daemon if we're on a desktop session
    # test -n "$DESKTOP_SESSION" &&\
    #     set -x (gnome-keyring-daemon --start | string split "=")
    # we also need to set up the docker socket
    systemctl --user is-active --quiet docker.socket &&\
        set -g DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
end

# rbenv setup
if command -q rbenv
    status --is-interactive; and source (rbenv init -|psub)
    set -gx PATH $PATH $HOME/.local/share/gem/ruby/3.0.0/bin
end

# pyenv setup
if command -q pyenv
    set -gx PYENV_ROOT $HOME/.pyenv
    set -gx PATH $PYENV_ROOT/bin $PATH
    status is-login; and pyenv init --path | source
    status is-interactive; and pyenv init - | source
end

# refresh sudo timeout
alias sudo 'command sudo -v; command sudo '

# jj completion setup
if command -q jj
    jj debug completion --fish | source
end

# override fish greeting
function fish_greeting
    if command -q colorscript
        colorscript --exec spectrum
    end
end

alias wipe="clear; exec fish"

# kitty ssh setup
if echo "$TERM" | grep -q "kitty"; and test -z "$SSH_CLIENT"
    alias ssh "kitty +kitten ssh"
end

# quality of life aliases and abbrs
alias rsp 'rsync -avzh --progress'
alias login "export BW_SESSION=(pass bitwarden/session00)"
alias tssh 'TERM=xterm-256color command ssh'
abbr -a ef exec fish
abbr -a tc topgrade -c
abbr -a ssa ssh arch
abbr -a ssl ssh local-arch

function last_history_item
    echo $history[1]
end

abbr -a fw --set-cursor "file (which %)"
