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

# Ensure REDIS_DATA_DIR is set and exists
export REDIS_DATA_DIR="${REDIS_DATA_DIR:-/home/node/redis-data}"
mkdir -p "$REDIS_DATA_DIR"

# Start Redis server in the background with proper configuration
redis-server --dir "$REDIS_DATA_DIR" --daemonize yes --stop-writes-on-bgsave-error no

# Start PostgreSQL in the background
export PGDATA="/home/node/pgdata"
export POSTGRES_USER="${POSTGRES_USER:-node}"
export POSTGRES_PASSWORD="${POSTGRES_PASSWORD:-changeme}"
export POSTGRES_DB="${POSTGRES_DB:-n8n}"
export POSTGRES_PORT="${POSTGRES_PORT:-5432}"

if [ ! -s "$PGDATA/PG_VERSION" ]; then
  echo "Initializing PostgreSQL data directory..."
  initdb --username="$POSTGRES_USER" --encoding=UTF8 --auth=trust
fi
echo "Starting PostgreSQL server..."
pg_ctl -D "$PGDATA" -o "-c listen_addresses='*' -p $POSTGRES_PORT" -w start

# Set password for the user
psql -U "$POSTGRES_USER" -d postgres -c "ALTER USER \"$POSTGRES_USER\" WITH PASSWORD '$POSTGRES_PASSWORD';" || true

# Create database if it doesn't exist
psql -U "$POSTGRES_USER" -d postgres -tc "SELECT 1 FROM pg_database WHERE datname = '$POSTGRES_DB'" | grep -q 1 || \
  psql -U "$POSTGRES_USER" -d postgres -c "CREATE DATABASE \"$POSTGRES_DB\";"

# Schedule backup every 5 minutes in background
while true; do
  sleep 300
  echo "Backing up n8n data to Dropbox..."
  rclone sync --checksum /home/node/.n8n dropbox:n8n-data
done &

# Start n8n
exec n8n