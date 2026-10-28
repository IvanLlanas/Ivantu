source $IVANTU_SCRIPTS_DIR/conio.sh

#  local bkpath="$HOME/Dropbox/Apps/Games/00-savegames/Active/Core Keeper/savegames"
#  local svpath="$HOME/snap/steam/common/.local/share/Steam/steamapps/compatdata/1621690/pfx/drive_c/users/steamuser/AppData/LocalLow/Pugstorm/Core

game="$1"

# Is fzf installed?
if [ -n "$(which fzf)" ]; then
   _FZF=true
else
   _FZF=false
fi


case $game in

   "ck"|"CK") backup_path="$HOME/Dropbox/Apps/Games/00-savegames/Active/Core Keeper/savegames"
              savegame_path="$HOME/snap/steam/common/.local/share/Steam/steamapps/compatdata/1621690/pfx/drive_c/users/steamuser/AppData/LocalLow/Pugstorm/Core Keeper/Steam/12240012"
              ___print_error "Ensure game directory: <1>$game<0>."
              #exit 1
              ;;
   "gd"|"GD") backup_path="$HOME/Dropbox/Apps/Games/00-savegames/Active/Grim Dawn/savegames"
              # savegame_path_remote="/mnt/vol-4tb/Games/Heroic/Prefixes/shared/drive_c/users/Public/Documents/Steam/RUNE/219990/remote"
              savegame_path="/mnt/vol-4tb/Games/Heroic/Prefixes/shared/drive_c/users/steamuser/Documents/My Games/Grim Dawn"
              ;;
     "v"|"V") backup_path="$HOME/Dropbox/Apps/Games/00-savegames/Active/Valheim/savegames"
              savegame_path="$HOME/snap/steam/common/.config/unity3d/IronGate"
              ;;

          "") ___cmd_usage "grestore gameid"
              ___print_info "<1>ck<0> - Core Keeper"
              ___print_info "<1>gd<0> - Grim Dawn"
              ___print_info " <1>v<0> - Valheim"
              exit
              ;;

           *) ___print_error "Unknown game <1>$game<0>."
              exit 1
              ;;
esac


file=""
answer=""

   if $_FZF ; then

      # fzf method ----------------------
      file=$(
      find "$backup_path" -maxdepth 1 -type f \
            -printf '%T@\t%TY-%Tm-%Td %TH:%TM - %f\t%f\n' |
      sort -n |
      tac |
      fzf \
            --delimiter=$'\t' \
            --with-nth=2 \
            --accept-nth=3 \
            --header="Backups: $backup_path" \
            --prompt="Select backup to restore: "
      )

   else

      # ls method -----------------------
      ___print_info_bg "Backups: <3>$backup_path<0>"
      ls -l "$backup_path"
      file=$(ls -Art "$backup_path" | tail -n 1)

   fi

   if [ "$file" != "" ]; then

      echo
      ___print_info_bg "Selected file: <3>$file<0>"
      echo
      echo -ne " Restore this file (y/$_ansi_lwhite""N$_ansi_off)? "
      read answer
      case $answer in

            "y"|"Y")
                     cd "$savegame_path"
                     # 7z x -y "$backup_path/$file"
                     rar x -y "$backup_path/$file"
                  ;;

                  *) file=""
                     ___print_warning "Cancelled"
                  ;;
      esac
   fi
