#!/bin/bash
killall conky
sleep 2s
conky -c $HOME/.config/conky/cataclysm/cataclysm-no-diskio.conf &> /dev/null &
