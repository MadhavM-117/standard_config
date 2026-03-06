#!/bin/bash
# Install script for Obsidian Sync systemd user service
# This creates a user service that runs ob sync --continuous

set -e

VAULT_PATH="${1:-/home/y13/personal/obsidian/raaz}"
SERVICE_NAME="ob-sync@$(systemd-escape "$VAULT_PATH").service"

# Create user systemd directory if it doesn't exist
mkdir -p ~/.config/systemd/user/

# Copy service file
cp "$(dirname "$0")/ob-sync@.service" ~/.config/systemd/user/

echo "Installing Obsidian Sync service..."
echo "  Vault path: $VAULT_PATH"
echo "  Service: $SERVICE_NAME"

# Reload systemd daemon
systemctl --user daemon-reload

echo ""
echo "Service installed. To manage it, use:"
echo "  systemctl --user start '$SERVICE_NAME'    # Start the service"
echo "  systemctl --user stop '$SERVICE_NAME'     # Stop the service"
echo "  systemctl --user status '$SERVICE_NAME'   # Check status"
echo "  systemctl --user enable '$SERVICE_NAME'   # Enable on boot"
echo ""
echo "Or use the generic template with any vault path:"
echo "  systemctl --user start ob-sync@/path/to/vault.service"
