#!/bin/bash

# Functions --------------------------------------------------------------------
# function CR ()
# function log (verbose_level, text)
# function copy_file (privilege, filename_src, filename_dst)
# function copy_dir (privilege, filename_src, filename_dst)
# function backup_file (privilege, filename)
# function quit (message)
# function print_title (message)
# function not_found_message (filename)
# function read_answer (question_text)
# function confirm (default, msg)
# function is_package_installed (package_name)
# function check_and_install_optional_package (package_name, name, default=1)
# function choose_theme (force)
# function select_available_filename (check_dirs, dir, sufix)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# function CR ()
# Prints a carriage return.
# ------------------------------------------------------------------------------
function CR ()
{
   echo
}

# ------------------------------------------------------------------------------
# function log (verbose_level, text)
# Shows a log message dependng on verbose level.
# ------------------------------------------------------------------------------
function log ()
{
   local level=$1
   local text="$2"
   if [ $var_cfg_verbose -ge $level ]; then
      ___print_info "$text"
   fi
}

# ------------------------------------------------------------------------------
# function copy_file (privilege, filename_src, filename_dst)
# Copies filename1 to filename2.
# ------------------------------------------------------------------------------
function copy_file ()
{
   local privilege=$1
   local filename1="$2"
   local filename2="$3"
   local param=""

   if [ $var_cfg_verbose -gt 1 ]; then
      param="-v"
   fi

   if [ $privilege -gt 0 ]; then
      sudo cp $param "$filename1" "$filename2" | sed 's/^/  cp\*: /'
   else
      cp $param "$filename1" "$filename2" | sed 's/^/  cp: /'
   fi
}

# ------------------------------------------------------------------------------
# function copy_dir (privilege, filename_src, filename_dst)
# Copies files in dir1 into dir2 (not recursively).
# ------------------------------------------------------------------------------
function copy_dir ()
{
   local privilege=$1
   local dir1="$2"
   local dir2="$3"
   local pver=""

   if [ $var_cfg_verbose -gt 1 ]; then
      pver="-v"
   fi

   if [ $privilege -gt 0 ]; then
      sudo cp $pver "$dir1"/* "$dir2" | sed 's/^/  cp\*: /'
   else
      cp $pver "$dir1"/* "$dir2" | sed 's/^/  cp: /'
   fi
}

# ------------------------------------------------------------------------------
# function backup_file (privilege, filename)
# Creates a backup of filename if it does not exist.
# ------------------------------------------------------------------------------
function backup_file ()
{
   local privilege=$1
   local filename="$2"
   if [ ! -f "$filename"."$BACKUP_EXTENSION" ]; then
      log 2 "Backing up file <1>$filename<0>..."
      copy_file $privilege "$filename" "$filename"."$BACKUP_EXTENSION"
   fi
}

# ------------------------------------------------------------------------------
# function print_title (message)
# Quits printing an error message.
# ------------------------------------------------------------------------------
function print_title ()
{
   local category="$1"
   local text="$2"

   if [ $text ]; then
      text="<2>$category<0> > $text"
   else
      text="$category"
   fi
   text=" [ $text ]"

   ___print_fw "$text" " " "$_title_bg" "$_title_c1" "$_title_c2" "$_title_c3" "$_title_c4"
   CR
}

# ------------------------------------------------------------------------------
# function quit (message)
# Quits printing an error message.
# ------------------------------------------------------------------------------
function quit ()
{
   ___print_error_bg "$1"
   CR
   exit
}

# ------------------------------------------------------------------------------
# function not_found_message (filename)
# Prints a file-not-found error message.
# ------------------------------------------------------------------------------
function not_found_message ()
{
   local filename=$1
   ___print_error_bg "Resource <1>$filename<0> not found!"
}

# ------------------------------------------------------------------------------
# function read_answer (question_text)
# Colored user input showing literal. Puts the user text into variable var_answer.
# Return value in var_answer.
# ------------------------------------------------------------------------------
function read_answer ()
{
   local text=$1
   local answer=$2
   text=${text//$_em3/$_info_c3}
   text=${text//$_em2/$_info_c2}
   text=${text//$_em1/$_info_c1}
   text=${text//$_em0/$_info_c0}
   echo -en " $text "$_ansi_white

   if [[ ! -z "$answer" ]]; then
      echo -e $answer
      var_answer=$answer
   else
      read var_answer
   fi
   echo -en $_ansi_off
}

# ------------------------------------------------------------------------------
# function confirm (default, msg)
# Ask for a confirmation (yes/no) answer.
# default = 0  =>  N is the default answer.
# default = 1  =>  Y is the default answer.
# Return "confirmed" value (0 or 1) in var_confirmed.
# ------------------------------------------------------------------------------
function confirm ()
{
   local default=$1
   local msg="$2"
   local msg2=
   local answer=

   if [[ $default -gt 0 ]]; then
      msg2=" [$_o_default""Y$_ansi_off""ES/$_o_option""n<0>o]?"
   else
      msg2=" [$_o_default""N$_ansi_off""O/$_o_option""y<0>es]?"
   fi

   if [ $var_cfg_always_yes -gt 0 ]; then
      read_answer "$msg$msg2" "y"
   else
      read_answer "$msg$msg2"
   fi

   if [ -z $var_answer ]; then
      var_confirmed=$default
   elif [[ $var_answer = "no" ]] || [[ $var_answer = "n" ]]; then
      var_confirmed=0
   elif [[ $var_answer = "yes" ]] || [[ $var_answer = "y" ]]; then
      var_confirmed=1
   else
      quit "Invalid answer"
   fi
}

# ------------------------------------------------------------------------------
# function is_package_installed (package_name)
# Returns 1 if package_name is installed, 0 otherwise.
# ------------------------------------------------------------------------------
function is_package_installed ()
{
   local package=$1
   local installed=$(dpkg-query -W --showformat='${Status}\n' $package 2>/dev/null |grep "install ok installed")

   if [ "$installed" != "" ]; then
      # installed
      echo 1
   else
      # not installed
      echo 0
   fi
}

# ------------------------------------------------------------------------------
# function check_and_install_optional_package (package_name, name, default=1)
# Returns in variable var_installed:
#   1 if package_name is already installed,
#   2 if it is installed now,
#   0 otherwise.
# ------------------------------------------------------------------------------
function check_and_install_optional_package ()
{
   local package="$1"
   local name="$2"
   local default="$3"
   local installed=$(is_package_installed $package)

   if [[ $default == "" ]]; then
      default=1
   fi

   if [ $installed = 0 ]; then
      ___print_warning "<1>$package<0> is not installed."

      confirm $default "Install <1>$package<0> package"

      if [ $var_confirmed -gt 0 ]; then
         ___print_info "Installing <1>$package<0>..."
         sudo apt install -y $package | sed 's/^/  apt\*: /'
         var_installed=2
         CR
      else
         var_installed=0
      fi
   else
#   echo var_verbose=$var_verbose
      log 2 "Package \"<1>$package<0>\" already installed."
      var_installed=1
   fi
}

# ------------------------------------------------------------------------------
# function choose_theme (force)
# Asks for the preferred theme if it has not been previously selected unless
# force>0 which makes ask it anyway.
# ------------------------------------------------------------------------------
function choose_theme ()
{
   local force="$1"

   if [ -z $force ] ; then
      force=0
   fi

   if [ $force -gt 0 ] || [ -z $theme_name ] || [ $theme_name = "" ]; then
      print_title "$var_current_category" "Theme selection"

      local i=
      local id=
      local name=
      local color=

      for (( i=0 ; i<$THEME_COUNT ; i++ ));
      do
         let "id=i+1"
         name=${THEME_NAMES[$i]}
         color=${THEME_COLORS[$i]}
         ___echo_info "   $_o_option$id - $color$name"
      done

      CR
      if [ $var_cfg_theme -gt 0 ]; then
         ___print_info "Select a default theme: <1>$var_cfg_theme<0>"
         var_answer=$var_cfg_theme
      else
         read_answer "Select a default theme:"
      fi

      if [[ $var_answer =~ $_numbers ]] && [ ! -z $var_answer ] && [ $var_answer -ge 1 ] && [ $var_answer -le $THEME_COUNT ]; then
         let "theme_index=var_answer-1"
         theme_name=${THEME_NAMES[$theme_index]}
         theme_prefix=${THEME_PREFIXES[$theme_index]}
         theme_color=${THEME_COLORS[$theme_index]}
      else
         quit "Invalid option"
      fi
      ___print_info "$theme_color$theme_name<0> theme selected."
      CR
   fi
}

# ------------------------------------------------------------------------------
# function select_available_filename (check_dirs, dir, sufix)
# Asks for a theme index over the available ones.
# Checks for files $dir/<theme-id>$prefix.
# Return value is index, stored in var_selected_filename.
# If check_dirs>0 will check over directories instead of files.
# ------------------------------------------------------------------------------
function select_available_filename ()
{
   local check_dirs=$1
   local dir=$2
   local sufix=$3
   local prefix=
   local name=
   local color=
   local menu=
   local default_is_enabled=0
   local answers=
   local exists=
   local fileame=

   # Build the menu.
   for (( i=0 ; i<$THEME_COUNT ; i++ ));
   do
      let "id=i+1"
      prefix=${THEME_PREFIXES[$i]}
      color=${THEME_COLORS[$i]}

      exists=0
      filename="$dir/$prefix$sufix"
      if [ $check_dirs -eq 0 ]; then
         if [ -f "$filename" ]; then
           exists=1
         fi
      else
         if [ -d "$filename" ]; then
           exists=1
         fi
      fi

      if [ $exists -gt 0 ]; then
         if [ $theme_index ] && [ $theme_index == $i ]; then
            # 0 option must be shown.
            default_is_enabled=1
         fi
         if [ ! "$menu" == "" ]; then
            menu+="\n"
         fi
         answers+="/$_o_option$id<0>"
         name=${THEME_NAMES[$i]}
         color=${THEME_COLORS[$i]}
         menu+="   $_o_option$id$_ansi_off - $color$name"$_ansi_off
      fi
   done

   # Print the menu.
   if [ $default_is_enabled -gt 0 ]; then
      ___echo_info "   $_o_default"0"$_ansi_off - $theme_color$theme_name"$_ansi_off
      CR
      answers="/$_o_default"0$_ansi_off$answers
   fi
   answers="$_o_skip"N"<0>"o$answers

   ___echo_info "$menu"

   # $answers contains all real available answers
   CR
   if [ $var_cfg_theme -gt 0 ]; then
      ___print_info "Select an option [$answers]: <1>$var_cfg_theme<0>"
      var_answer=$var_cfg_theme
   else
      read_answer "Select an option [$answers]:"
   fi
   theme_index_current=
   var_selected_filename=

   if [[ $var_answer = "N" ]]; then
      ___print_info $skipping_
      return
   elif [ -z $var_answer ] || [ $var_answer = "0" ] ; then
      theme_index_current=$theme_index
      ___print_info "Default selected."
   elif [ $var_answer -ge 1 ] && [ $var_answer -le $THEME_COUNT ]; then
      let "theme_index_current=var_answer-1"
   else
      ___print_error_bg "Invalid option. "$skipping_
      return
   fi

   local filename="$dir/${THEME_PREFIXES[$theme_index_current]}$sufix"
   filename=$(realpath -s "$filename")
#  if [ ! -f "$filename" ]; then
#     not_found_message "$filename"
#     return
#  fi
   var_selected_filename=$filename
}
