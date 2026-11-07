#!/usr/bin/env bash

#      ██╗  ██╗██╗   ██╗██████╗ ██████╗       #
#      ██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗      #
#      ███████║ ╚████╔╝ ██████╔╝██████╔╝      #
#      ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══██╗      #
#      ██║  ██║   ██║   ██║     ██║  ██║      #
#      ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝      #
#                                             #
#    ██████╗  █████╗ ███╗   ██╗██╗ ██████╗    #
#    ██╔══██╗██╔══██╗████╗  ██║██║██╔════╝    #
#    ██████╔╝███████║██╔██╗ ██║██║██║         #
#    ██╔═══╝ ██╔══██║██║╚██╗██║██║██║         #
#    ██║     ██║  ██║██║ ╚████║██║╚██████╗    #
#    ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝ ╚═════╝    #
#    ___        ___ _                  __     #
#   | _ )_  _  | _ \ |  _  _ _ _ __ __/  \    #
#   | _ \ || | |   / |_| || | ' \\ \ / () |   #
#   |___/\_, | |_|_\____\_, |_||_/_\_\\__/    #
#        |__/           |__/                  #


workdir="$(dirname "$0")"
state="${XDG_STATE_HOME:-"$HOME/.local/state"}/hypr-panic"
mkdir -p "$state"
temp="$state/temp.panic"
data_base="panic_data"
awk_compress="$workdir/compress-state.awk"
awk_panic="$workdir/gen-panic.awk"
awk_unpanic="$workdir/gen-unpanic.awk"
awk_unpause="$workdir/gen-unpause.awk"
awk_info="$workdir/gen-info.awk"
delta="10"


# get options and overwrite variables
while getopts "d:prih" arg; do
  case $arg in
  d)
    delta="$OPTARG"
    ;;
  r)
    restore_only="yes"
    ;;
  p)
    force_panic="yes"
    ;;
  i)
    output_info="yes"
    ;;
  *)
    echo "Usage: $(basename $0) [OPTIONS]"
    printf "\nOptions:\n"
    echo "  -d <DELTA>   Shift each workspace by this amount     [default: 10]"
    echo "  -r           Restore only; do nothing if not panicked             "
    echo "  -p           Force panic, even if panic data exists               "
    echo "  -i           Print information for waybar and exit                "
    echo "  -h           Print this help message and exit                     "
    exit 1
  esac
done
shift $(($OPTIND-1))


function last_data_path {
  find "$state" -maxdepth 1 -type f -name "$data_base*" | sort -V | tail -1
}

function last_data_num {
  basename "$(last_data_path)" | tr -d "$data_base" 2> /dev/null \
  || echo ""
}

function new_data_num {
  echo "$(("$(last_data_num)" + 1))"
}

function new_data_path {
  echo "$state/$data_base$(new_data_num)"
}

function waybar_info {
  if [ "$(last_data_path)" ]; then
    wb_text="Panic Mode"
    info="$(awk -f "$awk_info" "$(last_data_path)")"
    wb_tooltip="Restore State $(last_data_num) $info"
    wb_class="panicked"
  else
    wb_text=""
    wb_tooltip="Currently unpanicked"
    wb_class="unpanicked"
  fi

  printf '{"text": "%s", "tooltip": "%s", "class": "%s"}\n' \
    "$wb_text" \
    "$wb_tooltip" \
    "$wb_class"
}

function player_data {
  printf '\n# Players\n'
  while read -r player; do
    if [ "$(busctl --user get-property "$player" /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player PlaybackStatus 2>/dev/null)" = 's "Playing"' ]; then
      printf '%s\n' "$player"
      busctl --user call "$player" /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player Pause >/dev/null
    fi
  done < <(busctl --user --list --no-legend list | awk '$1 ~ /^org\.mpris\.MediaPlayer2\./ { print $1 }')
}


if [ "$output_info" != "" ]; then
  waybar_info
  exit 0
fi

[ -z "${restore_only:-}" ] || [ -n "$(last_data_path)" ] || exit 0

hyprctl monitors | awk -f "$awk_compress" > "$temp"
player_data >> "$temp"

if [ "$(last_data_path)" -a -z "$force_panic" ]; then
  # UNPANIC
  data="$(last_data_path)"
  eval "$(awk -v d="0" -f "$awk_panic" "$temp")"  # Toggle off special workspaces
  eval "$(awk -f "$awk_unpanic" "$data" "$temp")" # Restore the monitor state before panicking
  eval "$(awk -f "$awk_unpause" "$data")"
  rm "$temp" "$data"
else
  # PANIC
  # Send each monitor to it's active workspace + delta
  # Also, toggle off special workspaces
  eval "$(awk -v d="$delta" -f "$awk_panic" "$temp")"
  noctalia msg notification-clear-active
  noctalia msg panel-close
  mv "$temp" "$(new_data_path)"
fi

exit 0
