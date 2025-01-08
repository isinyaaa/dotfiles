function __prompt_segment
    set_color $argv[2] -b $argv[1]

    [ -n "$argv[3]" ]
    and echo -n -s $argv[3]
end

function fish_mode_prompt
    test $fish_key_bindings != fish_vi_key_bindings
    and test "$fish_key_bindings" != "fish_hybrid_key_bindings"
    and return

    set -l bind_color red
    set -l bind_mode "N"

    switch $fish_bind_mode
        case insert
            set bind_color green
            set bind_mode "I"
        case visual
            set bind_color yellow
            set bind_mode "V"
        case replace_one
            set bind_color magenta
            set bind_mode "R"
    end
    __prompt_segment normal $bind_color "$bind_mode"
end
