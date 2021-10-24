#!/bin/bash

dpi=100

xrandr-set()
{
    [ $# == 2 ] || return
    eval xrandr --output eDP1 "$1" --output HDMI1 "$2"
}

function laptop-only()
{
    edp_flags="--auto"
    hdmi_flags="--off"
    dpi=110
}

function hdmi-only()
{
    edp_flags="--off"
    hdmi_flags="--auto"
}

function dual-monitors()
{
    # small hack to make it work properly
    hdmi-only
    xrandr-set
    edp_flags="--auto"
    hdmi_flags="--auto --left-of eDP1 --primary"
}

if [ "$#" > 0 ]; then
    case $1 in
        --laptop-only)
            laptop-only
            ;;
        --hdmi-only)
            hdmi-only
            ;;
        *)
            dual-monitors
            ;;
    esac

    xrandr-set "$edp_flags" "$hdmi_flags"

    echo "Xft.dpi: $dpi" | xrdb -merge

    herbstclient reload
else
    printf "%s" "no arguments passed, exiting..."
fi
