#!/bin/bash
killall conky
sleep 2s
conky -c $HOME/.config/conky/corvo/corvo-no-diskio.conf &> /dev/null &
