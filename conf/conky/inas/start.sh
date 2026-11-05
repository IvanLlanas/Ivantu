#!/bin/bash

# Move to the script location.
cd "$(dirname "$0")"

# Kill existing conky instances
killall conky

# Do it!
conky -c inas-diskio.conf &> /dev/null &
