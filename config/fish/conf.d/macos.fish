function __setup_macos
    set -gx PATH (brew --prefix python3)/bin $PATH # python 3.11
    set -gx PATH (brew --prefix ruby)/bin $PATH # ruby gems
    set -gx JAVA_HOME (brew --prefix java)
    set -gx PATH (brew --prefix perl)/bin $PATH

    set -gx PERL_MM_OPT "INSTALL_BASE=$HOME/perl5" cpan local::lib
    # perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5

    # locale variables
    set -gx LC_CTYPE en_US.UTF-8
    set -gx LC_ALL en_US.UTF-8
end
