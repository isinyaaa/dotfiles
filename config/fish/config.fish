set -gx PATH /opt/local/bin $PATH
set -gx PATH $HOME/.local/bin $PATH
set -gx PATH $HOME/bin $PATH
set -gx PATH $HOME/.cargo/bin $PATH
set -gx PATH $HOME/go/bin $PATH
set -gx ZVM_INSTALL $HOME/.zvm/self
set -gx PATH $HOME/.zvm/bin $PATH
set -gx PATH $ZVM_INSTALL/ $PATH
set -gx MODULAR_HOME $HOME/.modular
set -gx PATH $MODULAR_HOME/pkg/packages.modular.com_mojo/bin $PATH
set -gx PATH $MODULAR_HOME/pkg/packages.modular.com_max/bin $PATH
set -gx PATH $HOME/.codon/bin $PATH
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

if uname -s | grep -iq darwin
    # we redefine the OSTYPE to be the same as any UNIX system
    # because MacOS doesn't have it
    set -gx OSTYPE (uname -s | tr -s '[:upper:]' '[:lower:]')(uname -r)
    set -gx IS_MAC true
    eval (/opt/homebrew/bin/brew shellenv)
    __setup_macos
else
    set -gx IS_MAC false
    __setup_linux
end

command -q rye
set -gx PATH $HOME/.rye/shims $PATH

# refresh sudo timeout
alias sudo 'command sudo -v; command sudo '

# set prompt variables
set -g default_user isinyaaa wolfie
set -g theme_date_timezone America/Sao_Paulo
set -g theme_date_format "+%l:%M%p"

# enable GPG agent
set -gx GPG_TTY (tty)


# set user preferences
command -q bat
and set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
command -q nvim
and set -gx EDITOR (which nvim)
and set -gx VISUAL (which nvim)

# override fish greeting
function fish_greeting
    command -q colorscript
    and colorscript --exec spectrum
end

command -q zoxide
and zoxide init fish | source

command -q atuin
and atuin init fish | source

__set_aliases

function fish_user_key_bindings
    fish_vi_key_bindings
end

# prompt
__eseal_prompt
