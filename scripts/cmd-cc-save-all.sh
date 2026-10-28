#!/bin/bash
# ----------------------------------------------------------------------
source "$IVANTU_SCRIPTS_DIR/conio.sh"

# ----------------------------------------------------------------------
function cpv ()
{
   cp -v "$1" "$2"
}
function mvv ()
{
   mv -v "$1" "$2"
}
function cmp ()
{
   7z a -t7z -mx=9 -r $@
#   rar a -r -s -m5 -md1g $@
# rar exclusion parameter not working yet.
}
function cmpu ()
{
   7z u -r -t7z  $@
}
ext=7z
#ext=rar

dir_dropbox=$HOME/Dropbox/my-config/cc

# ----------------------------------------------------------------------
___print_info_bg "Saving <1>bash<0> files..."
cd
cpv .bashrc "$dir_dropbox/bashrc"
cpv .bash_aliases "$dir_dropbox/bash_aliases"

# ----------------------------------------------------------------------
echo
___print_info_bg "Saving <1>eza<0> theme..."
folder="$HOME/.config/eza/"
dir_dest=$dir_dropbox/eza
filename=theme.yml
cd $folder
cpv $filename $dir_data
mkdir $dir_dest
cpv $filename $dir_dest
echo $folder > $dir_dest/eza-location.txt

# ----------------------------------------------------------------------
echo
___print_info_bg "Saving <1>Ptyxis<0> theme..."
folder="$HOME/.local/share/org.gnome.Ptyxis/palettes/"
dir_dest=$dir_dropbox/ptyxis
filename=ptyxis-ivan.palette
cd $folder
mkdir $dir_dest
cpv $filename $dir_dest
echo $folder > $dir_dest/ptyxis-location.txt

# ----------------------------------------------------------------------
echo
___print_info_bg "Saving <1>config/ivan<0>..."
folder="$HOME/.config/ivan/"
filename=config-ivan
filename2=$filename.$ext
cd $folder
#cmp $filename2 -x\!*.txt
cmp $filename2
mvv $filename2 $dir_dropbox
echo $folder > $dir_dropbox/$filename-location.txt

# ----------------------------------------------------------------------
echo
___print_info_bg "Saving <1>desktop<0> files..."
folder="$HOME/Desktop/"
filename=desktop
filename2=$filename.$ext
cd $folder
cmp $filename2
mvv $filename2 $dir_dropbox
echo $folder > $dir_dropbox/$filename-location.txt

# ----------------------------------------------------------------------
echo
___print_info_bg "Saving <1>autostart<0> files..."
folder="$HOME/.config/autostart/"
filename=autostart
filename2=$filename.$ext
cd $folder
cmp $filename2
mvv $filename2 $dir_dropbox
echo $folder > $dir_dropbox/$filename-location.txt

# ----------------------------------------------------------------------
echo
___print_info_bg "Saving <1>XnView<0> configuration..."
folder="$HOME/.config/xnviewmp/"
filename=xnview
filename2=$filename.$ext
cd $folder
cmp $filename2 * -x\!*.db
mvv $filename2 $dir_dropbox
echo $folder > $dir_dropbox/$filename-location.txt

# ----------------------------------------------------------------------
# echo
# ___print_info_bg "Saving <1>Dash-to-Panel<0> configuration..."
# cd
# filename=cc-dash-to-panel-settings
# filename2=$filename.dconf
# filename3=$filename-install.sh
# dconf dump /org/gnome/shell/extensions/dash-to-panel/ > $filename2
# mvv $filename2 $dir_dropbox
# echo dconf load /org/gnome/shell/extensions/dash-to-panel/ "<" $filename2 > $dir_dropbox/$filename3

# ----------------------------------------------------------------------
echo
___print_info_bg "Saving <1>local-kate<0>..."
folder="$HOME/.local/share/kate/"
filename=kate-files
filename2=$filename.$ext
dir_dest=$dir_dropbox/kate
cd $folder
cmp $filename2
mvv $filename2 $dir_dest
echo $folder > $dir_dest/$filename-location.txt

# ----------------------------------------------------------------------
echo
___print_info_bg "Remember to save <1>panorama<0> and <1>dark-reader<0> settings."
echo
