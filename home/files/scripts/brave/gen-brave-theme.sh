#!/usr/bin/env bash

set -euo pipefail

theme_dir="${HOME}/.local/share/brave-theme"
stylix_json="${HOME}/.config/stylix/generated.json"
manifest="${theme_dir}/manifest.json"
key_file="${theme_dir}/key.pem"

mkdir -p "$theme_dir"

# Generate a consistent private key if it doesn't exist
# This ensures the extension ID stays the same
if [ ! -f "$key_file" ]; then
    openssl genrsa -out "$key_file" 2048 2>/dev/null
fi

# Function to convert hex to RGB array
hex_to_rgb() {
    local hex=$1
    # Remove # if present
    hex=${hex#"#"}
    # Convert to RGB values
    local r=$((16#${hex:0:2}))
    local g=$((16#${hex:2:2}))
    local b=$((16#${hex:4:2}))
    echo "[$r, $g, $b]"
}

# Read colors from Stylix JSON
BG_HEX=$(jq -r '.base00' "$stylix_json")
FG_HEX=$(jq -r '.base05' "$stylix_json")
ACCENT_HEX=$(jq -r '.base0D' "$stylix_json")
INACTIVE_HEX=$(jq -r '.base03' "$stylix_json")

# Convert to RGB arrays
BG=$(hex_to_rgb "$BG_HEX")
FG=$(hex_to_rgb "$FG_HEX")
ACCENT=$(hex_to_rgb "$ACCENT_HEX")
INACTIVE=$(hex_to_rgb "$INACTIVE_HEX")

cat > "$manifest" <<EOF
{
  "manifest_version": 2,
  "name": "Stylix Brave Theme",
  "version": "1.0",
  "description": "Auto-generated theme from Stylix colors",
  "key": "$(openssl rsa -in "$key_file" -pubout -outform DER 2>/dev/null | base64 -w 0)",
  "theme": {
    "colors": {
      "frame": $BG,
      "frame_inactive": $INACTIVE,
      "frame_incognito": $BG,
      "frame_incognito_inactive": $INACTIVE,
      "toolbar": $BG,
      "tab_text": $FG,
      "tab_background_text": $FG,
      "bookmark_text": $FG,
      "ntp_background": $BG,
      "ntp_text": $FG,
      "button_background": $ACCENT
    },
    "tints": {
      "buttons": $ACCENT
    }
  }
}
EOF

# Calculate and display the extension ID
extension_id=$(openssl rsa -in "$key_file" -pubout -outform DER 2>/dev/null | sha256sum | head -c32 | tr '0-9a-f' 'a-p')
echo "Brave theme generated at: $theme_dir"
echo "Extension ID: $extension_id"
echo "Add this ID to your Nix config: \"$extension_id\""
