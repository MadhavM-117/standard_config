# Standard Config

Hello there, welcome to my config repository. 

This is where I try to keep track of all the config files I require to recreate
the environment that I prefer to work in. There are quite a few things, that 
make life tolerable as a developer, and this is my attempt to try and recreate
their beauty each time I have to set up a new system. 

Here's the list of the best things in my environment:

- [i3](https://i3wm.org/)
- [i3status-rs](https://github.com/greshake/i3status-rust)
- [neovim](https://neovim.io/)
- [tmux](https://github.com/tmux/tmux/wiki)
- [vscode](https://code.visualstudio.com/)
- [zsh+ohmyzsh](https://ohmyz.sh/)

A couple of other things that make it what it is: 
- [JetBrains Mono (Font)](https://www.jetbrains.com/lp/mono/)
- [Powerline (Font)](https://github.com/powerline/fonts)
- [Font Awesome (Font)](https://fontawesome.com/)
  - [Ubuntu Package](https://launchpad.net/ubuntu/groovy/+package/fonts-font-awesome)

... that's all for now, but this list is still a work in progress, and I'll update it 
as I go. 

## Working with the configs

### Install Configs

Provided you have all the necessary software installed, you can install the configs 
in the repository to the required locations by running: 

```sh
make install
```

If you only want to update the config for a particular subset, you can go to the relevant 
directory and run the same command. 

```sh
cd {subset}
make install
```

### Update Configs

If you want to update the configs in the repository, with the ones currently being used in a machine, 
you can run: 

```sh
make update
```

Like the earlier scenario, you can also update it, per subset, if required with the following approach: 

```sh
cd {subset}
make update
```

## Pre-requisites

There are a couple installation things I didn't cover, which I will get around to 
simplifying eventually, but until then, I'll list them below for the sake of completeness. 

### Basic Installs

The basic requirements which can be installed through `apt` are expressed in the following command: 

```sh
sudo apt-get install -y \
		neovim build-essential software-properties-common python3 vim  apt-transport-https \
		i3 dunst blueman zsh libdbus-1-dev libssl-dev rofi
```

### NVM (Node Version Manager)

Node is usually a central part of any web development, and I've found that the ability 
to switch node versions depending on the project you're working on, is pretty important. 

Here's where `nvm` is just brilliant. 

You can find more details about it here: [Node Version Manager](https://github.com/nvm-sh/nvm)

At the time of writing this, however, it can be installed with a simple command: 

```sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
```

After installing `nvm`, you can install and use node like so: 

```sh
nvm install stable
nvm use stable
```

### Vim Plug

Managing plugins for all these different tools, and my neovim setup has quite a few. 
I'm currently using `Vim Plug` simply cause it was the first one I came across, 
and it's pretty straightforward to get started with, and use. 

You can find more details here: [Vim Plug](https://github.com/junegunn/vim-plug)

Again, at the time of writing this, vim plug can be installed with a simple command: 

```sh
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

### Visual Studio Code

Code is light-weight text editor which has become quite popular. It's extensions also give it enough
capability to compete with some of the larger IDEs. 

You can find more details here: [Visual Studio Code](https://code.visualstudio.com/docs/setup/linux)

You can install it by running the following commands: 

```sh
# Installing the signing key and source
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'

# Installing code
sudo apt-get update
sudo apt-get install code
```

### Rust and i3status-rs

`i3status-rs` is responsible for the nice-looking status bar that I prefer to use in i3. To install it, 
you need to compile it, for which you'll require [rust](https://www.rust-lang.org/)

Install rust here: 

```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

After installing rust, you can clone the [i3status-rs](https://github.com/greshake/i3status-rust) and install it:

```sh
git clone git@github.com:greshake/i3status-rust.git
cd i3status-rust
cargo build --release 
ln -s $(pwd)/target/release/i3status-rs $HOME/.local/bin/i3status-rs 
```

### OhMyZsh and Spaceship prompt

Both `omz` and the spaceship prompt really pushes zsh to another level. I haven't had much experience with it, 
but it's been pretty interesting so far. 

You can find more information about each here: 
- [OhMyZsh](https://ohmyz.sh/)
- [Spaceship Prompt](https://github.com/denysdovhan/spaceship-prompt)

Install OhMyZsh: 

```sh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Install Spaceship Prompt:

```sh
# This depends on node & npm already being installed on your system
npm install -g spaceship-prompt
```
