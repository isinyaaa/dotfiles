#source ~/.fancy-bash-promt.sh

set -gx OSTYPE (uname -s | tr -s '[:upper:]' '[:lower:]')(uname -r)
echo "$OSTYPE" | grep -q 'darwin'
if test $status
    set -gx IS_MAC true
else
    set -gx IS_MAC false
end

# add export for working with android
#export ANDROID_HOME=/opt/android-sdk
#set -gx PATH $PATH $ANDROID_HOME/cmdline-tools/latest/bin

# for managing keys
export GPG_TTY=(tty)

if test -n "$DESKTOP_SESSION" && test $IS_MAC != true
    set -x (gnome-keyring-daemon --start | string split "=")
end

# setup docker
test $IS_MAC != true && export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock

# for managing ruby
if command -q rbenv
    status --is-interactive; and source (rbenv init -|psub)
    set -gx PATH $PATH $HOME/.local/share/gem/ruby/3.0.0/bin
end

# update path
set -gx PATH $HOME/bin $PATH
set -gx PATH $HOME/.local/bin $PATH
set -gx PATH $HOME/.cargo/bin $PATH
test $IS_MAC = true && set -gx PATH /opt/homebrew/opt/python@3.10/bin $PATH
test $IS_MAC = true && set -gx PATH $HOME/.gem/ruby/2.6.0/bin $PATH
set -gx PATH /opt/local/bin $PATH

# add node 16 to path on MacOS
test $IS_MAC = true && set -gx PATH /opt/homebrew/opt/node@16/bin $PATH

# set user preferences
export default_user=isinyaaa
#export NVIM_TUI_ENABLE_CURSOR_SHAPE=1
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

alias login "export BW_SESSION=(pass bitwarden/session00)"

# refresh sudo timeout
alias sudo 'command sudo -v; command sudo '

set -gx EDITOR nvim

if test $IS_MAC = true
    set -gx LC_CTYPE en_US.UTF-8
    set -gx LC_ALL en_US.UTF-8
end

# set the correct timezone and format for prompt
set -g theme_date_timezone America/Sao_Paulo
set -g theme_date_format "+%l:%M%p"

function fish_greeting
    if command -q colorscript
        colorscript --exec spectrum
    end
end

alias wipe="clear; fish_greeting"

echo "$TERM" | grep -q "kitty"
if test -z $SSH_CLIENT -a $status -eq 0
    alias ssh "kitty +kitten ssh"
end

set -g LINUX_SRC_PATH "$HOME/shared/linux"
set -g VM_PATH "$HOME/vms"

abbr -ag ef exec fish
abbr -ag tc topgrade -c

# pyenv setup
if command -q pyenv
    status is-login; and pyenv init --path | source
    status is-interactive; and pyenv init - | source
end
