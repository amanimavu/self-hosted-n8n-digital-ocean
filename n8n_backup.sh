#!/bin/bash
set -euo pipefail
HOME=/home/amani

# Configuration
CONTAINER_NAME="n8n"
BACKUP_DIR="$HOME/n8n_backups/latest"
CONTAINER_BACKUP_DIR="/home/node/backups"

# 1. Ensure the local backup directories exists
mkdir -p "$BACKUP_DIR/workflows/" "$BACKUP_DIR/credentials/"

echo "Starting n8n overwrite backup..."

# 2. Force create backup directories inside the container first
docker exec -u node $CONTAINER_NAME mkdir -p "$CONTAINER_BACKUP_DIR/workflows/" "$CONTAINER_BACKUP_DIR/credentials/"

# 3. Export Workflows using --backup
# This creates separate files for each workflow in the folder
docker exec -u node $CONTAINER_NAME n8n export:workflow --backup --output="$CONTAINER_BACKUP_DIR/workflows/"
docker cp $CONTAINER_NAME:"$CONTAINER_BACKUP_DIR/workflows/." "$BACKUP_DIR/workflows/"

# 4. Export Credentials using --backup 
# This creates separate files for each credential in the folder
docker exec -u node $CONTAINER_NAME n8n export:credentials --backup --output="$CONTAINER_BACKUP_DIR/credentials/"
docker cp $CONTAINER_NAME:"$CONTAINER_BACKUP_DIR/credentials/." "$BACKUP_DIR/credentials/"

# 5. Clean up the temp folder inside the container to keep it light
docker exec -u node $CONTAINER_NAME rm -rf "$CONTAINER_BACKUP_DIR/workflows" "$CONTAINER_BACKUP_DIR/credentials"

echo "Backup synced to $BACKUP_DIR. Existing files were updated/overwritten."
