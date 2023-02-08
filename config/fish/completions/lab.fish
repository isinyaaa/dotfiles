function _lab_quote_suffix
  if not commandline -cp | xargs echo 2>/dev/null >/dev/null
    if commandline -cp | sed 's/$/"/'| xargs echo 2>/dev/null >/dev/null
      echo '"'
    else if commandline -cp | sed "s/\$/'/"| xargs echo 2>/dev/null >/dev/null
      echo "'"
    end
  else
    echo ""
  end
end

function _lab_callback
  commandline -cp | sed "s/\$/"(_lab_quote_suffix)"/" | sed "s/ \$/ ''/" | xargs lab _carapace fish _
end

complete -c lab -f
complete -c 'lab' -f -a '(_lab_callback)' -r
