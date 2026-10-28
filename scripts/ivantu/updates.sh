#!/bin/bash

DESKTOP_DIRS=( "/usr/share/applications" "/var/lib/flatpak/exports/share/applications" "/var/lib/snapd/desktop/applications" )
DESKTOP_DIRS_COUNT=${#DESKTOP_DIRS[@]}

# Functions --------------------------------------------------------------------
# function create_desktop_files ()
# function update_desktop_files ()
# ------------------------------------------------------------------------------

function update_desktop_file_icon_if_exists ()
{
   local filename="$1"
   local icon="$2"
   local i=
   local dir=
   local file=
   local found=0

   icon="$_icons_dir/$icon"

   for (( i=0 ; i<$DESKTOP_DIRS_COUNT ; i++ ));
   do
      let "id=i+1"
      local file=${DESKTOP_DIRS[$i]}"/$filename"
      log 2 "Checking <1>$file<0>..."
      if [ -f "$file" ]; then
         found=1
         ___print_info "Updating <1>$file<0>..."
         local icon2=${icon//\//\\\/}
         sudo sed -i 's/Icon\s\{0,\}=.*/Icon='$icon2/ $file
      fi
   done

   if [ $found -eq 0 ]; then
      ___print_info "File <1>$filename<0> not found. "$skipping_
   fi
}

# ------------------------------------------------------------------------------
# function update_desktop_files ()
# Changes/restores the Invantu's icons to some *.desktop files.
# ------------------------------------------------------------------------------
function update_desktop_files ()
{
   print_title "$var_current_category" "Update <1>desktop<0> files"
   confirm 1 "Update existing desktop files icons"
   if [ $var_confirmed -gt 0 ]; then

      # --- Firefox ---
      # /var/lib/snapd/desktop/applications/firefox_firefox.desktop
      # Icon=/snap/firefox/current/default256.png # This cannot be mapped. File must be patched :/
      update_desktop_file_icon_if_exists "firefox_firefox.desktop"          "ivantu/apps/firefox-1.png"
      # /var/lib/flatpak/exports/share/applications/org.mozilla.firefox.desktop
      # Icon=org.mozilla.firefox # Mapped in Ivantu icon set
      # update_desktop_file_icon_if_exists "org.mozilla.firefox.desktop"      "ivantu/apps/firefox-2.png"

      # --- Cine ---
      # /var/lib/flatpak/exports/share/applications/io.github.diegopvlk.Cine.desktop
      # Icon=io.github.diegopvlk.Cine # Mapped in Ivantu icon set
      # update_desktop_file_icon_if_exists "io.github.diegopvlk.Cine.desktop" "ivantu/apps/media-player-1.png"

      # --- VMware Workstation ---
      # /usr/share/applications/vmware-workstation.desktop
      # Icon=vmware-workstation # Mapped in Ivantu icon set
      # update_desktop_file_icon_if_exists "vmware-workstation.desktop"       "ivantu/apps/vmware-1.png"

      # --- Kate ---
      # /usr/share/applications/
      # Icon=kate # Mapped in Ivantu icon set
      # /var/lib/flatpak/exports/share/applications/org.kde.kate.desktop
      # Icon=org.kde.kate # Mapped in Ivantu icon set
      # update_desktop_file_icon_if_exists "org.kde.kate.desktop"             "ivantu/apps/text-editor-1.png"

      # --- Audacious ---
      # /usr/share/applications/audacious.desktop
      # Icon=audacious # Mapped in Ivantu icon set
      # update_desktop_file_icon_if_exists "audacious.desktop"                "ivantu/apps/audacious-2.png"
      # /var/lib/flatpak/exports/share/applications/org.atheme.audacious.desktop
      # Icon=org.atheme.audacious # Mapped in Ivantu icon set
      # update_desktop_file_icon_if_exists "org.atheme.audacious.desktop"     "ivantu/apps/audacious-2.png"

   else
      ___print_info $skipping_
   fi
   CR
}


function create_desktop_file
{
   local filename="$1"
   local name="$2"
   local command="$3"
   local comment="$4"
   local icon="$5"
   echo "[Desktop Entry]" > $filename
   echo "Type=Application" >> $filename

   echo Name="$name" >> $filename
   echo GenericName="$name" >> $filename
   echo Comment="$comment" >> $filename
   echo Exec="$command" >> $filename
   echo "Terminal=false" >> $filename
   echo Icon="$icon" >> $filename
   echo "StartupNotify=true" >> $filename

   gio set "$filename" metadata::trusted true | sed 's/^/  gio: /'
   chmod a+x "$filename" | sed 's/^/  chm: /'
}

# ------------------------------------------------------------------------------
# function create_desktop_files ()
# Creates some *.desktop files.
# ------------------------------------------------------------------------------
function create_desktop_files ()
{
   print_title "$var_current_category" "Create <1>desktop<0> files"
   confirm 1 "Create new <1>desktop<0> files"
   if [ $var_confirmed -gt 0 ]; then

      local desktop_dir=$(xdg-user-dir DESKTOP)
      local filename=

      filename="$desktop_dir/$HOSTNAME.desktop"
      if [ -f $filename ]; then
         ___print_info "File <1>$filename<0> already exists. "$skipping_
      else
         ___print_info "Creating <1>$filename<0>..."
         create_desktop_file "$filename" "$HOSTNAME" "xdg-open /" "This computer" "$_icons_dir/cosmos-1.png"
      fi

   else
      ___print_info $skipping_
   fi
   CR
}
