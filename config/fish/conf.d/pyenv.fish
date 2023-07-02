function __setup_pyenv
    set -gx PYENV_ROOT $HOME/.pyenv
    set -gx PATH $PYENV_ROOT/bin $PATH

    set -g VIRTUAL_ENV_DISABLE_PROMPT 1

    status is-login
    and pyenv init --path | source

    status is-interactive
    and pyenv init - | source
end
