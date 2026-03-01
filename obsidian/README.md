# Obsidian Config

## Files

**`@raaz.obsidian.sync.plist`** — macOS LaunchAgent for continuous vault sync via `ob sync`

- Runs on login, auto-restarts if it crashes
- Logs to `/tmp/obsidian-sync*.log`

**`vimrc`** — Obsidian vim bindings (used by the vimrc plugin)

- `jk` → escape
- `j/k` navigate visual lines
- `zo/zc/za` toggle folds
- `zR/zM` unfold/fold all

## Install LaunchAgent

```bash
cp @raaz.obsidian.sync.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/@raaz.obsidian.sync.plist
```
