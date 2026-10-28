#!/bin/bash
killall conky
sleep 2s
conky -c $HOME/.config/conky/wotlk/wotlk-diskio.conf &> /dev/null &
