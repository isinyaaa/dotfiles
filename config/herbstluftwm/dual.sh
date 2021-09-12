#!/bin/bash

xrandr --output eDP1 --off --output HDMI1 --auto; xrandr --output eDP1 --auto --output HDMI1 --auto --left-of eDP1 --primary && echo 'Xft.dpi: 100' | xrdb -merge

herbstclient reload
