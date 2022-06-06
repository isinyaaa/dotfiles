abbr -a gg 'git grep'
abbr -a glg 'git log --grep='
alias gtop='cd (git top)'

function gcd
    echo $argv | grep -q http
    set ret $status
    if test (count $argv) -eq 1 -a $ret -ne 0
        set argv https://github.com/$argv
    end
    set fname $argv[-1]
    echo $fname | grep -q http
    if test $status -eq 0
        set fname (basename $fname)
        echo $fname | grep -qF .git
        if test $status -eq 0
            set fname (echo $fname | sed -e 's/\(.*\)\.git/\1/')
        end
    end
    git clone $argv && cd $fname
end

function ggb -d "git grep + git blame"
    command git grep -En $argv[1] | while read --delimiter=: -l file line code
        git blame -f -L $line,$line $file | grep -E --color "$argv[1]|\$"
    end
end

function dsf
    diff -ru "$argv[1]" "$argv[2]" | diff-so-fancy | less -R
end
