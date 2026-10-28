#!/bin/bash

CRITICAL='^(ubuntu-desktop.*|ubuntu-session.*|gdm3|gnome-.*|mutter.*|xwayland)$'

# Obtener la simulación de APT
output=$(apt -s "$@" 2>&1)
status=$?

echo "$output"

[ $status -ne 0 ] && exit $status

# Obtener paquetes que APT pretende eliminar:
#   Remv paquete ...
#   Purg paquete ...
removed=$(printf '%s\n' "$output" |
    sed -n 's/^\(Remv\|Purg\) \([^ :[]*\).*/\2/p')

dangerous=$(printf '%s\n' "$removed" |
    grep -E "$CRITICAL" || true)

if [ -n "$dangerous" ]; then
    echo
    echo "============================================================"
    echo "  ¡¡¡ ATENCIÓN: SE VA A ELIMINAR PARTE DEL ESCRITORIO !!!"
    echo "============================================================"
    echo
    echo "$dangerous"
    echo
    echo "Operación ABORTADA."
    exit 42
fi

exec sudo apt "$@"
