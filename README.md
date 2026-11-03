# Standard Config

Hello there, welcome to my config repository. 
I should have named this repo `dotfiles`, but when I created this, I didn't fully appreciate what that meant. 
Now that I do, I might change it, I might not. For now, I appreciate the human element behind a break in the usual pattern of things.

This is where I try to keep track of all the config files I require to recreate the environment that I prefer to work in. 
The desktop side of things is [Omarchy](https://omarchy.org) (Hyprland + Waybar + friends); this repo only carries my **overrides** on top of Omarchy's defaults, not Omarchy itself. Anything that's identical to an Omarchy default is deliberately left out.

## Packages

| Package | Contents |
|---|---|
| `zsh` | `~/.zshrc` + `~/.zaliases` (aliases & functions: `tns`, `notes`, `notes-sync`, git/tmux shortcuts). The Obsidian vault path (`VAULT`) is set per machine in `.zshrc`. |
| `kitty` | `~/.config/kitty/kitty.conf` — overrides on top of Omarchy's kitty defaults |
| `tmux` | `~/.config/tmux/tmux.conf` |
| `hypr` | `~/.config/hypr/` — Hyprland lua config, idle/sunset/lock settings |
| `omarchy` | `~/.config/omarchy/` — bar layout, menu extensions, custom workspace plugin, branding |
| `obsidian` | ob-sync systemd service for syncing the Obsidian vault |

## Working with the configs

I'm trying out [`stow`](https://www.gnu.org/software/stow/) to help me manage dotfiles.

This can be installed with: 
```sh
sudo pacman -S stow
```

To install the configs, run from the repo root: 
```sh
stow -t ~ <config_dir>

# For example, 
# stow -t ~ tmux
```

> [!IMPORTANT]
> The `-t ~` matters: this repo lives in `~/personal/`, and `stow` defaults to the parent directory of the current directory as its target. Without `-t ~` it would try to link into `~/personal/`.

> [!NOTE]
> The symlinks already on this machine were created manually in exactly the layout `stow` produces, so `stow` (v2.3+) will happily adopt or restow them.

### Tmux

Tmux requires Tmux plugin manager to be setup. 

Follow instructions here: https://github.com/tmux-plugins/tpm

Then, run `stow -t ~ tmux`
