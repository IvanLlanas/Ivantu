#!/bin/bash
killall conky
sleep 2s
conky -c $HOME/.config/conky/inas/inas-no-diskio.conf &> /dev/null &
