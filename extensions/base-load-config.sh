#!/bin/bash

source "../../scripts/conio.sh"

if [[ $# -ne 1 ]]; then
   ___cmd_descr "$0" "Load $extension configuration."
   ___cmd_usage "load-config.sh config-file.dconf"
   echo
   exit 1
fi

if [[ ! -f "$1" ]]; then
   ___print_error_bg "File <1>$1<0> not found."
   exit 1
fi

line1=$(head -n 1 -- "$1")

if [[ "$line1" == "[/]" ]]; then
   dconf load "$path" < "$1"
else
   ___print_error_bg "Invalid dconf file."
   exit 1
fi
