#!/bin/bash
killall conky
sleep 2s
conky -c $HOME/.config/conky/vader/vader-no-diskio.conf &> /dev/null &
