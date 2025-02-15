# "Icons"
set -g __prompt_icon_prompt  "\$"
set -g __prompt_icon_root    "\#"

# Colors

set -g __prompt_color_fail_bg "brred"

set -g __prompt_color_venv "green"
set -g __prompt_color_user "7aa6da"
set -g __prompt_color_host "bd93f9"
set -g __prompt_color_path "blue"

set -g __prompt_color  "999"

function __show_retval -d "Show return value of last command"
    test $RETVAL -eq 0
    and __prompt_segment normal white " "
    and return


    __prompt_segment \
        normal \
        $__prompt_color_fail_bg \
        "$RETVAL!"
end

function __show_virtualenv -d "Show active python virtual environments"
    set -q VIRTUAL_ENV
    or return

    set -l venvname (basename "$VIRTUAL_ENV")
    and __prompt_segment \
        normal \
        $__prompt_color_venv \
        "$venvname "
end

## Show user if not in default users
function __show_user -d "Show user"
    test -z "$SSH_CLIENT"
    and contains $USER $default_user
    and return

    set -l who (whoami)
    __prompt_segment \
        normal \
        $__prompt_color_user \
        "$who"

    command -q hostname
    or return

    [ "$USER" != "$HOST" ]
    or return

    set -l host (hostname -s)
        __prompt_segment \
            normal \
            $__prompt_color_host \
            "@$host"

    __prompt_segment normal normal " "
end

## Function to show current status
function __show_status -d "Function to show the current status"
    __show_retval

    __show_user

    __show_virtualenv
end

function __set_venv_project --on-variable VIRTUAL_ENV
    if test -e $VIRTUAL_ENV/.project
        set -g VIRTUAL_ENV_PROJECT (cat $VIRTUAL_ENV/.project)
    end
end

function __show_pwd
    set -l pwd
    if [ (string match -r '^'"$VIRTUAL_ENV_PROJECT" $PWD) ]
        set pwd (string replace -r '^'"$VIRTUAL_ENV_PROJECT"'($|/)' '≫ $1' $PWD)
    else
        set pwd (prompt_pwd)
    end
    __prompt_segment normal $__prompt_color_path "$pwd"
end

function __show_prompt
    set -l uid (id -u $USER)

    if [ $uid -eq 0 ] # This is root!
        __prompt_segment \
        red \
        $__prompt_color \
        " $__prompt_icon_root "
        set_color normal
        echo -n -s " "
    else
        __prompt_segment \
        normal \
        $__prompt_color \
        " $__prompt_icon_prompt "
    end
end

## SHOW PROMPT
function fish_prompt
    set -g RETVAL $status
    __show_status
    __show_pwd
    __show_prompt
    set_color normal
end
