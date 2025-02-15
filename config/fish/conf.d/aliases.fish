function __set_aliases
    alias clear 'command clear; and exec fish'
    alias wipe clear

    alias rsp 'rsync -avzh --progress'
    alias tssh 'TERM=xterm-256color command ssh -p 2222'

    function rdelta
        command diff -ru "$argv[1]" "$argv[2]" | delta
    end

    function mkd
        mkdir -p $argv
        and cd $argv
    end

    function nsd
        PAGER="less -R" jj show $argv
        jj describe $argv
    end

    abbr -a ef exec fish
    abbr -a lsb 'lemonade server 2>&1 >/dev/null &'
    abbr -a ssa ssh arch
    abbr -a ssl ssh local-arch
    abbr -a fw --set-cursor "file (which %)"
    abbr -a gg 'git grep'
    abbr -a glg 'git log --grep='
    command -q jj
    and abbr -a nn jj
    and abbr -a nnl 'jj log'
    and abbr -a nns 'jj st'
    and abbr -a nnpm 'jj smb && jj pm'
    and abbr -a nnpb --set-cursor 'jj sb % && jj pm'
    and abbr -a --position anywhere idk -- --ignore-immutable

    command -q topgrade
    and abbr -a tc topgrade -c

    command -q eza
    and alias ls 'eza -l --git --icons --group-directories-first'

    command -q huggingface-cli
    and alias hf huggingface-cli

    command -q neofetch
    and alias neopets neofetch
end
