function use-gnu-utils
  set -gx PATH /opt/homebrew/opt/binutils/bin $PATH
  set -gx LDFLAGS "-L/opt/homebrew/opt/binutils/lib" $LDFLAGS
  set -gx CPPFLAGS "-I/opt/homebrew/opt/binutils/include" $CPPFLAGS

  set -gx PATH /opt/homebrew/opt/ncurses/bin $PATH
  set -gx LDFLAGS "-L/opt/homebrew/opt/ncurses/lib" $LDFLAGS
  set -gx CPPFLAGS "-I/opt/homebrew/opt/ncurses/include" $CPPFLAGS

  set -gx LDFLAGS "-L/opt/homebrew/opt/llvm/lib" $LDFLAGS
  set -gx CPPFLAGS "-I/opt/homebrew/opt/llvm/include" $CPPFLAGS

  set -gx PKG_CONFIG_PATH /usr/local/opt/ncurses/lib/pkgconfig $PKG_CONFIG_PATH

  set -gx PATH /opt/homebrew/opt/curl/bin $PATH
  set -gx LDFLAGS "-L/opt/homebrew/opt/curl/lib" $LDFLAGS
  set -gx CPPFLAGS "-I/opt/homebrew/opt/curl/include" $CPPFLAGS

  set -gx PKG_CONFIG_PATH /opt/homebrew/opt/curl/lib/pkgconfig $PKG_CONFIG_PATH
end
