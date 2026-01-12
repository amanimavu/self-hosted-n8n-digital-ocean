#!/bin/bash

# Configuration
CONTAINER_NAME="n8n"
BACKUP_DIR="$HOME/n8n_backups/latest"

# 1. Ensure the directory exists
mkdir -p "$BACKUP_DIR"

echo "Starting n8n overwrite backup..."

# 2. Force create the directory inside the container first
docker exec -u node $CONTAINER_NAME mkdir -p /home/node/backups/

# 3. Export Workflows using --backup
# This creates separate files for each workflow in the folder
docker exec -u node $CONTAINER_NAME n8n export:workflow --backup --output=/home/node/backups/
docker cp $CONTAINER_NAME:/home/node/backups/. "$BACKUP_DIR/"

# 4. Export Credentials using --backup 
# This creates separate files for each credential in the folder
docker exec -u node $CONTAINER_NAME n8n export:credentials --backup --output=/home/node/backups/
docker cp $CONTAINER_NAME:/home/node/backups/. "$BACKUP_DIR/"

# 5. Clean up the temp folder inside the container to keep it light
docker exec -u node $CONTAINER_NAME rm -rf /home/node/backups/*

echo "Backup synced to $BACKUP_DIR. Existing files were updated/overwritten."
