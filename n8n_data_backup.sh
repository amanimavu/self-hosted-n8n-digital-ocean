#!/bin/bash

set -euo pipefail

#set the HOME variable for the current shell session
HOME=/home/amani

# Navigate to your repository directory (optional: uncomment and set path)
REPO_DIR="$HOME/n8n_backups"
cd $REPO_DIR || { echo "Repo directory not found: $REPO_DIR"; exit 1; }

# 1. Get current date and time in a clean format
CURRENT_DATE_TIME=$(date +"%Y-%m-%d-%H:%M:%S")

# 2. Check if there are any changes (staged, unstaged, or untracked)
if [[ -n $(git status -s) ]]; then
    echo "Changes detected. Starting backup..."

    # 3. Add all changes
    git add .

    # 4. Commit with the required format
    COMMIT_MESSAGE="feat: backup-$CURRENT_DATE_TIME"
    git commit -m "$COMMIT_MESSAGE"

    # 5. Push to the current branch
    # Note: 'origin' is the default remote, 'main' is the typical branch name
    git push origin $(git rev-parse --abbrev-ref HEAD)

    echo "Backup complete: $COMMIT_MESSAGE"
else
    echo "No changes detected. Nothing to backup."
fi
