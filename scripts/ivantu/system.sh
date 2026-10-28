#!/bin/bash

# Functions --------------------------------------------------------------------
# function setup_keyboard_options ()
# function setup_power_settings ()
# function setup_startup_configuration_files ()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# function setup_keyboard_options ()
# Customizes some keyboard options.
# ------------------------------------------------------------------------------
function setup_keyboard_options ()
{
   print_title "$var_current_category" "Setup <1>keyboard<0> options"
   confirm 1 "Apply keyboard options to configuration"
   if [ $var_confirmed -gt 0 ]; then
      ___print_info "Applying config..."
      sudo sed -i 's/\(^XKBOPTIONS=\).*/\1\"numpad:microsoft\"/' /etc/default/keyboard
   else
      ___print_info $skipping_
   fi
   CR
}

# ------------------------------------------------------------------------------
# function setup_power_settings ()
# Configures power settings.
# ------------------------------------------------------------------------------
function setup_power_settings ()
{
   print_title "$var_current_category" "Setup <1>power<0> settings"
   confirm 1 "Apply changes to <1>power<0> settings"
   if [ $var_confirmed -gt 0 ]; then
      ___print_info "Setting up dim..."
      gsettings set org.gnome.settings-daemon.plugins.power idle-dim false | sed 's/^/  gs: /'
      gsettings set org.gnome.settings-daemon.plugins.power idle-brightness 100 | sed 's/^/  gs: /'
      ___print_info "Setting up inactive types and times..."
      gsettings set org.gnome.desktop.session idle-delay 0 | sed 's/^/  gs: /'
      gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing' | sed 's/^/  gs: /'
      gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 3600 | sed 's/^/  gs: /'
      gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'suspend' | sed 's/^/  gs: /'
      gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 3600 | sed 's/^/  gs: /'
   else
      ___print_info $skipping_
   fi
   CR
}

# ------------------------------------------------------------------------------
# function setup_startup_configuration_files ()
# Copies my .bashrc, .bash_aliases and .nanorc to its places.
# ------------------------------------------------------------------------------
function setup_startup_configuration_files ()
{
   print_title "$var_current_category" "Setup <1>startup<0> files"
   confirm 1 "Copy startup configuration files"
   if [ $var_confirmed -gt 0 ]; then
      ___print_info "Copying <1>~/.bashrc<0>..."
      copy_file 0 $_conf_dir/bashrc ~/.bashrc
      ___print_info "Copying <1>~/.bash_aliases<0>..."
      copy_file 0 $_conf_dir/bash_aliases ~/.bash_aliases
      ___print_info "Copying <1>~/.nanorc<0>..."
      copy_file 0 $_conf_dir/nanorc ~/.nanorc
      ___print_info "Copying <1>/root/.nanorc<0>..."
      copy_file 1 $_conf_dir/nanorc /root/.nanorc

      check_and_install_optional_package "fastfetch" "fastfetch"
   else
      ___print_info $skipping_
      CR
   fi
}
