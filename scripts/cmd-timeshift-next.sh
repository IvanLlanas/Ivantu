#!/bin/bash

source "$IVANTU_SCRIPTS_DIR/conio.sh"

# ----------------------------------------------------------
# timeshift-next
# Check the next scheduled Timeshift run.
# Compatible with Timeshift 25.12.4
# ----------------------------------------------------------

CONFIG="/etc/timeshift/timeshift.json"
CMD="timeshift-next"

# Get values from configuration
get_config() {
   sed -nE \
      "s/^[[:space:]]*\"$1\"[[:space:]]*:[[:space:]]*\"?([^\",]+)\"?.*/\1/p" \
      "$CONFIG" | head -n1
}

if [[ ! -r "$CONFIG" ]]; then
   ___print_error_bg "$CMD" "cannot read <1>$CONFIG<0>."
   exit 1
fi

# Labels and Timeshift frequencies
declare -A ENABLED=(
   [H]="schedule_hourly"
   [D]="schedule_daily"
   [W]="schedule_weekly"
   [M]="schedule_monthly"
   [B]="schedule_boot"
)

declare -A LABELS=(
   [H]="Hourly"
   [D]="Daily"
   [W]="Weekly"
   [M]="Monthly"
   [B]="After boot"
)

declare -A UNITS=(
   [H]="hour"
   [D]="day"
   [W]="week"
   [M]="month"
)

declare -A COUNTS=(
   [H]="count_hourly"
   [D]="count_daily"
   [W]="count_weekly"
   [M]="count_monthly"
   [B]="count_boot"
)

# Check active scheduled task
ACTIVE=()

for tag in H D W M B; do
   key="${ENABLED[$tag]}"
   if [[ "$(get_config "$key")" == "true" ]]; then
      ACTIVE+=("$tag")
   fi
done

if ((${#ACTIVE[@]} == 0)); then
   ___print_info "$CMD" "No active scheduled task."
   exit 0
fi

# ----------------------------------------------------------
sudo echo
___print_info_bg "Scheduled tasks"

for tag in "${ACTIVE[@]}"; do
    count=$(get_config "${COUNTS[$tag]}")
    printf -v s -- " %s - <1>%s<0> kept snaphots." "${LABELS[$tag]}" "$count"
    ___print_info "$s"
done

# Get snapshot list from Timeshift
SNAPSHOTS=$(sudo timeshift --list 2>/dev/null)

if [[ $? -ne 0 || -z "$SNAPSHOTS" ]]; then
   ___print_error_bg "$CMD" "cannot check the snapshots."
   exit 1
fi

# ----------------------------------------------------------
echo
___print_info_bg "Snapshots"

# Last date of each label
declare -A LAST_EPOCH
declare -A LAST_NAME

while read -r name tag; do

   [[ -z "$name" || -z "$tag" ]] && continue

   timestamp="${name//_/-}"
   timestamp="${name:0:10} ${name:11:2}:${name:14:2}:${name:17:2}"

   epoch=$(date -d "$timestamp" +%s 2>/dev/null) || continue

   if [[ -z "${LAST_EPOCH[$tag]}" ]] ||
      (( epoch > LAST_EPOCH[$tag] )); then
      LAST_EPOCH[$tag]=$epoch
      LAST_NAME[$tag]=$name
   fi

done < <(
   awk '
   $1 ~ /^[0-9]+$/ && $3 ~ /^[0-9][0-9][0-9][0-9]-/ {
      for (i=4; i<=NF; i++) {
         if ($i ~ /^[HDWMB]$/)
            print $3, $i
      }
   }' <<< "$SNAPSHOTS"
)

for tag in H D W M B; do
   if [[ -n "${LAST_NAME[$tag]}" ]]; then
      printf -v s -- " %s - <1>%s<0>" "${LABELS[$tag]}" "${LAST_NAME[$tag]}"
      ___print_info "$s"
   fi
done

# ----------------------------------------------------------
echo
___print_info_bg "Next checks"

# First cron check previous to this message
NOW=$(date +%s)
NEXT_CRON=$(( (NOW / 3600 + 1) * 3600 ))

v="$(date -d "@$NEXT_CRON" '+%d/%m/%Y %H:%M')"
printf -v s -- " Next cron check: <1>%s<0>" "$v"
___print_info "$s"

echo

# ----------------------------------------------------------
# Calculate the first check that meets the age condition for each category.
for tag in "${ACTIVE[@]}"; do

   if [[ "$tag" == "B" ]]; then
      continue
   fi

   ___print_info_bg "${LABELS[$tag]}"

   if [[ -z "${LAST_EPOCH[$tag]}" ]]; then
      ___print_info " No previous snapshots."
      v="$(date -d "@$NEXT_CRON" '+%d/%m/%Y %H:%M')"
      printf -v s -- " Next check: <1>$v<0>"
      ___print_info "%s"
      echo
      continue
   fi

   last=${LAST_EPOCH[$tag]}
   unit=${UNITS[$tag]}

   v="$(date -d "@$last" '+%d/%m/%Y %H:%M:%S')"
   printf -v s " Last snapshot: <3>$v<0>"
   ___print_info "$s"

    # Find the first time-based check that meets the Timeshift rule.
    found=0
    candidate=$NEXT_CRON

    # 35 days allow for covering even the monthly interval.
    for ((i=0; i<24*35; i++)); do

        candidate_date=$(date -d "@$candidate" '+%Y-%m-%d %H:%M:%S')

        threshold=$(date -d \
            "$candidate_date -1 $unit +1 minute" +%s 2>/dev/null)

        if [[ -n "$threshold" ]] && (( last < threshold )); then
            found=1
            break
        fi

        candidate=$((candidate + 3600))
    done

    if (( found )); then
        v=$(date -d "@$candidate" '+%A %d/%m/%Y %H:%M')
        printf -v s -- " Next scheduled snapshot: <2>$v<0>"
        ___print_info "$s"
    else
        ___print_error "Could not be calculated within the interval."
    fi

    echo
done

# Tratamiento especial de las copias al arrancar
if [[ " ${ACTIVE[*]} " == *" B "* ]]; then

    echo "After boot:"

    BOOT_TIME=$(awk '$1=="btime" {print $2}' /proc/stat)

    if [[ -n "${LAST_EPOCH[B]}" ]]; then
        printf "  Last snapshot: "
        date -d "@${LAST_EPOCH[B]}" '+%d/%m/%Y %H:%M:%S'
    else
        echo "  No boot snapshot."
    fi

    if [[ -n "$BOOT_TIME" ]]; then
        if [[ -z "${LAST_EPOCH[B]}" ]] ||
           (( LAST_EPOCH[B] < BOOT_TIME )); then
            echo "  Snapshot pending on this sessions, within 10 minutes."
        else
            echo "  Snapshot already done in this session."
            echo "  Next snapshot on next boot (+10 min)."
        fi
    fi

    echo
fi

# The dates indicate when Timeshift meets its conditions during a check. Actual creation depends on the system state, available space, and cron execution.
