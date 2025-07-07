#!/bin/sh

set -e

# Set rclone config directory
export RCLONE_CONFIG_DIR="/home/pocketbase/.config/rclone"

# Prepare rclone config
mkdir -p "$RCLONE_CONFIG_DIR"
if [ -n "$RCLONE_CONF_TEXT" ]; then
  echo "Using provided RCLONE_CONF_TEXT for rclone.conf"
  echo "$RCLONE_CONF_TEXT" > "$RCLONE_CONFIG_DIR/rclone.conf"
else
  echo "RCLONE_CONF_TEXT is not set. Exiting."
  exit 1
fi

# Restore PocketBase data from Dropbox if available
if rclone ls dropbox:pocketbase-data >/dev/null 2>&1; then
  echo "Restoring PocketBase data from Dropbox..."
  rclone sync --checksum dropbox:pocketbase-data /pb_data
else
  echo "No backup found on Dropbox. Skipping restore."
fi

# Schedule backup every 5 minutes in background
while true; do
  sleep 300
  echo "Backing up PocketBase data to Dropbox..."
  rclone sync --checksum /pb_data dropbox:pocketbase-data
done &

# Start PocketBase
exec pocketbase serve --http=0.0.0.0:8090
