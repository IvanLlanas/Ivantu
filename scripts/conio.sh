# [conio.sh]------------8<------------8<------------8<------------8<------------8<------------8<------------8<------------

# conio.sh - Console Input/Output routines

# [LICENSE]-----------------------------------------------------------------------
#
# The MIT License (MIT)
#
# Copyright (c) 2025 Ivan Llanas
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# function ___trim (text)
# function ___get_current_time ()
# function ___datetime_to_string (date, [format])

# function ___echo_info (text)
# function ___print_info (command, [text])
# function ___print_info_bg (command, [text])
# function ___print_warning (command, [text])
# function ___print_warning_bg (command, [text])
# function ___print_error (command, [text])
# function ___print_error_bg (command, [text])
# function ___print_disabled (command, [text])
# function ___print_disabled_bg (command, [text])
# function ___print_url (url, [text], [color])
# function ___print_centered_fw (msg, filler_char, color_background, color_normal_text, color_bold1_text, color_bold2_text, color_bold3_text)
# function ___print_fw (msg, filler_char, color_background, color_normal_text, color_bold1_text, color_bold2_text, color_bold3_text)
# function ___cmd_descr ()
# function ___cmd_usage ()

# --------------------------------------------------------------------------------

# ANSI colors ----------------------------------------------------------

_ansi_off='\e[0m'
_ansi_bold='\e[1m'

_ansi_default='\e[39m'
_ansi_bg_default='\e[49m'

_ansi_black='\e[30m'
_ansi_red='\e[31m'
_ansi_green='\e[32m'
_ansi_yellow='\e[33m'
_ansi_blue='\e[34m'
_ansi_magenta='\e[35m'
_ansi_cyan='\e[36m'
_ansi_white='\e[37m'

_ansi_lblack='\e[90m'
_ansi_lred='\e[91m'
_ansi_lgreen='\e[92m'
_ansi_lyellow='\e[93m'
_ansi_lblue='\e[94m'
_ansi_lmagenta='\e[95m'
_ansi_lcyan='\e[96m'
_ansi_lwhite='\e[97m'

_ansi_bg_black='\e[40m'
_ansi_bg_red='\e[41m'
_ansi_bg_green='\e[42m'
_ansi_bg_yellow='\e[43m'
_ansi_bg_blue='\e[44m'
_ansi_bg_magenta='\e[45m'
_ansi_bg_cyan='\e[46m'
_ansi_bg_white='\e[47m'

_ansi_bg_lblack='\e[100m'
_ansi_bg_lred='\e[101m'
_ansi_bg_lgreen='\e[102m'
_ansi_bg_lyellow='\e[103m'
_ansi_bg_lblue='\e[104m'
_ansi_bg_lmagenta='\e[105m'
_ansi_bg_lcyan='\e[106m'
_ansi_bg_lwhite='\e[107m'

# Emphasis -------------------------------------------------------------
_em0='<0>'
_em1='<1>'
_em2='<2>'
_em3='<3>'

# Brackets -------------------------------------------------------------
# Canviar per brak_a1 brak_b1
_quote1='<'
_quote2='>'
_quotel1='['
_quotel2=']'

# _print_info colors ---------------------------------------------------
_info_c0=$_ansi_lwhite
_info_c1=$_ansi_lyellow
_info_c2=$_ansi_lcyan
_info_c3=$_ansi_lgreen
_info_bg=$_ansi_bg_default

# _print_info_bg colors ------------------------------------------------
_infobg_c0=$_ansi_lwhite
_infobg_c1=$_ansi_lcyan
_infobg_c2=$_ansi_lyellow
_infobg_c3=$_ansi_lgreen
_infobg_bg=$_ansi_bg_blue

# _print_warning colors -----------------------------------------------
_warning_c0=$_ansi_lyellow
_warning_c1=$_ansi_lwhite
_warning_c2=$_ansi_lcyan
_warning_c3=$_ansi_lgreen
_warning_bg=$_ansi_bg_default

# _print_warning_bg colors --------------------------------------------
_warningbg_c0=$_ansi_black
_warningbg_c1=$_ansi_red
_warningbg_c2=$_ansi_blue
_warningbg_c3=$_ansi_green
_warningbg_bg=$_ansi_bg_lyellow

# _print_error colors --------------------------------------------------
_error_c0=$_ansi_lred
_error_c1=$_ansi_lyellow
_error_c2=$_ansi_lcyan
_error_c3=$_ansi_lgreen
_error_bg=$_ansi_bg_default

# _print_error_bg colors -----------------------------------------------
_errorbg_c0=$_ansi_lwhite
_errorbg_c1=$_ansi_lyellow
_errorbg_c2=$_ansi_lcyan
_errorbg_c3=$_ansi_lgreen
_errorbg_bg=$_ansi_bg_red

# _print_disabled colors -----------------------------------------------
_disabled_c0=$_ansi_lblack
_disabled_c1=$_ansi_yellow
_disabled_c2=$_ansi_white
_disabled_c3=$_ansi_white
_disabled_bg=$_ansi_bg_default

# _print_disabled_bg colors --------------------------------------------
_disabledbg_c0=$_ansi_lwhite
_disabledbg_c1=$_ansi_lyellow
_disabledbg_c2=$_ansi_lcyan
_disabledbg_c3=$_ansi_lgreen
_disabledbg_bg=$_ansi_bg_green

# _print_info_bg colors ------------------------------------------------
_date_format_filename='%Y-%m-%d'
_datetime_format_filename=$_date_format_filename'__%H-%M-%S'
_date_format_screen='%Y/%m/%d'
_datetime_format_screen="$_date_format_screen %H:%M:%S"
_datetime_format_default="$_datetime_format_screen"

# String functions -----------------------------------------------------

# function ___trim (text)
# Removes leading and trailing spaces from string.
function ___trim ()
{
   local s=$1

   # Turn on the extglob shell option
   shopt -s extglob
   ## Trim leading whitespaces
   s="${s##*( )}"
   ## Trim trailing whitespaces
   s="${s%%*( )}"
   # Turn off the extglob shell option
   shopt -u extglob
   # Print final result
   echo $s
}

# function ___get_current_time ()
# Returns the current time in a number of seconds (since Jan-1 1970 00:00:00 UTC).
function ___get_current_time ()
{
   echo $(date +%s)
}

# function ___datetime_to_string (date, [format])
# Formats a given date time with a given datetime format string.
function ___datetime_to_string ()
{
   local dt="$1"
   local fmt="$2"

   if [ "$fmt" = "" ]; then
      fmt="$_datetime_format_default"
   fi
   echo $(date -d@$dt "+$fmt")
#  echo $(date -d@$dt '+%Y/%m/%d %H:%M:%S')
}

# function ___echo_info (text)
# Prints a message in info format.
function ___echo_info ()
{
   local text=$1

   text=${text//$_em3/$_info_c3}
   text=${text//$_em2/$_info_c2}
   text=${text//$_em1/$_info_c1}
   text=${text//$_em0/$_info_c0}

   echo -e "$_info_c0$_info_bg$text$_ansi_off"
}

# function ___print_info (command, [text])
# function ___print_info_bg (command, [text])
# Prints an information message.
function ___print_info ()
{
   local command=$1
   local text=$2

   command=${command//$_em3/$_info_c3}
   command=${command//$_em2/$_info_c2}
   command=${command//$_em1/$_info_c1}
   command=${command//$_em0/$_info_c0}

   if [ "$text" = "" ]; then
      echo -e "$_info_c0$_info_bg $command $_ansi_off"
   else
      text=${text//$_em3/$_info_c3}
      text=${text//$_em2/$_info_c2}
      text=${text//$_em1/$_info_c1}
      text=${text//$_em0/$_info_c0}

      echo -e "$_info_c1$_info_bg $command$_info_c0: $text $_ansi_off"
   fi
}

function ___print_info_bg ()
{
   local command=$1
   local text=$2

   command=${command//$_em3/$_infobg_c3}
   command=${command//$_em2/$_infobg_c2}
   command=${command//$_em1/$_infobg_c1}
   command=${command//$_em0/$_infobg_c0}

   if [ "$text" = "" ]; then
      echo -e "$_ansi_bold$_infobg_c0$_infobg_bg $command $_ansi_off"
   else
      text=${text//$_em3/$_infobg_c3}
      text=${text//$_em2/$_infobg_c2}
      text=${text//$_em1/$_infobg_c1}
      text=${text//$_em0/$_infobg_c0}

      echo -e "$_ansi_bold$_infobg_c1$_infobg_bg $command$_infobg_c0: $text $_ansi_off"
   fi
}

# function ___print_warning (command, [text])
# function ___print_warning_bg (command, [text])
# Prints a warning message.
function ___print_warning ()
{
   local command=$1
   local text=$2

   command=${command//$_em3/$_warning_c3}
   command=${command//$_em2/$_warning_c2}
   command=${command//$_em1/$_warning_c1}
   command=${command//$_em0/$_warning_c0}

   if [ "$text" = "" ]; then
      echo -e "$_warning_c0$_warning_bg $command $_ansi_off"
   else
      text=${text//$_em3/$_warning_c3}
      text=${text//$_em2/$_warning_c2}
      text=${text//$_em1/$_warning_c1}
      text=${text//$_em0/$_warning_c0}

      echo -e "$_warning_c1$_warning_bg $command$_warning_c0: $text $_ansi_off"
   fi
}

function ___print_warning_bg ()
{
   local command=$1
   local text=$2

   command=${command//$_em3/$_warningbg_c3}
   command=${command//$_em2/$_warningbg_c2}
   command=${command//$_em1/$_warningbg_c1}
   command=${command//$_em0/$_warningbg_c0}

   if [ "$text" = "" ]; then
      echo -e "$_warningbg_c0$_warningbg_bg $command $_ansi_off"
   else
      text=${text//$_em3/$_warningbg_c3}
      text=${text//$_em2/$_warningbg_c2}
      text=${text//$_em1/$_warningbg_c1}
      text=${text//$_em0/$_warningbg_c0}

      echo -e "$_warningbg_c1$_warningbg_bg $command$_warningbg_c0: $text $_ansi_off"
   fi
}

# function ___print_error (command, [text])
# function ___print_error_bg (command, [text])
# Prints an error message.
function ___print_error ()
{
   local command=$1
   local text=$2

   command=${command//$_em3/$_error_c3}
   command=${command//$_em2/$_error_c2}
   command=${command//$_em1/$_error_c1}
   command=${command//$_em0/$_error_c0}

   if [ "$text" = "" ]; then
      echo -e "$_error_c0$_error_bg $command $_ansi_off"
   else
      text=${text//$_em3/$_error_c3}
      text=${text//$_em2/$_error_c2}
      text=${text//$_em1/$_error_c1}
      text=${text//$_em0/$_error_c0}

      echo -e "$_error_c1$_error_bg $command$_error_c0: $text $_ansi_off"
   fi
}

function ___print_error_bg ()
{
   local command=$1
   local text=$2

   command=${command//$_em3/$_errorbg_c3}
   command=${command//$_em2/$_errorbg_c2}
   command=${command//$_em1/$_errorbg_c1}
   command=${command//$_em0/$_errorbg_c0}

   if [ "$text" = "" ]; then
      echo -e "$_errorbg_c0$_errorbg_bg $command $_ansi_off"
   else
      text=${text//$_em3/$_errorbg_c3}
      text=${text//$_em2/$_errorbg_c2}
      text=${text//$_em1/$_errorbg_c1}
      text=${text//$_em0/$_errorbg_c0}

      echo -e "$_errorbg_c1$_errorbg_bg $command$_errorbg_c0: $text $_ansi_off"
   fi
}

# function ___print_disabled (command, [text])
# function ___print_disabled_bg (command, [text])
# Prints a disabled (or less important) message.
function ___print_disabled ()
{
   local command=$1
   local text=$2

   command=${command//$_em3/$_disabled_c3}
   command=${command//$_em2/$_disabled_c2}
   command=${command//$_em1/$_disabled_c1}
   command=${command//$_em0/$_disabled_c0}

   if [ "$text" = "" ]; then
      echo -e "$_disabled_c0$_disabled_bg $command $_ansi_off"
   else
      text=${text//$_em3/$_disabled_c3}
      text=${text//$_em2/$_disabled_c2}
      text=${text//$_em1/$_disabled_c1}
      text=${text//$_em0/$_disabled_c0}

      echo -e "$_disabled_c1$_disabled_bg $command$_disabled_c0: $text $_ansi_off"
   fi
}

function ___print_disabled_bg ()
{
   local command=$1
   local text=$2

   command=${command//$_em3/$_disabledbg_c3}
   command=${command//$_em2/$_disabledbg_c2}
   command=${command//$_em1/$_disabledbg_c1}
   command=${command//$_em0/$_disabledbg_c0}

   if [ "$text" = "" ]; then
      echo -e "$_disabledbg_c0$_disabledbg_bg $command $_ansi_off"
   else
      text=${text//$_em3/$_disabledbg_c3}
      text=${text//$_em2/$_disabledbg_c2}
      text=${text//$_em1/$_disabledbg_c1}
      text=${text//$_em0/$_disabledbg_c0}

      echo -e "$_disabledbg_c1$_disabledbg_bg $command$_disabledbg_c0: $text $_ansi_off"
   fi
}

# function ___print_url (url, [text], [color])
# Prints an URL.
function ___print_url ()
{
   local url text color1 color2
   url="$1"
   text="$2"
   color1="$3"
   color2="$_ansi_off"

   if [ "$text" == "" ]; then
      text="$url"
   fi

   if [ "$color1" == "" ]; then
      printf "\e]8;;$url\e\\$text\e]8;;\e\\"
   else
      echo -en $color1
      printf "\e]8;;$url\e\\$text\e]8;;\e\\"
      echo -en $color2
   fi
}

# function _update_screen_columns ()
# Forces $COLUMNS update. It seems to work but I don't know why.
function _update_screen_columns ()
{
   local x=$COLUMNS
   sleep 0 # This sleep makes $COLUMNS get its proper value. Why? Dunno.
}

# function ___print_centered_fw (msg, filler_char, color_background, color_normal_text, color_bold1_text, color_bold2_text, color_bold3_text)
# Prints a centered screen full width message.
function ___print_centered_fw ()
{
   _update_screen_columns
   local msg=$1
   local char_filler=$2
   local c_bg=$3
   local c_0=$4
   local c_1=$5
   local c_2=$6
   local c_3=$7

   local none=""
   msg=${msg//$_em3/$none}
   msg=${msg//$_em2/$none}
   msg=${msg//$_em1/$none}
   msg=${msg//$_em0/$none}

   # Calculate the filler size needed to fill the whole terminal width.
   local lmsg=${#msg}
   local count=$(($COLUMNS - $lmsg))
   if [ $count -lt 1 ]
      then
      count=0
   fi
   local count2=$(($count / 2))
   local filler2=$(head -c $count2 < /dev/zero | tr '\0' "$char_filler" )

   # Check if we must add an additional char_filler because $count is an odd number.
   local filler3=""
   local count3=$(($count2 * 2))
   if [ $count3 -ne $count ]; then
      filler3=$char_filler
   fi

   # Change bold pattern with ansi colors.
   msg=$1
   msg=${msg//$_em3/$c_3}
   msg=${msg//$_em2/$c_2}
   msg=${msg//$_em1/$c_1}
   msg=${msg//$_em0/$c_0}

   echo -e "$c_bg$c_0$filler2$msg$filler2$filler3$_ansi_off"
}

# function ___print_fw (msg, filler_char, color_background, color_normal_text, color_bold1_text, color_bold2_text, color_bold3_text)
# Prints a screen full width message.
function ___print_fw ()
{
   _update_screen_columns
   local msg=$1
   local char_filler=$2
   local c_bg=$3
   local c_0=$4
   local c_1=$5
   local c_2=$6
   local c_3=$7

   local none=""
   msg=${msg//$_em3/$none}
   msg=${msg//$_em2/$none}
   msg=${msg//$_em1/$none}
   msg=${msg//$_em0/$none}

   # Calculate the filler size needed to fill the whole terminal width.
   local lmsg=${#msg}
   local count=$(($COLUMNS - $lmsg))
   if [ $count -lt 1 ]
      then
      count=0
   fi
   local filler=$(head -c $count < /dev/zero | tr '\0' "$char_filler" )

   # Change bold pattern with ansi colors.
   msg=$1
   msg=${msg//$_em3/$c_3}
   msg=${msg//$_em2/$c_2}
   msg=${msg//$_em1/$c_1}
   msg=${msg//$_em0/$c_0}

   echo -e "$c_bg$c_0$msg$filler$_ansi_off"
}

function ___cmd_descr ()
{
   echo -e " "$_ansi_bold$1$_ansi_off" - "$2$_ansi_off
}

function ___cmd_usage ()
{
   echo -e " Usage: "$_ansi_black$_ansi_bg_white $1 $_ansi_off
}

# [conio.sh]------------8<------------8<------------8<------------8<------------8<------------8<------------8<------------
