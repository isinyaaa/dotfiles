function __setup_rbenv
    status --is-interactive
    and source (rbenv init -|psub)

    set -gx PATH $PATH $HOME/.local/share/gem/ruby/3.0.0/bin
end
