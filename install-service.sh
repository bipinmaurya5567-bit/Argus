#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVICE_FILE="$SCRIPT_DIR/argus-ui.service"

if [ ! -f "$SERVICE_FILE" ]; then
  echo "Error: argus-ui.service not found in $SCRIPT_DIR"
  exit 1
fi

echo "Installing Argus UI service..."
echo "Make sure you've edited argus-ui.service with your username and paths first!"
echo ""

sudo cp "$SERVICE_FILE" /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable argus-ui
sudo systemctl start argus-ui
sudo systemctl status argus-ui
