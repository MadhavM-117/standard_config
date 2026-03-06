# Obsidian Sync Systemd Service

A systemd user service template for running `ob sync --continuous` in the background.

## Overview

This template allows you to run the Obsidian sync command continuously as a systemd user service, with proper nvm environment setup.

## Files

- `ob-sync@.service` - The systemd service template
- `install-ob-sync-service.sh` - Installation helper script

## Quick Install

```bash
./install-ob-sync-service.sh /home/y13/personal/obsidian/raaz
```

## Manual Setup

1. Copy the service file to your user systemd directory:
   ```bash
   mkdir -p ~/.config/systemd/user/
   cp ob-sync@.service ~/.config/systemd/user/
   ```

2. Reload systemd:
   ```bash
   systemctl --user daemon-reload
   ```

3. Start the service for your vault:
   ```bash
   # Escape the path properly for systemd
   systemctl --user start "ob-sync@$(systemd-escape '/home/y13/personal/obsidian/raaz').service"
   ```

## Usage

### Start the service
```bash
systemctl --user start "ob-sync@$(systemd-escape '/home/y13/personal/obsidian/raaz').service"
```

### Stop the service
```bash
systemctl --user stop "ob-sync@$(systemd-escape '/home/y13/personal/obsidian/raaz').service"
```

### Check status
```bash
systemctl --user status "ob-sync@$(systemd-escape '/home/y13/personal/obsidian/raaz').service"
```

### Enable auto-start on login
```bash
systemctl --user enable "ob-sync@$(systemd-escape '/home/y13/personal/obsidian/raaz').service"
```

### View logs
```bash
journalctl --user -u "ob-sync@$(systemd-escape '/home/y13/personal/obsidian/raaz').service" -f
```

## How It Works

The service template uses systemd's instance feature (`@`) where `%I` is replaced with the vault path. This allows you to run multiple sync services for different vaults.

The service:
- Sets `PATH` to include the nvm binary directory
- Restarts automatically on failure
- Runs as your user (no sudo required)

## Template Variables

You can customize the service by editing `ob-sync@.service`:

- `Environment="PATH=..."` - Set the path to include nvm binaries
- `RestartSec=10` - Delay before restart on failure
- Add additional `Environment=` lines for other variables