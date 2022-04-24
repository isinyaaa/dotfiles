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
test $IS_MAC = true && set -gx PATH $HOME/Library/Python/3.9/bin $PATH
set -gx PATH /opt/local/bin $PATH

# set user preferences
export default_user=isinyaaa
#export NVIM_TUI_ENABLE_CURSOR_SHAPE=1
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

alias login "export BW_SESSION=(pass bitwarden/session00)"

# refresh sudo timeout
alias sudo 'command sudo -v; command sudo '

set -gx EDITOR nvim

set -gx LC_CTYPE de_DE.UTF-8
set -gx LC_ALL de_DE.UTF-8

# set the correct timezone and format for prompt
set -g theme_date_timezone America/Sao_Paulo
set -g theme_date_format "+%l:%M%p"

function fish_greeting
    colorscript --exec spectrum
end

alias wipe="clear; fish_greeting"

if test (echo "$TERM" | grep -q "kitty")
    alias ssh="kitty +kitten ssh"
end

set -g LINUX_SRC_PATH "$HOME/shared/linux"
set -g VM_PATH "$HOME/vms"

# pyenv setup
if command -q pyenv
    status is-login; and pyenv init --path | source
    status is-interactive; and pyenv init - | source
end
