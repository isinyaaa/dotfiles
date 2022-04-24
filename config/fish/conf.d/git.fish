abbr -a gg 'git grep'
abbr -a glg 'git log --grep='
alias gtop='cd (git top)'

function ggb -d "git grep + git blame"
    command git grep -En $argv[1] | while read --delimiter=: -l file line code
        git blame -f -L $line,$line $file | grep -E --color "$argv[1]|\$"
    end
end

function dsf
    diff -u "$argv[1]" "$argv[2]" | diff-so-fancy | less -R
end
