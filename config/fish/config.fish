#source ~/.fancy-bash-promt.sh

# add export for working with android
#export ANDROID_HOME=/opt/android-sdk
#set -gx PATH $PATH $ANDROID_HOME/cmdline-tools/latest/bin

# for managing keys
export GPG_TTY=(tty)

if test -n "$DESKTOP_SESSION"
    set -x (gnome-keyring-daemon --start | string split "=")
end

# for managing ruby
#status --is-interactive; and source (rbenv init -|psub)
#set -gx PATH $PATH $HOME/.local/share/gem/ruby/3.0.0/bin

# update path
set -gx PATH $PATH $HOME/bin
set -gx PATH $PATH $HOME/.local/bin
set -gx PATH $PATH $HOME/.cargo/bin

# set user preferences
export default_user=isinyaaa
#export NVIM_TUI_ENABLE_CURSOR_SHAPE=1

set -gx EDITOR nvim

# set the correct timezone and format for prompt
set -g theme_date_timezone America/Sao_Paulo
set -g theme_date_format "+%l:%M%P"

function fish_greeting
    colorscript --exec spectrum
end

alias wipe="clear; fish_greeting"

alias ssh="kitty +kitten ssh"

set -g LINUX_SRC_PATH "$HOME/shared/linux"
set -g VM_PATH "$HOME/vms"

# pyenv setup
status is-login; and pyenv init --path | source
status is-interactive; and pyenv init - | source
