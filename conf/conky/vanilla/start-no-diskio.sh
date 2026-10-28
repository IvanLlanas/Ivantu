#!/bin/bash
killall conky
sleep 2s
conky -c $HOME/.config/conky/vanilla/vanilla-no-diskio.conf &> /dev/null &
