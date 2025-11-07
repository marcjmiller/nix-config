#!/usr/bin/env bash
# Usage: ./update-dmi.sh path/to/hexnode.nix
# Must run as root to read /sys/devices/virtual/dmi/id/*

set -euo pipefail

NIX_FILE=${1:-hexnode.nix}

if [ ! -f "$NIX_FILE" ]; then
  echo "File not found: $NIX_FILE"
  exit 1
fi

# Read real system values
SYSTEM_UUID=$(cat /sys/devices/virtual/dmi/id/product_uuid)
SYSTEM_SERIAL=$(cat /sys/devices/virtual/dmi/id/product_serial)

echo "Updating $NIX_FILE with real DMI values:"
echo "  UUID: $SYSTEM_UUID"
echo "  Serial: $SYSTEM_SERIAL"

# Use sed to replace the hardcoded values in the Nix file
sed -i -E "s|systemUUID = \".*\";|systemUUID = \"$SYSTEM_UUID\";|" "$NIX_FILE"
sed -i -E "s|systemSerial = \".*\";|systemSerial = \"$SYSTEM_SERIAL\";|" "$NIX_FILE"

echo "Done!"
