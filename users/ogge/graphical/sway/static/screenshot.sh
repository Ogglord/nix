#! /usr/bin/env zsh

set -e

PICTURES_DIR="$(xdg-user-dir PICTURES)"
monitor="$(swaymsg -t get_outputs | jq '[.[].focused] | index(true)')"
alias myrofi="rofi -dmenu -matching fuzzy -i -sort -sorting-method fzf -monitor $monitor"

select_window() {
  declare -A windows

  swaymsg -t get_tree |
    jq -r '..|.nodes? + .floating_nodes?|arrays|select(length > 0)|.[]|select((.nodes + .floating_nodes | length) == 0)|select(.visible)|(.app_id + ": " + .name + "\n" + (.rect.x | tostring) + "," + (.rect.y | tostring) + " " + (.rect.width | tostring) + "x" + (.rect.height | tostring))' |
    while read window_name; read geometry; do
      windows[$window_name]="$geometry"
    done

    echo ${windows[$(print -l ${(@k)windows} | myrofi)]}
}

main() {
  actions="Copy region to clipboard\nSave region to $PICTURES_DIR\nCopy window to clipboard\nSave window to $PICTURES_DIR"

  if [[ "$(swaymsg -t get_outputs | jq length)" == "1" ]]; then
    actions+="\nCopy screen to clipboard\nSave screen to $PICTURES_DIR"
  else
    actions+="\nCopy current monitor to clipboard\nSave current monitor to $PICTURES_DIR\nCopy all monitors to clipboard\nSave all monitors to $PICTURES_DIR"
  fi

  selection="$(echo "$actions" | myrofi -p "Take a screenshot")"

  filename="${PICTURES_DIR}/$(date +'screenshot_%F-%T.png')"
  case "$selection" in
    "Copy region to clipboard")
      grim -g "$(slurp)" - | wl-copy
      dunstify "Region copied to clipboard"
      ;;
    "Save region to $PICTURES_DIR")
      grim -g "$(slurp)" "$filename"
      reply=$(dunstify -A 'open,Open' -i "$filename" "Screenshot saved")
      ;;
    "Copy window to clipboard")
      grim -g "$(select_window)" - | wl-copy
      dunstify "Window copied to clipboard"
      ;;
    "Save window to $PICTURES_DIR")
      grim -g "$(select_window)" "$filename"
      reply=$(dunstify -A 'open,Open' -i "$filename" "Screenshot saved")
      ;;
    "Copy current monitor to clipboard")
      monitor="$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')"
      grim -o $monitor - | wl-copy
      dunstify "Monitor $monitor copied to clipboard"
      ;;
    "Save current monitor to $PICTURES_DIR")
      grim -o "$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')" "$filename"
      reply=$(dunstify -A 'open,Open' -i "$filename" "Screenshot saved")
      ;;
    "Copy screen to clipboard"|"Copy all monitors to clipboard")
      grim - | wl-copy
      dunstify "Screen copied to clipboard"
      ;;
    "Save screen to $PICTURES_DIR"|"Save all monitors to $PICTURES_DIR")
      grim "$filename"
      reply=$(dunstify -A 'open,Open' -i "$filename" "Screenshot saved")
      ;;
    *)
      exit 1
      ;;
  esac

  if [[ "$reply" == "2" ]]; then
    nautilus -s $filename
  fi
}

main "$@"