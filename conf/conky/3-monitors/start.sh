#!/bin/bash

# Move to the script location.
cd "$(dirname "$0")"

# Kill existing conky instances
killall conky

# Give some time...
sleep 10s

# Do it!
conky -c cc-diskio.conf &> /dev/null &
