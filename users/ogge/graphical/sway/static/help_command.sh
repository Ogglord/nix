#!/usr/bin/env bash

cat <<EOF
-^- USEFUL CLI NUGGETS _**>

# 1. show all graphic cards and outputs
ls /sys/class/drm/card*

# 2. show info about vulkan and drivers
vulkaninfo | less

# 3. shows resolution and refresh rate
swaymsg -t get_outputs

# 4. get info about keyboard and mouse events
sudo libinput debug-events

EOF