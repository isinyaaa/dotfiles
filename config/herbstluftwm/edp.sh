#!/bin/bash

xrandr --output eDP1 --off --output HDMI1 --auto && echo 'Xft.dpi: 100' | xrdb -merge

herbstclient reload
