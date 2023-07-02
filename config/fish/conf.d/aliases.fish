alias clear 'command clear; and exec fish'
alias wipe clear

# quality of life aliases and abbrs
alias rsp 'rsync -avzh --progress'
alias tssh 'TERM=xterm-256color command ssh -p 2222'
alias mssh 'TERM=minix command ssh -p 2222 -oHostKeyAlgorithms=+ssh-rsa'

function rdelta
    command diff -ru "$argv[1]" "$argv[2]" | delta
end

function mkd
	mkdir -p $argv; and cd $argv
end

abbr -a ef exec fish
abbr -a ssa ssh arch
abbr -a ssl ssh local-arch
abbr -a fw --set-cursor "file (which %)"
abbr -a gg 'git grep'
abbr -a glg 'git log --grep='

command -q topgrade
and abbr -a tc topgrade -c
