#!/bin/bash
# ------------------------------------------------------------------------------
#    _____                _
#   |_   _|              | |
#     | |_   ____ _ _ __ | |_ _   _
#     | \ \ / / _` | '_ \| __| | | |
#    _| |\ V / (_| | | | | |_| |_| |
#   |_____\_/ \__,_|_| |_|\__|\__,_| 1.0
#
# ------------------------------------------------------------------------------
# Ivantu
# ------------------------------------------------------------------------------
# This script configures some of MY preferences and configurations for an
# Ubuntu system with a GNOME 49+ desktop.
# Do not run this unless you are me or you are sure you want these changes.
# ------------------------------------------------------------------------------
# Ivanto ASCII text:
# http://www.patorjk.com/software/taag/#p=display&f=Big&t=Ivantu&x=none&v=4&h=4&w=80&we=false
# ------------------------------------------------------------------------------
# Use shared folders between VMWare guest and host
# Add: projects -> /home/ivan/Projects
#.host:/projects   /home/ivan/Projects   fuse.vmhgfs-fuse   defaults,allow_other,uid=1000   0   0
# ------------------------------------------------------------------------------
# variable='value'
# sudo sed -i 's/variable\s\{0,\}=.*/variable='\'$value\'/ $file
# ------------------------------------------------------------------------------
# modules
# Patch *.desktop icons
# Add *.desktop files
# xdg-user-dir DESKTOP
#           DESKTOP
#           DOWNLOAD
#           TEMPLATES
#           PUBLICSHARE
#           DOCUMENTS
#           MUSIC
#           PICTURES
#           VIDEOS
# ------------------------------------------------------------------------------
# Complete: ./start.sh -a -t=1 -y
# ------------------------------------------------------------------------------

: << a
multiline comment
a

# Load modules -----------------------------------------------------------------
# Move to the script location.
_root_dir=$(realpath -s "$(dirname "$0")")
cd "$_root_dir"

if [[ -z "${IVANTU_SCRIPTS_DIR}" ]]; then
   IVANTU_SCRIPTS_DIR="$(pwd)"
fi

source "$IVANTU_SCRIPTS_DIR/conio.sh"
source "$IVANTU_SCRIPTS_DIR/ivantu/functions.sh"
source "$IVANTU_SCRIPTS_DIR/ivantu/system.sh"
source "$IVANTU_SCRIPTS_DIR/ivantu/gui.sh"
source "$IVANTU_SCRIPTS_DIR/ivantu/applications.sh"
source "$IVANTU_SCRIPTS_DIR/ivantu/modules.sh"
source "$IVANTU_SCRIPTS_DIR/ivantu/icons.sh"
source "$IVANTU_SCRIPTS_DIR/ivantu/updates.sh"

# Constants --------------------------------------------------------------------

cons_lit_product_name="Ivantu"
cons_lit_product_version="1.0"
cons_lit_product_date="2026-10-28"

# Preserve spaces in string to keep indentations.
IFS='%'

BACKUP_EXTENSION=old

# Try to activate gnome shell extensions via busctl?
_activate_extensions=1

_numbers='^[0-9]+$'

_title_bg=$_ansi_bg_white
_title_c1=$_ansi_black
_title_c2=$_ansi_red
_title_c3=$_ansi_blue
_title_c4=$_ansi_green

# Letter colors for Option, Default-option and Skip.
_o_option=$_em2
_o_default=$_em1
_o_skip=$_ansi_lred

# Media dirs - Dirs must not end with a /.
_ivantu_dir=$(realpath -s "..")
_media_dir="$_ivantu_dir/media"
_conf_dir="$_ivantu_dir/conf"
_modules_dir="$_ivantu_dir/modules"
_extensions_dir="$_ivantu_dir/extensions"

_conky_dir="$_conf_dir/conky"
_grub_dir="$_media_dir/grub"
_bootui_dir="$_media_dir/boot-ui"
_logos_dir="$_media_dir/logos"
_login_dir="$_media_dir/login"
_wallpapers_dir="$_media_dir/wallpapers"
_avatars_dir="$_media_dir/avatars"
_buttons_dir="$_media_dir/buttons"
_icons_dir="$_media_dir/icons"
_ivantu_icons_dir="$_icons_dir/ivantu"

# Internal themes
THEME_PREFIX_IVAN=ivan
THEME_NAME_IVAN="Ivan"
THEME_PREFIX_INAS=inas
THEME_NAME_INAS="INAS"
THEME_PREFIX_VADER=vader
THEME_NAME_VADER="Darth Vader"
THEME_PREFIX_VANILLA=vanilla
THEME_NAME_VANILLA="Vanilla"
THEME_PREFIX_WOTLK=wotlk
THEME_NAME_WOTLK="Wrath of the Lich King"
THEME_PREFIX_CATACLYSM=cataclysm
THEME_NAME_CATACLYSM="Cataclysm"
THEME_PREFIX_CORVO="corvo"
THEME_NAME_CORVO="Corvo Attano"
THEME_PREFIX_ESTATUT="estatut"
THEME_NAME_ESTATUT="L'Estatut"

# Terminal profiles ID.
# These ID's are defined in file data/gnome-terminal-profiles.dconf
# export:$ dconf dump /org/gnome/terminal/legacy/profiles:/ > gnome-terminal-profiles.dconf
THEME_PROFILE_IVAN=b1dcc9dd-5262-4d8d-a863-c897e6d979b9
THEME_PROFILE_INAS=b1dcc9dd-5262-4d8d-a863-c897e6d979b9
THEME_PROFILE_CORVO=aa58db3f-33f6-4648-b758-53e908c81ded
THEME_PROFILE_VANILLA=9956a6c5-0a18-47f7-8777-ff097f8254c3
THEME_PROFILE_WOTLK=c88a9988-91de-4767-b381-89adef5b6180
THEME_PROFILE_CATACLYSM=7bb44f24-9657-4f0a-8f68-06995133b4eb
THEME_PROFILE_ESTATUT=7bb44f24-9657-4f0a-8f68-06995133b4eb

THEME_NAMES=(     "$THEME_NAME_IVAN"       "$THEME_NAME_INAS"       "$THEME_NAME_VADER"      "$THEME_NAME_CORVO"       "$THEME_NAME_VANILLA"      "$THEME_NAME_WOTLK"       "$THEME_NAME_CATACLYSM"   "$THEME_NAME_ESTATUT")
THEME_PREFIXES=(   $THEME_PREFIX_IVAN       $THEME_PREFIX_INAS       $THEME_PREFIX_VADER      $THEME_PREFIX_CORVO       $THEME_PREFIX_VANILLA      $THEME_PREFIX_WOTLK       $THEME_PREFIX_CATACLYSM   $THEME_PREFIX_ESTATUT)
THEME_COLORS=(    "$_ansi_lblue"           "$_ansi_lgreen"          "$_ansi_lblack"          "$_ansi_white"            "$_ansi_lyellow"           "$_ansi_lcyan"            "$_ansi_lred"              "$_ansi_yellow")
THEME_DISTRIBS=(  "Ivantu"                 "INAS"                   "Death Star"             "Dunwall Tower"           "World of Warcraft Server" "WoW - Wrath of the Lich King Server"   "WoW - Cataclysm Server"  "L'Estatut")
THEME_PROFILES=(  "$THEME_PROFILE_IVAN"    "$THEME_PROFILE_INAS"    "$THEME_PROFILE_VADER"   "$THEME_PROFILE_CORVO"    "$THEME_PROFILE_VANILLA"   "$THEME_PROFILE_WOTLK"    "$THEME_PROFILE_CATACLYSM" "$THEME_PROFILE_ESTATUT")
THEME_GTKTHEMES=( "Yaru-blue-dark"         "Yaru-blue-dark"         "Yaru-red-dark"          "Yaru-blue-dark"           "Yaru-dark"                "Yaru-blue-dark"          "Yaru-red-dark"           "Yaru-yellow-dark")
THEME_ICONTHEMES=("Yaru-blue"              "Yaru-blue"              "Yaru-red"               "Yaru-blue"                "Yaru"                     "Yaru-blue"               "Yaru-red"                "Yaru-yellow-dark")
S_ICON_NAMES=(    "Ivan Server"            "INAS Server"            "Dark Server"            "Corvo Server"             "WoW Server"               "WotLK Server"            "Cataclysm Server"        "L'Estatut Server")
S_ICON_COMMENTS=( "Ivan Server Management" "INAS Server Management" "INAS Server Management" "Corvo Server Management" "WoW Server Management"    "WotLK Server Management" "Cataclysm Server Management" "L'Estatut Server Management")

THEME_COUNT=${#THEME_NAMES[@]}

skipping_="Skipping..."

# Global variables -------------------------------------------------------------

var_monitor_count=0
var_monitor_scaling=0
var_monitor_scaling_pct=0

var_cfg_always_yes=0
var_cfg_verbose=1
var_cfg_module=0
var_cfg_all_modules=0
var_cfg_theme=0
var_cfg_only_update=0

var_logout=0
var_installed=0
var_answer=
var_selected_filename=
var_confirmed=
var_current_category=""

# Selected theme parameters
theme_index=
theme_name=
theme_prefix=
theme_color=

# Temporary selected theme index (select_available_filename)
theme_index_current=

# ------------------------------------------------------------------------------
# function show_warning_message ()
# Answer 'y' to continue, cancel otherwise.
# ------------------------------------------------------------------------------
function show_warning_message ()
{
   local c_normal=$_ansi_black
   local c_bold=$_ansi_red
   local c_bg=$_ansi_bg_yellow

   clear
#  ___print_centered_fw (msg, filler_char, color_background, color_normal_text, color_bold1_text, color_bold2_text, color_bold3_text)
   CR
   ___print_centered_fw "  _____                _             " " " "" $_ansi_lwhite
   ___print_centered_fw " |_   _|              | |            " " " "" $_ansi_lwhite
   ___print_centered_fw "   | |_   ____ _ _ __ | |_ _   _     " " " "" $_ansi_lyellow
   ___print_centered_fw "   | \ \ / / _\` | '_ \| __| | | |    " " " "" $_ansi_lyellow
   ___print_centered_fw "  _| |\ V / (_| | | | | |_| |_| |    " " " "" $_ansi_yellow
   ___print_centered_fw " |_____\_/ \__,_|_| |_|\__|\__,_| <1>$cons_lit_product_version" " " "" $_ansi_yellow $_ansi_lwhite
   CR
   ___print_centered_fw "" "-" $_ansi_bg_yellow $_ansi_black $_ansi_red
   ___print_fw "  This script configures some of MY preferences and configurations for an    " " " $_ansi_bg_yellow $_ansi_black $_ansi_red
   ___print_fw "  <1>Ubuntu<0> system with a <1>GNOME 46+<0> desktop.                                    " " " $_ansi_bg_yellow $_ansi_black $_ansi_red
   ___print_fw "" " " $_ansi_bg_yellow $_ansi_black $_ansi_red
   ___print_fw "  Do not run this unless you are me or you are sure you want these changes.  " " " $_ansi_bg_yellow $_ansi_black $_ansi_red
   ___print_centered_fw "" "-" $_ansi_bg_yellow $_ansi_black $_ansi_red
   CR
   check_required_packages
   detect_monitors_data

   confirm 0 "Do you want to continue"
   if [ $var_confirmed -gt 0 ]; then
      :
   else
      quit "Cancelled"
      CR
   fi
}

# ------------------------------------------------------------------------------
function warning_required_package ()
{
   local package=$1
   local critical=$2
   local additional_message=$3
   local installed=$(is_package_installed $package)
   if [ $installed = 0 ]; then
      local big_message="WARNING: <1>$package<0> is not installed."$additional_message
      if [ $critical -gt 0 ]; then
         ___print_error_bg "$big_message"
      else
         ___print_warning $big_message
      fi
   else
      log 2 "Package \"<1>$package<0>\" already installed."
   fi
}

# ------------------------------------------------------------------------------
function check_required_packages ()
{
   warning_required_package fastfetch 0
   warning_required_package eza 0
   warning_required_package conky-all 0
   warning_required_package gnome-shell-extension-manager 0
   warning_required_package 7zip 1 "This package IS required for some of the installations. You must install it first."
   CR
}

# ------------------------------------------------------------------------------
function set_system_colors ()
{
   _title_bg=$_ansi_bg_red
   _title_c1=$_ansi_lwhite
   _title_c2=$_ansi_lyellow
   _title_c3=$_ansi_lcyan
   _title_c4=$_ansi_lgreen
}

# ------------------------------------------------------------------------------
function set_gui_colors ()
{
   _title_bg=$_ansi_bg_blue
   _title_c1=$_ansi_lwhite
   _title_c2=$_ansi_lyellow
   _title_c3=$_ansi_lcyan
   _title_c4=$_ansi_lgreen
}

# ------------------------------------------------------------------------------
function set_application_colors ()
{
   _title_bg=$_ansi_bg_green
   _title_c1=$_ansi_lwhite
   _title_c2=$_ansi_lyellow
   _title_c3=$_ansi_lgreen
   _title_c4=$_ansi_lcyan
}

# ------------------------------------------------------------------------------
function set_icons_colors ()
{
   _title_bg=$_ansi_bg_magenta
   _title_c1=$_ansi_lwhite
   _title_c2=$_ansi_lyellow
   _title_c3=$_ansi_lgreen
   _title_c4=$_ansi_lcyan
}

# ------------------------------------------------------------------------------
function set_updates_colors ()
{
   _title_bg=$_ansi_bg_cyan
   _title_c1=$_ansi_lwhite
   _title_c2=$_ansi_lyellow
   _title_c3=$_ansi_lgreen
   _title_c4=$_ansi_lcyan
}

# ------------------------------------------------------------------------------
function set_menu_colors ()
{
   _title_bg=$_ansi_bg_lyellow
   _title_c1=$_ansi_black
   _title_c2=$_ansi_red
   _title_c3=$_ansi_blue
   _title_c4=$_ansi_green
}

# ------------------------------------------------------------------------------
function do_system_configuration ()
{
   set_system_colors
   var_current_category="System Configuration"
   setup_keyboard_options
   setup_power_settings
   setup_startup_configuration_files
   setup_module_bline
}

# ------------------------------------------------------------------------------
function do_gui_system_configuration ()
{
   set_gui_colors
   var_current_category="Graphical User Interface - System"
   choose_theme
   setup_grub_menu
   setup_boot_logos
   setup_login_screen_wallpaper
   setup_module_gse_gdm_extension
}

# ------------------------------------------------------------------------------
function do_gui_desktop_configuration ()
{
   set_gui_colors
   var_current_category="Graphical User Interface - Desktop"
   choose_theme
   setup_desktop_appearance
   setup_desktop_wallpaper
   setup_user_icon
   setup_gnome_extensions
   setup_file_manager
   create_desktop_files
}

# ------------------------------------------------------------------------------
function do_applications_configuration ()
{
   set_application_colors
   var_current_category="Applications"
   choose_theme
   setup_terminal_profiles
   setup_ptyxis
   setup_eza
   # setup_conky
}

# ------------------------------------------------------------------------------
function do_icons_configuration ()
{
   set_icons_colors
   var_current_category="Icons"
#  choose_theme
   install_ivantu_icons

   local iconset=$(gsettings get org.gnome.desktop.interface icon-theme)
   iconset="${iconset%\'}"
   iconset="${iconset#\'}"
   if [ $iconset = "Ivantu" ]; then
      update_desktop_files
      update_folder_icons
   fi
}

# ------------------------------------------------------------------------------
function do_updates ()
{
   set_updates_colors
   var_current_category="Updates"
#  choose_theme
   setup_startup_configuration_files
   install_ivantu_icons

   local iconset=$(gsettings get org.gnome.desktop.interface icon-theme)
   iconset="${iconset%\'}"
   iconset="${iconset#\'}"
   if [ $iconset = "Ivantu" ]; then
      update_desktop_files
      update_folder_icons
   fi
}

# ------------------------------------------------------------------------------
function check_logout_warning ()
{
   if [ $var_logout -gt 0 ]; then
      ___print_warning_bg "WARNING: You should log out to apply some pending changes."
      CR
   fi
}

# ------------------------------------------------------------------------------
function show_main_menu ()
{
   CR
   set_menu_colors
   print_title "Main Menu"

   if [ -z $theme_name ] || [ $theme_name = "" ]; then
      ___print_info "No theme selected."
   else
      ___print_info "Current theme: [$theme_color$theme_name<0>]"
   fi
   CR

   check_logout_warning

   ___print_info "   "$_o_option"1<0> - System Configuration"
   ___print_info "   "$_o_option"2<0> - GUI-System Configuration"
   ___print_info "   "$_o_option"3<0> - GUI-Desktop Configuration"
   ___print_info "   "$_o_option"4<0> - Icons replacement"
   ___print_info "   "$_o_option"5<0> - Applications Configuration"
   ___print_info "   "$_o_option"6<0> - Icon updates"
   ___print_info "   "$_o_skip"X<0> - Exit"
}

# ------------------------------------------------------------------------------
function parse_parameters ()
{
   local i=
   local v=
   for i in "$@"; do
      case $i in
         -h|--help)
            CR
            ___print_info_bg "[ <1>$cons_lit_product_name<0> <2>$cons_lit_product_version<0> (<3>$cons_lit_product_date<0>) ]"
            CR
            _print_usage
            CR
            exit 0
            ;;

         -y|--yes)
            var_cfg_always_yes=1
            log 2 "Parameters: Answers are always \"<1>yes<0>\"."
            shift
            ;;

         -v=*|--verbose=*)
            v="${i#*=}"
            if ! [[ $v =~ $_numbers ]] || [[ $v -lt 0 ]] || [[ $v -gt 2 ]]; then
               _quit_params "$i"
            fi
            var_cfg_verbose=$v
            log 2 "Parameters: Verbose level set to <1>$var_cfg_verbose<0>."
            shift
            ;;

         -u|--update)
            if [ $var_cfg_module -gt 0 ]; then
               _invalid_params "$i"
            fi
            var_cfg_only_update=1
            log 2 "Parameters: Only-update set to <1>$var_cfg_only_update<0>."
            ;;

         -m=*|--module=*)
            if [ $var_cfg_only_update -gt 0 ]; then
               _invalid_params "$i"
            fi
            v="${i#*=}"
            if ! [[ $v =~ $_numbers ]] || [[ $v -lt 1 ]] || [[ $v -gt 6 ]]; then
               _quit_params "$i"
            fi
            var_cfg_module=$v
            log 2 "Parameters: Module set to <1>$var_cfg_verbose<0>."
            shift
            ;;

         -a|--all-modules)
            var_cfg_all_modules=1
            log 2 "Parameters: All modules."
            shift
            ;;

         -t=*|--theme=*)
            v="${i#*=}"
            if ! [[ $v =~ $_numbers ]] || [[ $v -lt 1 ]] || [[ $v -gt $THEME_COUNT ]]; then
            v="${i#*=}"
               _quit_params "$i"
            fi
            var_cfg_theme=$v
            log 2 "Parameters: Theme set to <1>$var_cfg_theme<0>."
            shift
            ;;

         *)
            _quit_params "$i"
            exit 1
            ;;
      esac
   done

   if [ $var_cfg_only_update -gt 0 ]; then
      var_cfg_module=6
   fi
}

# ------------------------------------------------------------------------------
function _print_usage ()
{
   echo -e " Usage: "$_ansi_black$_ansi_bg_white ivantu.sh -v=\<verbose_level\> -m=\<module\> -t=\<theme\>-y -a \| -u \| -h $_ansi_off
   echo -e " Usage: "$_ansi_black$_ansi_bg_white ivantu.sh --verbose=\<verbose_level\> --module=\<module\> --theme=\<theme\> --yes --all-modules \| --update \| --help $_ansi_off
   echo -e "        verbose_level: 0-2" $_ansi_off
   echo -e "        module: 1-6" $_ansi_off"(System Conf. / GUI-System Conf. / GUI-Desktop Conf. / Icons / Apps Conf. / Updates)"
   let "n=THEME_COUNT-1"
   echo -en "        theme: 1-$n ("$_ansi_off
   let "last=THEME_COUNT-1"
   for (( i=0 ; i<$THEME_COUNT ; i++ ));
   do
      #name=${THEME_NAMES[$i]}
      name=${THEME_PREFIXES[$i]}
      echo -en "$name"
      if [ "$i" -lt "$last" ]; then
         echo -en " / "
      fi
   done
   echo -e ")" $_ansi_off
}

# ------------------------------------------------------------------------------
function _quit_params
{
   local param="$1"
   local filename="$0"
   filename="${filename##*/}"
   quit "<2>$filename<0>: Unknown option \"<1>$param<0>\"."
}

# ------------------------------------------------------------------------------
function _invalid_params
{
   local param="$1"
   local filename="$0"
   filename="${filename##*/}"
   quit "<2>$filename<0>: Invalid parameters combination \"<1>$param<0>\"."
}

# ------------------------------------------------------------------------------
function no_root ()
{
   #!/bin/bash
#  if [[ $(id -u) -ne 0 ]]; then
#      error_exit "You must be root to perform this action"
#  fi

   if [[ $EUID -eq 0 ]]; then
      local filename="$0"
      filename="${filename##*/}"
      quit "<2>$filename<0>: This script <1>MUST NOT<0> be run as <1>root<0>."
     ___print_error_bg ""
     exit 1
   fi
}

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
function main ()
{
   # When var_cfg_all_modules, all modules are interated in current_all_modules.
   local current_all_modules=0
   no_root

   # We want case-insensitive comparisons.
   shopt -s nocasematch

   parse_parameters $@

   show_warning_message

   loop=1
   while [ $loop -gt 0 ] ; do
      show_main_menu

      CR
      if [ $var_cfg_all_modules -gt 0 ]; then
         let "current_all_modules=current_all_modules+1"
         var_answer=$current_all_modules
         if [ $current_all_modules -ge 6 ]; then
            loop=0
         fi
      elif [ $var_cfg_module -gt 0 ]; then
         ___print_info "Select option: <1>$var_cfg_module<0>"
         var_answer=$var_cfg_module
         loop=0
      else
         read_answer "Select option: "
      fi
      CR

      case $var_answer in
       "x")    loop=0;;
       "1")    do_system_configuration;;
       "2")    do_gui_system_configuration;;
       "3")    do_gui_desktop_configuration;;
       "4")    do_icons_configuration;;
       "5")    do_applications_configuration;;
       "6")    do_updates;;
       #do_icons_configuration
         *)    ___print_error "Invalid option <1>$var_answer<0>.";;
      esac
   done
   check_logout_warning
   ___print_warning_bg "<1>$cons_lit_product_name<0> finished."
   CR
   exit
}

main $@
