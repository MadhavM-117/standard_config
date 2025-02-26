set -e

# Basic tools to enable later installs
sudo apt update -y 
sudo apt upgrade -y 
sudo apt autoremove -y
sudo apt install git

# Get the standard_config repo
# Ensure the SSH credentials to access github have been setup already
# mkdir ~/personal && cd ~/personal && git clone https://github.com/MadhavM-117/standard_config.git --recurse-submodules -j8

sudo apt-get install -y \
	neovim build-essential software-properties-common python3 vim \
	apt-transport-https i3 dunst blueman zsh libdbus-1-dev \
	libssl-dev rofi curl

# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
# Configure NVM
source ~/.bashrc

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y 
source ~/.cargo/env
rustup install nightly

mkdir -p ~/.local/bin
echo "export PATH=$HOME/.local/bin:$PATH" >> ~/.bashrc

# Install i3status-rs
git clone https://github.com/greshake/i3status-rust.git
cd i3status-rust
cargo build --release 
ln -s $(pwd)/target/release/i3status-rs $HOME/.local/bin/i3status-rs 

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
npm install -g spaceship-prompt

# Install dependencies for st
sudo apt install -y libfreetype-dev libfontconfig-dev libx11-dev libxft-dev \
	autoconf xutils-dev libtool-bin xcompmgr


# Install vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim \
  	--create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Install VSCode  	
# Installing the signing key and source
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'

# Installing code
sudo apt-get update -y 
sudo apt-get install code -y 

# Clean-up
rm packages.microsoft.gpg



