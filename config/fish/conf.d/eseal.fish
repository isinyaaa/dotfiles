function __eseal_prompt
    set -l prompt_path (realpath (dirname (status filename))/../prompt)
    for i in $prompt_path/*.fish
        source $i
    end
end
