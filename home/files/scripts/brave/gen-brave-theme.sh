#!/usr/bin/env bash

set -euo pipefail

theme_dir="${HOME}/.local/share/brave-theme"
stylix_json="${HOME}/.config/stylix/generated.json"
manifest="${theme_dir}/manifest.json"

mkdir -p "$theme_dir"

# Read colors from Stylix JSON
BG=$(jq -r '.base00' "$stylix_json")
FG=$(jq -r '.base05' "$stylix_json")
ACCENT=$(jq -r '.base0D' "$stylix_json")

cat > "$manifest" <<EOF
{
  "manifest_version": 2,
  "name": "Stylix Brave Theme",
  "version": "1.0",
  "theme": {
    "colors": {
      "frame": "$BG",
      "toolbar": "$BG",
      "tab_text": "$FG",
      "bookmark_text": "$FG",
      "ntp_background": "$BG",
      "ntp_text": "$FG",
      "accentcolor": "$ACCENT",
      "button_background": "$ACCENT"
    }
  }
}
EOF
