#source ~/.fancy-bash-promt.sh

export ANDROID_HOME=/opt/android-sdk/
export default_user=isinyaaa
fish_vi_key_bindings

#status --is-interactive; and source (rbenv init -|psub)


# update path
set -gx PATH $PATH $HOME/bin
set -gx PATH $PATH $HOME/.local/bin
set -gx PATH $PATH $HOME/.local/share/gem/ruby/3.0.0/bin
set -gx PATH $PATH $ANDROID_HOME/cmdline-tools/latest/bin

export GPG_TTY=(tty)

# set the correct timezone for prompt
set -g theme_date_timezone America/Sao_Paulo
set -g theme_date_format "+%l:%M%P"

# set editor
set -gx EDITOR nvim

function fish_greeting
	colorscript --exec spectrum
end

