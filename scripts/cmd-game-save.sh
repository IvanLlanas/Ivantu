source $IVANTU_SCRIPTS_DIR/conio.sh

file="backup.sh"
backup_path=""
game="$1"
comment="$2"


case $game in

   "ck"|"CK") backup_path="$HOME/Dropbox/Apps/Games/00-savegames/Active/Core Keeper"
              ___print_error "Ensure game directory: <1>$game<0>."
              exit
              ;;
   "gd"|"GD") backup_path="$HOME/Dropbox/Apps/Games/00-savegames/Active/Grim Dawn"
              ;;
     "v"|"V") backup_path="$HOME/Dropbox/Apps/Games/00-savegames/Active/Valheim"
              ;;

          "") ___cmd_usage "gsave gameid [\"comment\"]"
              ___print_info "<1>ck<0> - Core Keeper"
              ___print_info "<1>gd<0> - Grim Dawn"
              ___print_info " <1>v<0> - Valheim"
              exit
              ;;

           *) ___print_error "Unknown game <1>$game<0>."
              exit
              ;;
esac


pushd . >/dev/null

cd "$backup_path"

if test -f "$file"; then
   bash "$file" "$comment"
else
   ___print_error "File <1>$file<0> not found in directory <2>$backup_path<0>."
fi

popd >/dev/null
