#! /bin/bash
cp ./tmux.conf ~/.tmux.conf
cp -r ./tmux ~/.tmux
cp ./vimrc ~/.vimrc

# Sourcing tmux file, in case tmux is running
tmux source-file ~/.tmux.conf
echo "TMUX Configuration reloaded"

# Applying custom bashrc config
cat bashrc.sh > ~/.bashrc

# Fix vimrc file
# TODO: add code to modify VIMRC file as necessary
# ie, to ensure the version of vim, in the runtimepath is set correctly