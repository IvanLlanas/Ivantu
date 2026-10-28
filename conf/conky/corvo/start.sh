#!/bin/bash

# Move to the script location.
cd "$(dirname "$0")"

# Kill existing conky instances
killall conky

# Give some time...
sleep 2s

# Do it!
conky -c corvo-diskio.conf &> /dev/null &
