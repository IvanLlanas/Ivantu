#!/bin/bash

# Move to the script location.
cd "$(dirname "$0")"

# Kill existing conky instances
pkill -x conky; pkill -f '^conky($| )'

# Do it!
conky -c cc-diskio.conf &> /dev/null &
