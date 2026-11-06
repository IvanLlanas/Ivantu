#!/bin/bash

source "../../scripts/conio.sh"

if [[ $# -ne 1 ]]; then
   ___cmd_descr "$0" "Save $extension configuration."
   ___cmd_usage "save-config.sh config-file.dconf"
   echo
   exit 1
fi

if [[ -f "$1" ]]; then
   ___print_warning "File <1>$1<0> already exists."
   ___print_text " Overwrite? (<1>y<0>/<1>N<0>): "
   read -r answer

   case "$answer" in
       y|Y|yes|YES)
                    ;;
                 *) ___print_error "Cancelled"
                    exit 1
                    ;;
   esac
fi

dconf dump "$path" > "$1"
___print_info "Saved."
exit 0
