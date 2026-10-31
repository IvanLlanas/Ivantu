#!/bin/bash

# Functions --------------------------------------------------------------------
# function setup_grub_menu ()
# function setup_boot_logos ()
# function setup_login_screen_wallpaper ()
# function setup_desktop_appearance ()
# function setup_desktop_wallpaper ()
# function setup_user_icon ()
# function setup_gnome_extensions ()
# function setup_file_manager ()
# function install_gnome_shell_extension (ext_id, filename)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# function setup_grub_menu ()
# Customizes GRUB menu.
# ------------------------------------------------------------------------------
function setup_grub_menu ()
{
   print_title "$var_current_category" "Setup <1>GRUB 2<0> menu"
   select_available_filename 0 "$_grub_dir" "-grub.png"
   if [ ! -z "$var_selected_filename" ]; then

      local filename=/etc/default/grub
      local wp=$var_selected_filename
      local distrib=${THEME_DISTRIBS[$theme_index_current]}
      local buffer=
      backup_file 1 "$filename"

# GRUB_BACKGROUND="wp"
# GRUB_DISABLE_MEMTEST=true
# GRUB_DISTRIBUTOR="WoW - WotLK"
# GRUB_TIMEOUT_STYLE=menu
# GRUB_TIMEOUT=5
# GRUB_GFXMODE=640x480

# GRUB_DEFAULT=0
# GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
# GRUB_CMDLINE_LINUX=""
#   sed -i 's/XXXX\s\{0,\}=.*/XXXX='"$variable"/ $filename

      # GRUB_BACKGROUND="wp" ---------------------------
      buffer=$(grep GRUB_BACKGROUND < $filename)
      # if no entry for GRUB_BACKGROUND is found let's add a new one.
      if [ "$buffer" == "" ]; then
         sudo bash -c 'echo GRUB_BACKGROUND="'$wp'" >> '$filename
      fi
      # Replace / with \/
      wp=${wp//\//\\\/}
      sudo sed -i 's/#GRUB_BACKGROUND\s\{0,\}=.*/GRUB_BACKGROUND=\"'"$wp"'\"/' $filename
      sudo sed -i 's/GRUB_BACKGROUND\s\{0,\}=.*/GRUB_BACKGROUND=\"'"$wp"'\"/' $filename

      # GRUB_DISABLE_MEMTEST=true ----------------------
      buffer=$(grep GRUB_DISABLE_MEMTEST < $filename)
      # if no entry for GRUB_BACKGROUND is found let's add a new one.
      if [ "$buffer" == "" ]; then
         sudo bash -c 'echo GRUB_DISABLE_MEMTEST=true >> '$filename
      fi
      # else let's leave it as it is.

      # Replace / with \/
      distrib=${distrib//\//\\\/}
      # GRUB_DISTRIBUTOR="WoW - WotLK" -----------------
      if [ ! "$distrib" == "" ]; then
         sudo sed -i 's/GRUB_DISTRIBUTOR\s\{0,\}=.*/GRUB_DISTRIBUTOR=\"'"$distrib"'\"/' $filename
      fi

      # GRUB_TIMEOUT_STYLE=menu -----------------------
      # GRUB_TIMEOUT=5 --------------------------------
      sudo sed -i 's/GRUB_TIMEOUT_STYLE\s\{0,\}=.*/GRUB_TIMEOUT_STYLE=menu/' $filename
      sudo sed -i 's/GRUB_TIMEOUT\s\{0,\}=.*/GRUB_TIMEOUT=5/' $filename

      # GRUB_GFXMODE=640x480 --------------------------
      sudo sed -i 's/#GRUB_GFXMODE\s\{0,\}=.*/GRUB_GFXMODE=640x480/' $filename
      sudo sed -i 's/GRUB_GFXMODE\s\{0,\}=.*/GRUB_GFXMODE=640x480/' $filename

      # At this moment we're not updating /etc/grub.d/05_debian_theme to set colors.
      # You must do it manually:
      # sudo nano /etc/grub.d/05_debian_theme
# Colors: red, green, blue, cyan, magenta, brown, light-gray, black
# Foreground has additional colors available:
#         light-red, light-green, light-blue
#         light-cyan, light-magenta, yellow, white, dark-gray
      # ... WotLK
      # if [ -z "${2}" ] && [ -z "${3}" ]; then
      #  #echo "  true"
      #  echo "  set color_highlight=black/light-cyan"
      #  echo "  set color_normal=white/black"
      # fi
      # ...
      # ... Ivan
      # if [ -z "${2}" ] && [ -z "${3}" ]; then
      #  #echo "  true"
      #  echo "  set color_highlight=black/cyan"
      #  echo "  set color_normal=white/black"
      # fi
      # ...

      # Patch GRUB files to change some strings.
      confirm 0 "Patch GRUB script for text strings customization"
      if [ $var_confirmed -gt 0 ]; then
         ___print_info "Patching scripts..."
         # Backup files in /etc/grub.d
         local grub_dir="/etc/grub.d"
         local grub_dir_backup="$grub_dir/backup"
         if [ ! -d "$grub_dir_backup" ]; then
            sudo mkdir -p "$grub_dir_backup"
            copy_dir 1 "$grub_dir" "$grub_dir_backup"
         fi
         ___print_info "Patching \"Advanced options\" strings..."
         # sudo sed -i 's/\"Advanced options /\"   Advanced options /g' "$grub_dir"/*
         find "$grub_dir"/* -maxdepth 0 -type f -exec sudo sed -i 's/\"Advanced options /\"   Advanced options /g' {} ';'

         ___print_info "Patching distributor strings..."
         sudo sed -i 's/OS=\"\${GRUB_DISTRIBUTOR} GNU\/Linux\"/OS=\"${GRUB_DISTRIBUTOR}\"/g' "$grub_dir"/10_linux
      else
         ___print_info $skipping_
      fi
      sudo update-grub
   fi
   CR
}

# ------------------------------------------------------------------------------
# function setup_boot_logos ()
# Customizes boot logos.
# ------------------------------------------------------------------------------
function setup_boot_logos ()
{
   # ---------------------------------------------------------------------------
   # I updated my probook 450 g3 to kubuntu 20.04 but didnt get the oem logo.
   # Had to manually enable. In terminal:
   # $ sudo apt install plymouth-theme-spinner
   #   (This is the OEM Boot logo theme)
   # $ sudo update-alternatives --config default.plymouth
   #   (Let´s you pick a default theme if more than one is installed)
   # Select the "bgrt" theme.
   # $ sudo update-initramfs -u
   # Then reboot.
   # ---------------------------------------------------------------------------

   print_title "$var_current_category" "Setup <1>boot<0> logos"
   select_available_filename 0 "$_bootui_dir" "-ubuntu-logo.png"
   if [ ! -z "$var_selected_filename" ]; then
      local prefix=${THEME_PREFIXES[$theme_index_current]}
      backup_file 1 "/usr/share/plymouth/themes/spinner/bgrt-fallback.png"
      backup_file 1 "/usr/share/plymouth/themes/spinner/watermark.png"
      backup_file 1 "/usr/share/plymouth/ubuntu-logo.png"
      copy_file 1 $_bootui_dir/192/$prefix-bgrt-fallback.png     /usr/share/plymouth/themes/spinner/bgrt-fallback.png
      copy_file 1 $_bootui_dir/$prefix-watermark.png             /usr/share/plymouth/themes/spinner/watermark.png
      copy_file 1 $_bootui_dir/$prefix-ubuntu-logo.png           /usr/share/plymouth/ubuntu-logo.png

      # sudo nano /usr/share/plymouth/themes/bgrt/bgrt.plymouth
      # set value of UseFirmwareBackground to false under [boot-up], [reboot], and [shutdown] sections.
      local filename=/usr/share/plymouth/themes/bgrt/bgrt.plymouth
      backup_file 1 "$filename"
      sudo sed -i 's/UseFirmwareBackground\s\{0,\}=.*/UseFirmwareBackground=true/' "$filename"

      # All plymouth data and config needs to be embedded inside initramfs to be applied in iso boot,
      # so you need to apply:
      ___print_info "Updating initramfs..."
      sudo update-initramfs -u

      ___print_info "Installing gnome login and control-center images..."

      # Images used in the gnome-control-center about panel
      local dir="/usr/share/pixmaps"
      if test -f "$dir/ubuntu-logo-text.png"; then
         backup_file 1 "$dir/ubuntu-logo-text.png"
         copy_file 1 $_logos_dir/ubuntu-logo-text.png       $dir/ubuntu-logo-text.png
         backup_file 1 "$dir/ubuntu-logo-text-dark.png"
         copy_file 1 $_logos_dir/ubuntu-logo-text-dark.png  $dir/ubuntu-logo-text-dark.png
      fi
      if test -f "$dir/ubuntu-logo-text.svg"; then
         backup_file 1 "$dir/ubuntu-logo-text.svg"
         copy_file 1 $_logos_dir/ubuntu-logo-text.svg       $dir/ubuntu-logo-text.svg
         backup_file 1 "$dir/ubuntu-logo-text-dark.svg"
         copy_file 1 $_logos_dir/ubuntu-logo-text-dark.svg  $dir/ubuntu-logo-text-dark.svg
      fi

   fi
   CR
}

# ------------------------------------------------------------------------------
# function setup_login_screen_wallpaper ()
# Customizes the login screen wallpaper.
# ------------------------------------------------------------------------------
function setup_login_screen_wallpaper ()
{
   print_title "$var_current_category" "Setup <1>login screen<0> wallpaper"
   select_available_filename 0 "$_login_dir" "-login.jpg"
   if [ ! -z "$var_selected_filename" ]; then
      local script=ubuntu-gdm-set-background/src/post-23.sh
      sudo $script --image "$var_selected_filename"
   fi
   CR
}

# ------------------------------------------------------------------------------
# function setup_desktop_appearance ()
# Sets some GUI components and colors.
# ------------------------------------------------------------------------------
function setup_desktop_appearance ()
{
   print_title "$var_current_category" "Setup <1>desktop<0> appearance"
   confirm 1 "Apply themed colors and options to the desktop"
   if [ $var_confirmed -gt 0 ]; then
      ___print_info "Setting up dark mode and colors..."

      local gtk=${THEME_GTKTHEMES[$theme_index]}
      local icon=${THEME_ICONTHEMES[$theme_index]}
      _gui_set_themes "$gtk" "$icon"

      ___print_info "Setting up dock..."
      gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed true | sed 's/^/  gs: /'
      gsettings set org.gnome.shell.extensions.dash-to-dock dock-position LEFT | sed 's/^/  gs: /'
      gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false | sed 's/^/  gs: /'
      gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 48 | sed 's/^/  gs: /'

      ___print_info "Setting up dialogs..."
      gsettings set org.gnome.mutter attach-modal-dialogs false | sed 's/^/  gs: /'

      ___print_info "Setting up calendar..."
      gsettings set org.gnome.desktop.interface clock-show-weekday true | sed 's/^/  gs: /'

      gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode FIXED   | sed 's/^/  gs: /'
      gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity 0.75   | sed 's/^/  gs: /'
      # gsettings set org.gnome.shell.extensions.dash-to-dock unity-backlit-items true  | sed 's/^/  gs: /'

      ___print_info "Showing trash icon on desktop..."
      gsettings set org.gnome.shell.extensions.ding show-trash true | sed 's/^/  gs: /'

      ___print_info "Hiding trash icon from dock..."
      gsettings set org.gnome.shell.extensions.dash-to-dock show-trash false | sed 's/^/  gs: /'

      ___print_info "Hiding personal folder icon..."
      gsettings set org.gnome.shell.extensions.ding show-home false | sed 's/^/  gs: /'

      ___print_info "Setting mouse pointer size..."
      gsettings set org.gnome.desktop.interface cursor-size 48 | sed 's/^/  gs: /'

      ___print_info "Setting workspaces number..."
      gsettings set org.gnome.desktop.wm.preferences num-workspaces 1 | sed 's/^/  gs: /'
      gsettings set org.gnome.mutter dynamic-workspaces false | sed 's/^/  gs: /'
      #dconf write /org/gnome/desktop/wm/preferences/num-workspaces 1
   else
      ___print_info $skipping_
   fi
   CR
}

# ------------------------------------------------------------------------------
# function _gui_set_themes (gtk_theme, icon_theme)
# Sets the theme settings.
# Internal use (setup_desktop_appearance()).
# ------------------------------------------------------------------------------
function _gui_set_themes ()
{
   local gtk=$1
   local icon=$2

   gsettings set org.gnome.shell.ubuntu            color-scheme 'prefer-dark' | sed 's/^/  gs: /'
   gsettings set org.gnome.desktop.interface       color-scheme 'prefer-dark' | sed 's/^/  gs: /'

   gsettings set org.gnome.desktop.interface       gtk-theme    "$gtk"        | sed 's/^/  gs: /'
   gsettings set org.gnome.desktop.interface       icon-theme   "$icon"       | sed 's/^/  gs: /'
   gsettings set org.gnome.desktop.interface       cursor-theme 'Adwaita'     | sed 's/^/  gs: /'
   gsettings set org.gnome.desktop.wm.preferences  theme        'Adwaita'     | sed 's/^/  gs: /'
}
      # ------------------------------------------------------------------------------
      function _gui_get_themes ()
      {
      #  prefer-dark
      #  prefer-dark
      #  Yaru-dark       Yaru-blue-dark      Yaru-red-dark
      #  Yaru            Yaru-blue           Yaru-red
      #  Adwaita
      #  Adwaita
         gsettings get org.gnome.shell.ubuntu            color-scheme
         gsettings get org.gnome.desktop.interface       color-scheme
         gsettings get org.gnome.desktop.interface       gtk-theme
         gsettings get org.gnome.desktop.interface       icon-theme
         gsettings get org.gnome.desktop.interface       cursor-theme
         gsettings get org.gnome.desktop.wm.preferences  theme
      }

# ------------------------------------------------------------------------------
# function setup_desktop_wallpaper ()
# Sets the desktop wallpaper.
# ------------------------------------------------------------------------------
function setup_desktop_wallpaper ()
{
   print_title "$var_current_category" "Setup desktop <1>wallpaper<0>"
   select_available_filename 0 "$_wallpapers_dir" "-wallpaper.jpg"
   if [ ! -z "$var_selected_filename" ]; then
      ___print_info "Applying wallpaper..."
      gsettings set org.gnome.desktop.background picture-uri-dark "file:///$var_selected_filename" | sed 's/^/  gs: /'
   fi
   CR
}

# ------------------------------------------------------------------------------
# function setup_user_icon ()
# Sets the GUI user icon.
# ------------------------------------------------------------------------------
function setup_user_icon ()
{
   print_title "$var_current_category" "Setup <1>user icon<0>"
   select_available_filename 0 "$_avatars_dir" "-avatar-1.png"
   if [ ! -z "$var_selected_filename" ]; then
      ___print_info "Applying user icon..."
      busctl call org.freedesktop.Accounts /org/freedesktop/Accounts/User$UID org.freedesktop.Accounts.User SetIconFile s "$var_selected_filename" | sed 's/^/  busctl: /'
   fi
   CR
}

# ------------------------------------------------------------------------------
# function install_gnome_shell_extension (ext_id, filename, gnomekey)
# Installs a gnome shell extension.
# id - Extension id. In $HOME/.local/share/gnome-shell/extensions/ a folder with this id is created to host the estension files.
# fileid - Directory where the extension is found in Ivantu install directory.
# gnomekey - dconf key where the extension settings will be written.

# Updates var_installed the same way check_and_install_optional_package does.
# ------------------------------------------------------------------------------
function install_gnome_shell_extension ()
{
# export: dconf dump /org/gnome/shell/extensions/dash-to-panel/ > dash-to-panel-settings.dconf
   local id="$1"
   local fileid="$2"
   local gnomekey="$3"
   local forceconfig="$4"
   local ext_dir="$_extensions_dir/$fileid"
   local filename="$ext_dir/$fileid"
   local dir="$HOME/.local/share/gnome-shell/extensions/$id"

   var_installed=0
   if [ ! -d "$dir" ]; then
      confirm 1 "Install extension <1>$fileid<0>"
      if [ $var_confirmed -gt 0 ]; then

         # ----------------------------------------------------------
         local fonts_dir="$ext_dir/fonts"
         if [ -d "$fonts_dir" ]; then
            ___print_info "Installing fonts..."
            local local_fonts_dir="$HOME/.local/share/fonts"
            mkdir -p "$local_fonts_dir"
            copy_dir 0 "$fonts_dir" "$local_fonts_dir"
         else
            log 2 "No required fonts for \"$fileid\"."
         fi
         # ----------------------------------------------------------

         gnome-extensions install "$filename.zip"
         var_installed=2
         var_logout=1
         if [ $gnomekey ] && [ $gnomekey != "" ]; then
            local filename2="$filename-settings.dconf"
            if [ $forceconfig != "" ]; then
               filename2="$ext_dir/$forceconfig"
            else
               filename2="$filename-settings.dconf"
            fi
            log 2 "Importing settings for \"$fileid\" from $filename2..."
            dconf load "$gnomekey" < "$filename2"
         else
            log 2 "No settings avalilable for \"$fileid\"."
         fi

         if [ $_activate_extensions -gt 0 ]; then
            log 2 "Activating \"$fileid\"..."
            busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s ${id}
         fi
      else
            gnome-extensions enable "$id"
         ___print_info $skipping_
      fi
      CR
   else
      log 2 "Extension \"<1>$id<0>\" already installed."
      var_installed=1
   fi
}

# ------------------------------------------------------------------------------
# function setup_gnome_extensions ()
# Installs my gnome shell extensions.
# ------------------------------------------------------------------------------
function setup_gnome_extensions ()
{
   print_title "$var_current_category" "Setup Gnome Shell <1>Extensions<0>"

# gnome-shell-extension-manager
# gnome-extensions install xxxx.zip
# export: dconf dump /org/gnome/shell/extensions/xxx/ > xxx-settings.dconf
# import: dconf load /org/gnome/shell/extensions/xxx/ < xxx-settings.dconf

   #dconf write "/org/gnome/shell/extensions/dash-to-panel/show-apps-icon-file" "xxx"
   #gsettings set "org.gnome.shell.extensions.dash-to-panel" show-apps-icon-file "$filename"
   #gsettings set "$gnomekey" panel-positions '{"SNY-0x01010101":"LEFT","GSM-0x00073f91":"LEFT","GSM-0x00072570":"LEFT","unknown-unknown":"LEFT"}'

   check_and_install_optional_package "gnome-shell-extension-manager" "gnome-shell-extension-manager"
   if [ $var_installed -gt 0 ]; then
      local installed_new=0

# start-overlay-in-application-view@Hex_cz
# https://extensions.gnome.org/extension/5040/start-overlay-in-application-view/
# https://github.com/Hexcz/Start-Overlay-in-Application-View-for-Gnome-40-
# export: -
      install_gnome_shell_extension 'start-overlay-in-application-view@Hex_cz' 'start-overlay-in-application-view'
      if [ $var_installed -eq 1 ]; then
         log 0 "<1>start-overlay-in-application-view<0> already installed."
      fi
      if [ $var_installed -ge 2 ]; then
         installed_new=1
      fi

# dash-to-panel@jderose9.github.com
# https://extensions.gnome.org/extension/1160/dash-to-panel/
# https://github.com/home-sweet-gnome/dash-to-panel
# export: dconf dump /org/gnome/shell/extensions/dash-to-panel/ > dash-to-panel-settings.dconf
      install_gnome_shell_extension 'dash-to-panel@jderose9.github.com' 'dash-to-panel' '/org/gnome/shell/extensions/dash-to-panel/'
      if [ $var_installed -eq 1 ]; then
         log 0 "<1>dash-to-panel<0> already installed."
      fi
      if [ $var_installed -ge 2 ]; then
         installed_new=1
         ___print_info "Setting weekday and date for <1>dash-to-panel<0>..."
         gsettings set org.gnome.desktop.interface clock-show-weekday true | sed 's/^/  gs: /'
         gsettings set org.gnome.desktop.interface clock-show-date false | sed 's/^/  gs: /'
         CR
      fi

# azclock@azclock.gitlab.com
# https://extensions.gnome.org/extension/5156/desktop-clock/
# https://gitlab.com/AndrewZaech/azclock
# export: dconf dump /org/gnome/shell/extensions/azclock/ > azclock-settings.dconf
      local configfile=
      if [ "$HOSTNAME" = "inas" ]; then
         log 2 "Using monitor configuration INAS."
         configfile="azclock-settings-inas.dconf"
      elif [ $var_monitor_count -le 2 ]; then
         if [ $var_monitor_scaling_pct -gt 120 ]; then
            log 2 "Using monitor configuration 1x125."
            configfile="azclock-settings-1920-125.dconf"
         else
            log 2 "Using monitor configuration 1x00."
            configfile="azclock-settings-1920-100.dconf"
         fi
      else
         log 2 "Using monitor configuration 3x00."
      fi
      install_gnome_shell_extension 'azclock@azclock.gitlab.com' 'azclock' '/org/gnome/shell/extensions/azclock/' "$configfile"
      if [ $var_installed -eq 1 ]; then
         log 0 "<1>azclock<0> already installed."
      fi
      if [ $var_installed -ge 2 ]; then
         installed_new=1
      fi

# clipboard-indicator@tudmotu.com
# https://extensions.gnome.org/extension/779/clipboard-indicator/
# https://github.com/Tudmotu/gnome-shell-extension-clipboard-indicator
# export: dconf dump /org/gnome/shell/extensions/clipboard-indicator/ > clipboard-indicator-settings.dconf
      install_gnome_shell_extension 'clipboard-indicator@tudmotu.com' 'clipboard-indicator' '/org/gnome/shell/extensions/clipboard-indicator/'
      if [ $var_installed -eq 1 ]; then
         log 0 "<1>clipboard-indicator<0> already installed."
      fi
      if [ $var_installed -ge 2 ]; then
         installed_new=1
      fi

# blur-my-shell@aunetx
# https://extensions.gnome.org/extension/3193/blur-my-shell/
# https://github.com/aunetx/blur-my-shell
# export: dconf dump /org/gnome/shell/extensions/blur-my-shell/ > blur-my-shell-settings.dconf
      install_gnome_shell_extension 'blur-my-shell@aunetx' 'blur-my-shell' '/org/gnome/shell/extensions/blur-my-shell/'
      if [ $var_installed -eq 1 ]; then
         log 0 "<1>blur-my-shell<0> already installed."
      fi
      if [ $var_installed -ge 2 ]; then
         installed_new=1
      fi

# tilingshell@ferrarodomenico.com
# https://extensions.gnome.org/extension/7065/tiling-shell/
# https://github.com/domferr/tilingshell
# export: dconf dump /org/gnome/shell/extensions/tilingshell/ > tiling-shell.dconf
      install_gnome_shell_extension 'tilingshell@ferrarodomenico.com' 'tiling-shell' '/org/gnome/shell/extensions/tilingshell/'
      if [ $var_installed -eq 1 ]; then
         log 0 "<1>tiling-shell<0> already installed."
      fi
      if [ $var_installed -ge 2 ]; then
         installed_new=1
      fi

# wiggly@mojarch
# https://extensions.gnome.org/extension/8969/wiggly/
# https://github.com/Arch-Lover/wiggly
# export: dconf dump /org/gnome/shell/extensions/wiggly/ > wiggly-settings.dconf
      install_gnome_shell_extension 'wiggly@mojarch' 'wiggly' '/org/gnome/shell/extensions/wiggly/'
      if [ $var_installed -eq 1 ]; then
         log 0 "<1>wiggly<0> already installed."
      fi
      if [ $var_installed -ge 2 ]; then
         installed_new=1
      fi

# ------------------------------------------

      if [ $installed_new -ge 1 ]; then
         if [ $_activate_extensions -gt 0 ]; then
            ___print_warning_bg "WARNING: Make sure the newly installed extensions have been properly activated and configured from the <1>Extension Manager<0>."
         else
            ___print_warning_bg "WARNING: to activate newly installed extensions you must log out and manually activate them from the <1>Extension Manager<0>."
         fi
         CR
      fi

   fi
   CR
}

# ------------------------------------------------------------------------------
# function setup_file_manager ()
# Changes some options in Files.
# ------------------------------------------------------------------------------
function setup_file_manager ()
{
   print_title "$var_current_category" "Setup <1>Files<0>"

   confirm 1 "Change <1>Files settings<0>"
   if [ $var_confirmed -gt 0 ]; then

      ___print_info "Setting Icons size..."
      # gsettings set org.gnome.nautilus.icon-view default-zoom-level 'medium' | sed 's/^/  gs: /'
      gsettings set org.gnome.nautilus.icon-view default-zoom-level 'large' | sed 's/^/  gs: /'

      ___print_info "Adding Size row..."
      gsettings set org.gnome.nautilus.icon-view captions "['size']" | sed 's/^/  gs: /'
      # gsettings set org.gnome.nautilus.icon-view captions "['size', 'date_modified']"
      # More alternative text attributes include 'type', 'owner', 'group', 'permissions', and 'mime_type'.

      ___print_info "Disabling Recent files..."
      gsettings set org.gnome.desktop.privacy remember-recent-files false | sed 's/^/  gs: /'

      local filename="$HOME/.config/gtk-3.0/settings.ini"
      if [ ! -f "$filename" ]; then
         ___print_info "Hiding Recent files entry..."
         echo "[Settings]" > "$filename"
         echo "gtk-recent-files-max-age=0" >> "$filename"
         echo "gtk-recent-files-enabled=FALSE" >> "$filename"
      fi

      # nautilus -q
   fi
   CR
}
