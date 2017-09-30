#! /bin/bash
cp ./tmux.conf ~/.tmux.conf
cp -r ./tmux ~/.tmux
cp ./vimrc ~/.vimrc

# Sourcing tmux file, in case tmux is running
tmux source-file ~/.tmux.conf
echo "TMUX Configuration reloaded"
