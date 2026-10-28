#!/bin/bash
killall conky
sleep 2s
conky -c $HOME/.config/conky/ivan/ivan-no-diskio.conf &> /dev/null &
