#!/bin/bash

# Terminate already running bar instances
pgrep polybar >/dev/null && killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.05; done

BAR=mainbar
POLYBAR=$(polybar -m)

if [ $(wc -l <<< "$POLYBAR" | cut -d" " -f1) -gt 1 ]; then
  for m in $(cut -d":" -f1 <<< "$POLYBAR"); do
    #grep -q "$m.*primary" <<< "$POLYBAR" || BAR=dual
    grep -q "$m.*primary" <<< "$POLYBAR" && \
      MONITOR=$m polybar --reload $BAR &
  done
else
  MONITOR=$(cut -d":" -f1 <<< "$POLYBAR") polybar --reload $BAR &
fi
