#!/bin/bash

maim_args="-u -b 3 -m 5"

if [ $# -gt 0 ]
then
    filename="/etc/maim_clipboard"
    maim $maim_args -s /tmp/maim_clipboard && xclip -selection clipboard -t image/png /tmp/maim_clipboard &>/dev/null && rm /tmp/maim_clipboard
else
    screenshots_path="$HOME/pictures/screenshots"
    [ -d $screenshots_path ] || mkdir -p $screenshots_path
    filename="$screenshots_path/$(date +%Y.%m.%d-%H.%M.%S)-screenshot.png"
    maim $maim_args $filename && xclip -selection clipboard -t image/png $filename &>/dev/null
fi
