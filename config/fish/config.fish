#source ~/.fancy-bash-promt.sh

# add export for working with android
#export ANDROID_HOME=/opt/android-sdk
#set -gx PATH $PATH $ANDROID_HOME/cmdline-tools/latest/bin

# for managing keys
export GPG_TTY=(tty)

# for managing ruby
#status --is-interactive; and source (rbenv init -|psub)
#set -gx PATH $PATH $HOME/.local/share/gem/ruby/3.0.0/bin

# update path
set -gx PATH $PATH $HOME/bin
set -gx PATH $PATH $HOME/.local/bin
set -gx PATH $PATH $HOME/.cargo/bin

# set user preferences
export default_user=isinyaaa
export NVIM_TUI_ENABLE_CURSOR_SHAPE=1

set -gx EDITOR nvim

# set the correct timezone and format for prompt
set -g theme_date_timezone America/Sao_Paulo
set -g theme_date_format "+%l:%M%P"

function fish_greeting
    colorscript --exec spectrum
end

alias wipe="clear; fish_greeting"

# create some functions and macros for kernel dev
function set_out
    set -g BUILD_FOLDER $argv
end

function get_output_folder
    echo 'O=$BUILD_FOLDER'
end

abbr -a mk make CC=\"ccache gcc -fdiagnostics-color\" -j8 (get_output_folder)
abbr -a mmd make modules CC=\"ccache gcc -fdiagnostics-color\" -j8 (get_output_folder)

function set_arch
    set -g ARCH $argv
    set -g ARCH_BUILD "$argv-build"
end

function get_arch
    echo 'ARCH=$ARCH O=$ARCH_BUILD'
end

abbr -a mcr COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross -j4 W=12 (get_arch)
