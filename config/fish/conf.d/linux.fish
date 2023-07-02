function __setup_linux
    set -gx PATH /opt/cuda/bin/ $PATH # cuda
    set -gx PATH /opt/cuda/nsight_compute/ $PATH # cuda
    # we need to start the gnome keyring daemon if we're on a desktop session
    # test -n "$DESKTOP_SESSION" &&\
    #     set -x (gnome-keyring-daemon --start | string split "=")
    # we also need to set up the docker socket
    command -q docker
    and systemctl --user is-active --quiet docker.socket
    and export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
end
