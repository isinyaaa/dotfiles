# "Icons"
# taking some hints from stefanmaric/bigfish
# additional spaces to work around not-really-monospace glyphs
set -g __git_icon_new     '⚹'
set -g __git_icon_changed '↺'
set -g __git_icon_removed '✖'
set -g __git_icon_stashed '≡'

set -g __git_icon_branch   '🜉'
set -g __git_icon_tag      '⌂'
set -g __git_icon_commit   '⌀'

set -g __git_icon_diverged '↕'
set -g __git_icon_ahead    '↑'
set -g __git_icon_behind   '↓'

# Colors
# cf. http://fishshell.com/docs/current/commands.html#set_color
set -g __git_color_new     "green"
set -g __git_color_changed "yellow"
set -g __git_color_removed "red"
set -g __git_color_stashed "white"

set -g __git_color_rev_bg      "555"
set -g __git_color_rev_fg      "fff"
set -g __git_color_rev_fg_warn "brred"

set -g __left_arrow_glyph \uE0B3
if [ "$theme_powerline_fonts" = "no" -a "$theme_nerd_fonts" != "yes" ]
    set -g __left_arrow_glyph '<'
end


function __print_git_branch_state
    if not set upstream_state (
            command git rev-list --count --left-right "@{upstream}...HEAD" 2> /dev/null
        )
        echo -n "$__git_icon_new " # no upstream branch configured
        return
    end

    set -l behind (echo $upstream_state | cut -f1)
    set -l ahead (echo $upstream_state | cut -f2)

    if test $behind -gt 0
        echo -n "$behind"

        test $ahead -gt 0
        and echo -n "$__git_icon_diverged$ahead"
        or echo -n "$__git_icon_behind"

        return
    end

    test $ahead -gt 0
    and echo -n "$__git_icon_ahead$ahead"
end


function __print_git_revlabel
    # Is it a branch?
    if set rev (command git symbolic-ref --short HEAD 2> /dev/null)
        set state (__print_git_branch_state)
        echo -n " $__git_icon_branch $rev $state"
        return
    end
    # No!

    # Is it a tag?
    if set rev (command git describe --tags --exact-match 2>/dev/null)
        echo -n " $__git_icon_tag $rev"
        return
    end
    # No!

    # Is it just a generic commit?
    if set rev (command git rev-parse --short HEAD 2> /dev/null)
        echo -n " $__git_icon_commit $rev"
        return
    end
    # No!

    # What is it? ... Not Git.
    return 1
end


function __show_git_status -d "Gets the current git status"
    git rev-parse --is-inside-work-tree >/dev/null 2>&1
    or return

    set -l new (command git status --porcelain=v1 --ignore-submodules=dirty \
    | grep -e '^ \?A' | wc -l | xargs)
    set -l mod (command git status --porcelain=v1 --ignore-submodules=dirty \
    | grep -e '^ \?\(M\|R\)' | wc -l | xargs)
    set -l del (command git status --porcelain=v1 --ignore-submodules=dirty \
    | grep -e '^ \?D' | wc -l | xargs)
    set -l stashed (command git stash list --no-decorate \
    | wc -l | xargs)

    # set -g fish_emoji_width 1

    set_color -b normal

    # Show the number of new files
    if [ "$new" != "0" ]
        set_color $__git_color_new
        echo " $new$__git_icon_new"
    end

    # Show the number of modified files
    if [ "$mod" != "0" ]
        set_color $__git_color_changed
        echo " $mod$__git_icon_changed"
    end

    # Show the number of removed files
    if [ "$del" != "0" ]
        set_color $__git_color_removed
        echo " $del$__git_icon_removed"
    end

    # Show the number of stashes
    if [ "$stashed" != "0" ]
        set_color $__git_color_stashed
        echo " $stashed$__git_icon_stashed"
    end

    echo -n ' '

    # Show the current revision, with bells and whistles
    set_color -b $__git_color_rev_bg
    if begin     test -f (git rev-parse --git-dir)/MERGE_HEAD;
        or  test -d (git rev-parse --git-path rebase-merge);
        or  test -d (git rev-parse --git-path rebase-apply)
        # cf. https://stackoverflow.com/a/3921928/539599
    end
        # Indicate that "something" is afoot
        set_color $__git_color_rev_fg_warn
    else
        set_color $__git_color_rev_fg
    end
    __print_git_revlabel

    echo -n ' '

    set_color normal
end

function __cmd_duration -S
    test "$theme_display_cmd_duration" = "no"
    and return

    test -z "$CMD_DURATION" -o "$CMD_DURATION" -lt 100
    and return

    set_color $__prompt_color

    if test "$CMD_DURATION" -lt 5000
        echo -ns $CMD_DURATION 'ms'
    else if test "$CMD_DURATION" -lt 60000
        __pretty_ms $CMD_DURATION s
    else if test "$CMD_DURATION" -lt 3600000
        set_color $fish_color_error
        __pretty_ms $CMD_DURATION m
    else
        set_color $fish_color_error
        __pretty_ms $CMD_DURATION h
    end

    set_color $__prompt_color

    echo -ns " $__left_arrow_glyph"
    set_color normal
end

function __pretty_ms -S -a ms -a interval -d 'Millisecond formatting for humans'
    set -l interval_ms
    set -l scale 1

    switch $interval
        case s
        set interval_ms 1000
        case m
        set interval_ms 60000
        case h
        set interval_ms 3600000
        set scale 2
    end

    math -s$scale "$ms/$interval_ms"
    echo -ns $interval
end

function __timestamp -S -d 'Show the current timestamp'
    test "$theme_display_date" = "no"
    and return

    set_color $__prompt_color

    set -q theme_date_format
    or set -l theme_date_format "+%c"

    echo -n ' '
    set -q theme_date_timezone
    and env TZ="$theme_date_timezone" date $theme_date_format
    or date $theme_date_format
    set_color normal
end

function fish_right_prompt -d "Prints right prompt"
    __cmd_duration
    __show_git_status
    __timestamp
    set_color normal
end
