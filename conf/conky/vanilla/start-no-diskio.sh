#!/bin/bash

# Move to the script location.
cd "$(dirname "$0")"

# Kill existing conky instances
killall conky

# Do it!
conky -c $HOME/.config/conky/vanilla/vanilla-no-diskio.conf &> /dev/null &
