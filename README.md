# Standard Config

Hello there, welcome to my config repository. 
I should have named this repo `dotfiles`, but when I created this, I didn't fully appreciate what that meant. 
Now that I do, I might change it, I might not. For now, I appreciate the human element behind a break in the usual pattern of things.

This is where I try to keep track of all the config files I require to recreate the environment that I prefer to work in. 
There are quite a few things, that make life tolerable as a developer, and this is my attempt to try and recreate
their beauty each time I have to set up a new system. 

The most recent change I've made to my linux system is switching from i3 after years to hyprland.
It's definitely modernised a lot of my setup, but it's also made a few of my older configs not so relevant anymore.


## Working with the configs

I'm trying out [`stow`](https://www.gnu.org/software/stow/) to help me manage dotfiles.

This can be installed with: 
```sh
sudo apt install stow
```

To install the configs, it should be as straightforward as: 
```sh
stow <config_dir>

# For example, 
# stow tmux
```

> [!IMPORTANT]
> This requires this directory to be a direct child of your home directory. 
> This is because `stow` default target directory is the parent directory of the current directory. 

### Tmux

Tmux requires Tmux plugin manager to be setup. 

Follow instructions here: https://github.com/tmux-plugins/tpm

Then, run `stow tmux`
