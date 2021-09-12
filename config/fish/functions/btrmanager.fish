function btrmanager --wraps buttermanager_program --description 'wrapper for gtk-lauch buttermanager'
  pushd $HOME/.local/share/applications/ && gtk-launch buttermanager.desktop && popd
end

