#!/bin/bash
# ----------------------------------------------------------------------
# SHPacker 1.3 - Ivan llanas - 2026/08/29
# ----------------------------------------------------------------------
source $IVANTU_SCRIPTS_DIR/conio.sh

# Internal constats - Do not touch -------------------------------------
_current_full_version=1.3
# _current_version must change when protocol changes and makes old
# scripts incompatible.
_current_version=1
_bold1='<b>'
_bold0='</b>'

_fg_bold='\e[1m'
_fg_yellow='\e[1;33m'
_fg_white='\e[1;37m'
_bg_red='\e[41m'
_bg_blue2='\e[44m'
_nocolor='\e[0m'
_info2='\e[0;37;40m'
# ----------------------------------------------------------------------

# ----------------------------------------------------------------------
function get_current_time ()
{
   echo $(date +%s)
}

# ----------------------------------------------------------------------
function time_to_string ()
{
#  echo $(date '+%H:%M:%S')
   echo $(date -d@$1 -u +%H:%M:%S)
}

# ----------------------------------------------------------------------
function check_packer ()
{
   # Packer variables - No need to be changed -----------------------------
   if [ "$packer" = "7z" ]; then
      # configured to use 7z
      packer=7z
      packer_command="a"
      archive_file_type=" -t7z"
      archive_file_extension=".7z"
      # 22Mb dictionary will not eat all the memory.
      if [ "$packer_fast" = "0" ]; then
         packer_options="-mx=9 -md=22M"
      else
         packer_options=""
      fi
      archive_par_recursive=-r
      archive_par_volume=-v2000000000b
   elif [ "$packer" = "rar" ]; then
      # configured to use rar
      packer=rar
      packer_command="a"
      archive_file_type=""
      archive_file_extension=".rar"
      if [ "$packer_fast" = "0" ]; then
         packer_options="-s -m5 -md1g"
      else
         packer_options=""
      fi
      archive_par_recursive=-r
      archive_par_volume=-v2000000000b
   else
      ___print_error "Invalid packer identifier: <1>$packer</0>"
      exit
   fi
}

# ----------------------------------------------------------------------
archive_user_sufix="$1"
function go ()
{
   if [ $version -ne $_current_version ]; then
      ___print_error "Invalid script version (current version is <1>$version</0> and current version is <1>$_current_version</0>)!"
      return
   fi

   check_packer

   local vpar=
   local move=false

   final_directory=$(realpath "$final_directory")
   if [ ! -d "$final_directory" ]; then
      ___print_error "Final directory (<1>$final_directory</0>) not found!"
      return
   fi

   cd "$packing_directory"

   if [ "$temp_directory" != "" ]; then
      if [ ! -d "$temp_directory" ]; then
         ___print_error "Temporary directory (<1>$temp_directory</0>) not found!"
         return
      fi
      move=true
   else
      temp_directory=$final_directory
   fi

   case $timestamp_format in
      0) archive_date="";;
      1) archive_date="."$(date '+%Y-%m-%d');;
      2) archive_date="."$(date '+%Y-%m-%d__%H-%M-%S');;
      *) ___print_error "Invalid (<1>timestamp_format</0>): \"$timestamp_format\"!"
         return
         ;;
   esac

   if [ "$archive_user_sufix" != "" ]; then
      archive_user_sufix=${archive_user_sufix// /-}
      archive_user_sufix="___$archive_user_sufix"
   fi

   archive_fullfilename="$temp_directory/$archive_sufix$archive_date$archive_user_sufix$archive_file_extension"

   if $archive_volumes ; then
      vpar=$archive_par_volume
   else
      vpar=""
   fi
   if $recursive ; then
      rpar=$archive_par_recursive
   else
      rpar=""
   fi

   # Compressing
   local time0=$(get_current_time)
   ___print_info_bg "Compressing \"<1>$pack_name<0>\" - $archive_date..."
   ___print_info "> $packer $packer_command $packer_options $archive_file_type $rpar $vpar \"$archive_fullfilename\" $source_files $file_exceptions"
   $packer $packer_command $packer_options $archive_file_type $rpar $vpar "$archive_fullfilename" $source_files $file_exceptions

   # Moving
   if $move ; then
      local option=""
      if $confirm_overwrite ; then
         option="-i"
      fi

      local time1=$(get_current_time)
      ___print_info_bg "Moving to <1>$final_directory</0>..."
      mv -v $option $archive_fullfilename.* "$final_directory"
      sleep 1
   fi

   # Finishing
   local time2=$(get_current_time)
   ___print_info_bg "Done."
   echo
   if $move ; then
      ___print_info " Compress: "$(time_to_string $(($time1-$time0)))
      ___print_info "     Move: "$(time_to_string $(($time2-$time1)))
      ___print_info "    Total: <1>"$(time_to_string $(($time2-$time0)))"<0>"
   else
      ___print_info " Elapsed time: <1>"$(time_to_string $(($time2-$time0)))"<0>"
   fi
   echo
}


# To create scripts calling shpacker:
# ------8<------8<------8<------8<------8<------8<------8<------8<------
# Uncomment this:
#source "$HOME/Scripts/sh/conio.sh"

# ----------------------------------------------------------------------
#
#  From directory "packing_directory" the archiver will be called to
#  compress "source_files".
#  If "temp_directory" is not empty, the archives will be created in
#  "temp_directory" to be finally moved to "final_directory".
#  If "temp_directory" is empty, the archives will be directly
#  created in "final_directory".
#  "final_directory" IS/can be relative to the calling script path.
#
# ----------------------------------------------------------------------
# Version control. Each script calling this one MUST be
# version = _current_version
version=0

# Archiver to be used: 7z, rar
packer=7z
# Max compression and solid file
packer_fast=0
# Name to be displayed
pack_name=
# Initial fragment of the archive(s) filename(s)
archive_sufix=
# Directory from which to invoke the archiver
packing_directory=
# Files to be archived
source_files=
# Temporary place to build the archives (if empty, final directory will be used)
temp_directory=
# Final destination of the archives
final_directory=
# Packer parameter(s) with the file exceptions
file_exceptions=

# Timestamp format: 0 - none, 1 - only date, 2 - full datetime
timestamp_format=2
# Make volumes (archive_volume_size)?
archive_volumes=false
# Recurse directories=
recursive=true
# Ask before overwritting a file on moving the archive to the final directory?
confirm_overwrite=true



# ------8<------8<------8<------8<------8<------8<------8<------8<------
