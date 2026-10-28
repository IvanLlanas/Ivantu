source "$IVANTU_SCRIPTS_DIR/conio.sh"

# ----------------------------------------------------------------------
function time_to_string ()
{
# -u avoid converting this time to local timezone.
   echo $(date -u -d@$1 +%H:%M:%S)
}

# ----------------------------------------------------------------------
function go ()
{
   local cmd time1 time2

   if [ $# -lt 1 ]; then
      # ___cmd_descr "timetask" "$timetask_description"
      ___cmd_descr "timetask" "time a task"
      ___cmd_usage "Usage: <1>timetask command<0>"

      exit 1
   fi

   cmd="$@"

   ___print_info_bg "Starting..."
   ___print_info "<2>$<0> <1>$cmd<0>"

   time1=$(___get_current_time)
   $@
   time2=$(___get_current_time)

   ___print_info_bg "Done."
   echo
   ___print_info "Elapsed time: <1>"$(time_to_string $(($time2-$time1)))"<0>"
   echo
}

go $@
