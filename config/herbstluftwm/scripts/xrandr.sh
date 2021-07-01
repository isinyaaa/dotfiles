#!/bin/bash

if [ $1 -eq 1 ]
then
    edp_flag="--auto"
    hdmi_flag="--off"
    dpi=110
else
    edp_flag="--off"
    hdmi_flag="--auto"
    dpi=100
fi

xrandr --output eDP1 $edp_flag --output HDMI1 $hdmi_flag

[ $1 -eq 3 ] && xrandr --output eDP1 --auto --output HDMI1 --auto --left-of eDP1 --primary

echo "Xft.dpi: $dpi" | xrdb -merge

herbstclient reload

