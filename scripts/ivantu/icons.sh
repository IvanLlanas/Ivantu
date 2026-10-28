#!/bin/bash

# Functions --------------------------------------------------------------------
# function install_ivantu_icons ()
# function update_folder_icons ()
# ------------------------------------------------------------------------------
# This script will install Ivantu iconset for Gnome 48+.
# ------------------------------------------------------------------------------
# http://www.patorjk.com/software/taag/#p=display&f=Ogre&t=IvantuIcons
# ------------------------------------------------------------------------------
#
# Here is a set of instructions that should get you a custom icon for hwp files.
# Open a terminal :
#     Check the MIME type exists : grep 'hwp' /etc/mime.types
#     if you get an output resembling application/x-hwp hwp skip the next step.
#     Create the MIME type sudo -H gedit /etc/mime.types and add the line application/x-hwp hwp
#     Add the icon (which must be called application-x-hwp.svg):
#     sudo cp PathToIcon/application-x-hwp.svg /usr/share/icons/gnome/scalable/mimetypes
#     (don't forget to replace PathToIcon)
# Got the information from: http://wiki.ubuntu.com.cn/UbuntuHelp:AddingMimeTypes
#
# ------------------------------------------------------------------------------
function install_ivantu_icons ()
{
   print_title "$var_current_category" "Install <1>Ivantu<0> iconset"

   confirm 0 "Do you want to continue"
   if [ $var_confirmed -gt 0 ]; then
      _install_ivantu_iconset "$current_theme"
      update_folder_icons
   else
      ___print_info $skipping_
   fi
   CR
}

# ------------------------------------------------------------------------------
function _install_ivantu_iconset ()
{
   local iconsetdir="$HOME/.local/share/icons/Ivantu"
   rm $iconsetdir -r | sed 's/^/  rm: /'
   mkdir -p $iconsetdir
   cp -rP "$_ivantu_icons_dir/icon-set"/* $iconsetdir | sed 's/^/  cp: /'

   gsettings set org.gnome.desktop.interface icon-theme 'Ivantu' | sed 's/^/  set: /'
   gtk-update-icon-cache -f -t $iconsetdir | sed 's/^/  upd: /'
}

# ------------------------------------------------------------------------------
# function update_folder_icons (theme)
# Replaces some nice system icons.
# ------------------------------------------------------------------------------
function update_folder_icons ()
{
   confirm 0 "Assign custom <1>folders<0> icons"
   if [ $var_confirmed -gt 0 ]; then
      _assign_ivantu_icons
   else
      ___print_info $skipping_
   fi
}

# ------------------------------------------------------------------------------
function _assign_ivantu_icons ()
{
   #$HOME/Documents
   #$HOME/Downloads
   #$HOME/Pictures

   set_icon /home/ivan                                      folders/folder-user-ivan-1.png
   set_icon /bin                                            folders/folder-binaries-1.png
   set_icon /sbin                                           folders/folder-binaries-2.png
   set_icon /opt                                            folders/folder-binaries-1.png
   set_icon /lib                                            folders/folder-books-1.png
   set_icon /lib64                                          folders/folder-books-1.png
   set_icon /boot                                           folders/folder-rocket-1.png
   set_icon /cdrom                                          folders/folder-cdrom-1.png
   set_icon /media                                          folders/folder-usb-1.png
   set_icon /mnt                                            folders/folder-storage-1.png
   set_icon /dev                                            folders/folder-devices-1.png
   set_icon /etc                                            folders/folder-system-files-1.png
   set_icon /home                                           folders/folder-home-1.png
   set_icon /tmp                                            folders/folder-recycle-1.png
   set_icon /proc                                           folders/folder-system-1-50.png
   set_icon /run                                            folders/folder-system-1-50.png
   set_icon /sys                                            folders/folder-system-1.png
   set_icon /snap                                           folders/folder-ubuntu-1.png
   set_icon /srv                                            folders/folder-database-1.png
   set_icon /root                                           folders/folder-user-root-1.png
   set_icon /usr                                            folders/folder-user-1.png
   set_icon /var                                            folders/folder-logs-1.png

   set_icon $(realpath -s "$_ivantu_dir")                   folders/folder-ivantu-1.png
   set_icon $(realpath -s "$_ivantu_dir/../Ivantu.base")    folders/folder-ivantu-2.png
   set_icon $HOME/Projects/wowsss                           folders/games/folder-wow-1.png
   set_icon $HOME/Projects/WoWSSS                           folders/games/folder-wow-1.png

   set_icon $HOME/Games                                     folders/folder-games-1.png
   set_icon $HOME/GamesStore                                folders/folder-games-box-1.png
   set_icon $HOME/Media                                     folders/folder-videos-2.png
   set_icon $HOME/Scripts                                   folders/folder-sources-1.png
   set_icon $HOME/Projects                                  folders/folder-projects-1.png
   set_icon $HOME/snap                                      folders/folder-ubuntu-red-1.png
   set_icon $HOME/Dropbox                                   folders/folder-dropbox-2.png
   set_icon $HOME/Store                                     folders/folder-resources-1.png
   set_icon $HOME/VM                                        folders/folder-vmware-1.png
   set_icon $HOME/Pictures/Screenshots                      folders/folder-camera-1.png
   set_icon $HOME/Pictures/Wallpapers                       folders/folder-wallpaper-1.png

   set_icon $HOME/.aMule                                    folders/folder-amule-1.png
   set_icon $HOME/.aMule/Incoming                           folders/folder-amule-1.png
   set_icon $HOME/.aMule/Temp                               folders/folder-trash-1.png
   set_icon $HOME/.cache                                    folders/folder-trash-1.png
   set_icon $HOME/.config                                   folders/folder-settings-1.png
   set_icon $HOME/.config/ivan                              folders/folder-ivan-red-1.png
   set_icon $HOME/.local                                    folders/folder-settings-1.png
   set_icon $HOME/.wine                                     folders/folder-windows-1.png

   set_icon $HOME/Games/doom                                folders/games/folder-doomguy-1.png
   set_icon "$HOME/Games/Cyberpunk 2077 2.31a"              folders/games/folder-cyberpunk-1.png
   set_icon $HOME/Games/DREDGE-2879                         folders/games/folder-dredge-1.png
   set_icon "$HOME/Games/Diablo II Resurrected"             folders/games/folder-diablo-1.png
   set_icon "$HOME/Games/MAMEplus GUI"                      folders/games/folder-retro-1.png
   set_icon "$HOME/Games/Minecraft 1.14.4"                  folders/games/folder-minecraft-1.png
   set_icon "$HOME/Games/PVZ Replanted"                     folders/games/folder-pvz-1.png
   set_icon "$HOME/Games/Unreal Gold"                       folders/games/folder-unreal-gold-1.png
   set_icon "$HOME/Games/Unreal Tournament 469c"            folders/games/folder-unreal-tournament-1.png
   set_icon "$HOME/Games/Warcraft II Remastered"            folders/games/folder-warcraft2-1.png
   set_icon "$HOME/Games/Warcraft I Remastered"             folders/games/folder-warcraft-1.png
   set_icon $HOME/Games/WoW                                 folders/games/folder-wow-1.png

   set_icon $HOME/Dropbox/lost+found                        folders/folder-opacity-25.png
   set_icon $HOME/Dropbox/Apps                              folders/folder-apps-1.png
   set_icon $HOME/Dropbox/Apps.Live                         folders/folder-apps-red-1.png
   set_icon "$HOME/Dropbox/Cargas de cámara"                folders/folder-camera-1.png
   set_icon $HOME/Dropbox/Containers                        folders/folder-docker-1.png
   set_icon $HOME/Dropbox/_delete                           folders/folder-trash-1.png
   set_icon $HOME/Dropbox/Docencia                          folders/folder-docencia-1.png
   set_icon "$HOME/Dropbox/Docencia/2025-26 l'Estatut"      folders/folder-red-1.png
   set_icon $HOME/Dropbox/Documents                         folders/folder-documents-1.png
   set_icon "$HOME/Dropbox/Google Drive"                    folders/folder-google-drive-1.png
   set_icon $HOME/Dropbox/2-do                              folders/folder-warning-1.png
   set_icon $HOME/Dropbox/Images                            folders/folder-pictures-1.png
   set_icon $HOME/Dropbox/my-config                         folders/folder-ivan-1.png
   set_icon $HOME/Dropbox/Resources                         folders/folder-resources-1.png
   set_icon $HOME/Dropbox/Source                            folders/folder-sources-1.png
   set_icon $HOME/Dropbox/VM                                folders/folder-vmware-1.png
   set_icon $HOME/Dropbox/Web                               folders/folder-web-1.png
   set_icon $HOME/Dropbox/.dropbox.cache                    folders/folder-trash-1.png
   set_icon $HOME/Dropbox/.Trash-1000                       folders/folder-trash-1.png

   set_icon $HOME/Dropbox/Apps/Games                        folders/folder-games-1.png
   set_icon $HOME/Dropbox/Apps/VMware                       folders/folder-vmware-1.png
   set_icon $HOME/Dropbox/Apps/Utils                        folders/folder-tools-1.png
   set_icon $HOME/Dropbox/Apps/OS                           folders/folder-windows-2.png
   set_icon $HOME/Dropbox/Apps/OS/MS-DOS                    folders/folder-msdos-1.png
   set_icon $HOME/Dropbox/Apps/OS/Linux                     folders/folder-linux-1.png
   set_icon $HOME/Dropbox/Apps/OS/Linux/Ubuntu              folders/folder-ubuntu-1.png
   set_icon $HOME/Dropbox/Apps/OS/Windows                   folders/folder-windows-1.png
   set_icon $HOME/Dropbox/Apps/Utils/Android                folders/folder-android-1.png
   set_icon $HOME/Dropbox/Apps/Utils/Linux                  folders/folder-linux-1.png
   set_icon "$HOME/Dropbox/Apps/Utils/Mac OS"               folders/folder-macos-1.png
   set_icon $HOME/Dropbox/Apps/Utils/MS-DOS                 folders/folder-msdos-1.png
   set_icon $HOME/Dropbox/Apps/Utils/Windows                folders/folder-windows-1.png
   set_icon $HOME/Dropbox/Apps/Utils/Internet               folders/folder-web-1.png
   set_icon $HOME/Dropbox/Apps/Utils/Linux/Media            folders/folder-videos-2.png
   set_icon $HOME/Dropbox/Apps/Utils/Linux/Scripts          folders/folder-sources-1.png
   set_icon $HOME/Dropbox/Apps/VMware/Linux                 folders/folder-linux-1.png
   set_icon $HOME/Dropbox/Apps/VMware/Windows               folders/folder-windows-1.png
   set_icon $HOME/Dropbox/Dropbox/Apps/Utils/Android        folders/folder-android-1.png
   set_icon $HOME/Dropbox/Dropbox/Apps/Utils/Mac\ OS        folders/folder-macos-1.png
   set_icon $HOME/Dropbox/Dropbox/Apps/Utils/MS-DOS         folders/folder-msdos-1.png
   set_icon $HOME/Dropbox/Source/Personal                   folders/folder-ivan-1.png
   set_icon $HOME/Dropbox/Source/MS-DOS                     folders/folder-msdos-1.png


   set_icon $HOME/VM/_shared                                folders/folder-windows-2.png
   set_icon $HOME/VM/MSDOS                                  vm/vm-msdos-1.png
   set_icon $HOME/VM/VM_DEBIAN-13                           vm/vm-debian-2.png
   set_icon $HOME/VM/VM_DELPHI11                            vm/vm-delphi-1.png
   set_icon $HOME/VM/VM_OFFICE4                             vm/vm-office-1.png
   set_icon $HOME/VM/VM_UBUNTU-25                           vm/wm-ubuntu-6.png
   set_icon $HOME/VM/VM_UBUNTU-26                           vm/wm-ubuntu-6.png
   set_icon $HOME/VM/VM_WINDOWS-11                          vm/vm-windows-11-1.png
   set_icon $HOME/VM/VM_WINDOWS_APPS                        vm/vm-photoshop-1.png
}

# ------------------------------------------------------------------------------
# function set_icon (folder, icon)
# ------------------------------------------------------------------------------
function set_icon ()
{
   local folder=$1
   local icon="$2"
   icon="$_ivantu_icons_dir/$icon"

   if [ ! -f "$icon" ]; then
      not_found_message "$icon"
   else
      icon=$(realpath -s "$icon")
   fi

   if [ -d "$folder" ]; then
      ___print_info "Customizing $folder..."
   #  gio set [-t string] $HOME/Documents/C metadata::custom-icon file://$HOME/Pictures/App_Logos/C.png
   #  gio set -t unset {directory} metadata::custom-icon
      gio set "$folder" metadata::custom-icon "file://$icon" | sed 's/^/  gio: /'
   else
      ___print_warning "Destination <1>$folder<0> not found."
   fi
}
