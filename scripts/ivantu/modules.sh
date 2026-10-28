#!/bin/bash

# Functions --------------------------------------------------------------------
# function setup_module_bline ()
# function setup_module_gse_gdm_extension ()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
function setup_module_bline ()
{
   local module="bline"
   local module_dir="$_modules_dir/$module"
   print_title "$var_current_category" "<1>$module<0>"

   if [ -d "$module_dir" ]; then
      confirm 0 "Build and install module <1>$module<0>"
      if [ $var_confirmed -gt 0 ]; then

         check_and_install_optional_package "build-essential" "build-essential"
         if [ $var_installed -eq 0 ]; then
            ___print_info $skipping_
         else
            cd "$module_dir"
            cd src
            ___print_info "Building module <1>$module<0>..."
            make build
            if [[ $? -eq 0 ]]; then
               log 2 "Copying <1>bline<0> to <1>/usr/bin<0>..."
               copy_file 1 bline /usr/bin
            else
               ___print_error_bg "Error building module <1>$module<0>."
            fi
         fi

      else
         ___print_info $skipping_
      fi

   else
      ___print_error_bg "Module <1>$module<0> not found."
   fi
   cd "$_root_dir"
   CR
}

# ------------------------------------------------------------------------------
function setup_module_gse_gdm_extension ()
{
   local module="gse-gdm-extension"
   local module_dir="$_modules_dir/$module"
   local installed_module_dir="/usr/local/share/gnome-shell/extensions/gdm-extension@pratap.fastmail.fm"
   print_title "$var_current_category" "<1>$module<0>"

   if [ -d "$module_dir" ]; then

      if [ -d "$installed_module_dir" ]; then
         ___print_info "Module <1>$module<0> already installed. "$skipping_
      else

         confirm 0 "Install module <1>$module<0>"
         if [ $var_confirmed -gt 0 ]; then

            cd "$module_dir"
            sudo ./install.sh

         else
            ___print_info $skipping_
         fi

      fi

   else
      ___print_error_bg "Module <1>$module<0> not found."
   fi
   CR
}
