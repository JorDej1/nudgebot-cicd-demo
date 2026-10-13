#!/bin/bash

set -e

APP_DIR="/home/dietpi/nudgebot"
VENV="$APP_DIR/.venv"
BRANCH="main"

cd "$APP_DIR"

echo "Checking GitHub for updates..."

git fetch origin "$BRANCH"

LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse "origin/$BRANCH")

if [ "$LOCAL" = "$REMOTE" ]; then
    echo "Already up to date."
    exit 0
fi

echo "New version detected."
echo "Local:  $LOCAL"
echo "Remote: $REMOTE"

git pull --ff-only origin "$BRANCH"

echo "Installing dependencies..."

"$VENV/bin/python" install -r "$APP_DIR/requirements.txt"

echo "Restarting NudgeBot..."

sudo systemctl restart nudge-bot

echo "Deployment complete! :)"
