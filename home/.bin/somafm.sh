#!/usr/bin/env bash
set -euo pipefail

CHANNELS_URL="https://somafm.com/channels.json"
CACHE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/somafm/channels.json"
CACHE_TTL=86400 # 24 hours in seconds

# Pick an available media player
if command -v mpv >/dev/null 2>&1; then
  PLAYER="mpv"
elif command -v ffplay >/dev/null 2>&1; then
  PLAYER="ffplay"
else
  echo "Error: Please install 'mpv' or 'ffplay' to stream audio." >&2
  exit 1
fi

# Ensure jq and curl are available
for cmd in curl jq; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: '$cmd' is required but not installed." >&2
    exit 1
  fi
done

mkdir -p "$(dirname "$CACHE_FILE")"

fetch_channels() {
  local force="${1:-false}"
  if [[ "$force" == "true" || ! -f "$CACHE_FILE" || $(( $(date +%s) - $(stat -c %Y "$CACHE_FILE" 2>/dev/null || stat -f %m "$CACHE_FILE") )) -gt $CACHE_TTL ]]; then
    curl -fsSL "$CHANNELS_URL" -o "$CACHE_FILE"
  fi
}

list_channels() {
  jq -r '.channels[] | "\(.id)\t\(.title) — \(.description)"' "$CACHE_FILE" | sort
}

get_stream_url() {
  local channel_id="$1"
  local quality="${2:-highest}"

  # Prefer MP3 or AAC streams matching requested quality, falling back to any stream
  jq -r --arg id "$channel_id" --arg q "$quality" '
    .channels[]
    | select(.id == $id or (.id | ascii_downcase) == ($id | ascii_downcase))
    | .playlists
    | (
        map(select(.format == "mp3" and .quality == $q))[0].url //
        map(select(.format == "aac" and .quality == $q))[0].url //
        map(select(.format == "mp3"))[0].url //
        .[0].url
      )
  ' "$CACHE_FILE"
}

play_channel() {
  local channel_id="$1"
  local quality="${2:-highest}"
  local pls_url

  pls_url="$(get_stream_url "$channel_id" "$quality")"
  if [[ -z "$pls_url" || "$pls_url" == "null" ]]; then
    echo "Error: Channel '$channel_id' not found." >&2
    exit 1
  fi

  # Extract first stream URI from .pls playlist
  local stream_url
  stream_url="$(curl -fsSL "$pls_url" | awk -F= '/^File1=/{print $2; exit}' | tr -d '\r')"
  stream_url="${stream_url:-$pls_url}"

  echo "Tuning into '$channel_id' ($quality) via $PLAYER... (Ctrl+C to stop)"
  if [[ "$PLAYER" == "mpv" ]]; then
    mpv --no-video --quiet "$stream_url"
  else
    ffplay -nodisp -loglevel error "$stream_url"
  fi
}

interactive_select() {
  local selection
  if command -v fzf >/dev/null 2>&1; then
    selection="$(list_channels | fzf --height=50% --prompt="SomaFM > " | cut -f1)"
  else
    mapfile -t lines < <(list_channels)
    for i in "${!lines[@]}"; do
      printf "%2d) %s\n" "$((i + 1))" "${lines[$i]}"
    done
    read -rp "Select channel number: " num
    selection="$(printf "%s\n" "${lines[$((num - 1))]}" | cut -f1)"
  fi

  [[ -n "${selection:-}" ]] && play_channel "$selection" "${1:-highest}"
}

usage() {
  cat <<'EOF'
Usage:
  soma.sh                 Interactive channel picker (uses fzf if available)
  soma.sh list            List all SomaFM channels
  soma.sh refresh         Force-refresh the cached channel list
  soma.sh <channel_id> [low|high|highest]
                          Play a channel by ID (e.g., groovesalad, defcon, dronezone)
EOF
}

case "${1:-}" in
  -h|--help)
    usage
    ;;
  list|ls)
    fetch_channels
    list_channels
    ;;
  refresh)
    fetch_channels true
    echo "Channel cache updated."
    ;;
  "")
    fetch_channels
    interactive_select
    ;;
  *)
    fetch_channels
    play_channel "$1" "${2:-highest}"
    ;;
esac