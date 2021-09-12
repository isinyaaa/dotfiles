#!/bin/bash

xrandr --output eDP1 --auto --output HDMI1 --off && echo 'Xft.dpi: 110' | xrdb -merge

herbstclient reload
