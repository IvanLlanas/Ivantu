#!/bin/bash

# Functions --------------------------------------------------------------------
# function setup_terminal_profiles ()
# function setup_eza ()
# function setup_ptyxis ()
# ---
# function setup_conky ()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# function setup_eza ()
# Installs eza and/or a theme file.
# ------------------------------------------------------------------------------
function setup_eza ()
{
   print_title "$var_current_category" "Install <1>eza<0> theme"
   check_and_install_optional_package "eza" "eza"
   if [ $var_installed -gt 0 ]; then
      if [ $var_installed -gt 1 ]; then
         var_confirmed=1
      else
         confirm 1 "Install customized <1>eza<0> theme"
      fi

      if [ $var_confirmed -gt 0 ]; then
         local dir="$HOME/.config/eza"
         ___print_info "Copying <1>$package theme<0>..."
         mkdir -p $dir
         copy_file 0 $_conf_dir/eza/theme.yml $dir
      else
         ___print_info $skipping_
      fi
   fi

   if [ $var_installed -gt 0 ]; then
      local dir="$HOME/.local/share/fonts"

      if [ ! -f "$dir/AdwaitaMonoNerdFont-Regular.ttf" ]; then

         if [ $var_installed -gt 1 ]; then
            var_confirmed=1
         else
            confirm 1 "Install <1>icon fonts<0>"
         fi

         if [ $var_confirmed -gt 0 ]; then
            ___print_info "Installing <1>Nerd fonts<0>..."
            7z x "$_conf_dir/eza/nerd-fonts.7z" -y "-o$dir" | sed 's/^/  7z: /'
         else
            ___print_info $skipping_
         fi
      fi
   fi
   CR
}

# ------------------------------------------------------------------------------
# function setup_ptyxis ()
# Installs ptyxis and/or a theme file.
# ------------------------------------------------------------------------------
function setup_ptyxis ()
{
   print_title "$var_current_category" "Install <1>Ptyxis<0> theme"

   check_and_install_optional_package "ptyxis" "Ptyxis" 0
   if [ $var_installed -gt 0 ]; then
      if [ $var_installed -gt 1 ]; then
         var_confirmed=1
      else
         confirm 1 "Install customized <1>Ptyxis<0> theme"
      fi

      if [ $var_confirmed -gt 0 ]; then
         local dir="$HOME/.local/share/org.gnome.Ptyxis/palettes"
         ___print_info "Copying <1>Ptyxis theme<0>..."
         mkdir -p $dir
         copy_file 0 $_conf_dir/ptyxis/ptyxis-ivan.palette $dir

         #dconf dump /org/gnome/Ptyxis/ > ptyxis-settings.dconf
         local filename="$_conf_dir/ptyxis/ptyxis-settings.dconf"
         dconf load /org/gnome/Ptyxis/ < $filename | sed 's/^/  dconf: /'
         #dconf write /org/gnome/Ptyxis/Profiles/eaac8e4e95a45ba0ede574da695104cf/opacity 0.85
      else
         ___print_info $skipping_
      fi
   fi
   CR
}

# ------------------------------------------------------------------------------
# function setup_terminal_profiles ()
# Imports saved terminal profiles and sets the current theme profile as default.
# ------------------------------------------------------------------------------
function setup_terminal_profiles ()
{
   print_title "$var_current_category" "Setup <1>Gnome terminal<0> profiles"
   confirm 1 "Import themed terminal profiles"
   if [ $var_confirmed -gt 0 ]; then
      local filename="$_conf_dir/gnome-terminal-profiles.dconf"
      if [ ! -f "$filename" ]; then
         not_found_message "$filename"
      else
         ___print_info "Importing profiles ($theme_color$theme_name<0>)..."
         local profile=${THEME_PROFILES[$theme_index]}
         # dconf dump /org/gnome/terminal/legacy/profiles:/ > gnome-terminal-profiles.dconf
         if [ "$profile" == "" ]; then
            local i=0
            ___print_warning "No themed profile for $theme_color$theme_name<0>. Assigning ${THEME_COLORS[$i]}${THEME_NAMES[$i]}<0>'s..."
            profile=${THEME_PROFILES[$i]}
         fi
         # sed -i 's/default\s\{0,\}=.*/default='\'$profile\'/ $filename
         dconf load  /org/gnome/terminal/legacy/profiles:/ < $filename | sed 's/^/  dconf: /'
         dconf write /org/gnome/terminal/legacy/profiles:/default "\"$profile\"" | sed 's/^/  dconf: /'
      fi
   else
      ___print_info $skipping_
   fi
   CR
}

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# --- DISABLED -----------------------------------------------------------------
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# function setup_conky ()
# ------------------------------------------------------------------------------
function setup_conky ()
{
   print_title "$var_current_category" "Setup <1>Conky<0> widget"

   check_and_install_optional_package "conky-all" "Conky" 0
   if [ $var_installed -gt 0 ]; then

      local text="Install a single [<1>1<0>] monitor Conky widget or a [<1>3<0>] monitors Conky widget [<1>1<0>/<1>3<0>]?"
      if [ $var_cfg_always_yes -gt 0 ]; then
         __print_info "$text <1>1<0>"
         var_answer=1
      else
         read_answer "$text"
      fi

      if [[ $var_answer =~ $_numbers ]] && [ ! -z $var_answer ]; then
         case $var_answer in
            1)
               select_available_filename 1 "$_conky_dir" ""
               if [ ! -z "$var_selected_filename" ]; then
                  _create_conky_autorun "$var_selected_filename"
               fi
               ;;

            3) var_selected_filename=$(realpath -s "$_conky_dir/3-monitors")
               _create_conky_autorun "$var_selected_filename"
               ;;

            *) ___print_error "Invalid option \"<1>$var_answer<0>\". "$skipping_
               CR
               return
               ;;
         esac

         confirm 1 "Launch the <1>Conky widget<0> now"
         if [ $var_confirmed -gt 0 ]; then
            ___print_info "Launching the <1>Conky widget<0>..."
            bash "$var_selected_filename/start.sh" | sed 's/^/  bash: /'
         fi

      else
         ___print_error "Invalid option \"<1>$var_answer<0>\". "$skipping_
      fi
   fi
   CR
}

# ------------------------------------------------------------------------------
# function _create_conky_autorun (conky_script_dir)
# ------------------------------------------------------------------------------
function _create_conky_autorun
{
   local conky_script_dir="$1"
   local autostart_dir="$HOME/.config/autostart"
   local filename="$autostart_dir/ivantu-conky.desktop"

   mkdir -p "$autostart_dir" | sed 's/^/  mkd: /'
   echo "[Desktop Entry]" > "$filename"
   echo "Type=Application" >> "$filename"
   echo "Exec=/usr/bin/bash $conky_script_dir/start.sh" >> "$filename"
   echo "Hidden=false" >> "$filename"
   echo "NoDisplay=false" >> "$filename"
   echo "X-GNOME-Autostart-enabled=true" >> "$filename"
   echo "Name=Ivantu Conky" >> "$filename"
   echo "Comment=Launch Conky (Ivantu)" >> "$filename"

   local widget_fonts_dir="$conky_script_dir/fonts"
   if [ -d "$widget_fonts_dir" ]; then
      ___print_info "Installing fonts..."
      local local_fonts_dir="$HOME/.local/share/fonts"
      mkdir -p "$local_fonts_dir"
      copy_dir 0 "$widget_fonts_dir" "$local_fonts_dir"
   fi
}

