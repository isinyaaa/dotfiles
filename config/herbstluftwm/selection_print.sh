#!/bin/bash

maim  -u -b 3 -m 5 -s /tmp/maim_clipboard && xclip -selection clipboard -t image/png /tmp/maim_clipboard &>/dev/null && rm /tmp/maim_clipboard
