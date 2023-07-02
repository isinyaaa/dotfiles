function __setup_macos
    set -gx PATH /opt/homebrew/opt/python@3.10/bin $PATH # python 3.10
    set -gx PATH $HOME/.gem/ruby/2.6.0/bin $PATH # ruby gems
    set -gx PATH $HOME/go/bin $PATH # go

    # copilot needs node@16
    set -gx PATH /opt/homebrew/opt/node@16/bin $PATH

    # locale variables
    set -gx LC_CTYPE en_US.UTF-8
    set -gx LC_ALL en_US.UTF-8
end
