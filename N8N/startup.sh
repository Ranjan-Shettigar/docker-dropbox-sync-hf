#!/bin/sh

set -e

# Set rclone config directory
export RCLONE_CONFIG_DIR="/home/node/.config/rclone"

# Prepare rclone config
mkdir -p "$RCLONE_CONFIG_DIR"
if [ -n "$RCLONE_CONF_TEXT" ]; then
  echo "Using provided RCLONE_CONF_TEXT for rclone.conf"
  echo "$RCLONE_CONF_TEXT" > "$RCLONE_CONFIG_DIR/rclone.conf"
else
  echo "RCLONE_CONF_TEXT is not set. Exiting."
  exit 1
fi

# Restore n8n data from Dropbox if available
if rclone ls dropbox:n8n-data >/dev/null 2>&1; then
  echo "Restoring n8n data from Dropbox..."
  rclone sync --checksum dropbox:n8n-data /home/node/.n8n
else
  echo "No backup found on Dropbox. Skipping restore."
fi

# Schedule backup every 5 minutes in background
while true; do
  sleep 300
  echo "Backing up n8n data to Dropbox..."
  rclone sync --checksum /home/node/.n8n dropbox:n8n-data
done &

# Start n8n
exec n8n