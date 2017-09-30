#! /bin/bash
if [ "$1" = "-r" ]
then 
    rm -rf ./tmux
    rm ./tmux.conf
    rm ./vimrc
fi

cp ~/.tmux.conf ./tmux.conf
cp -r ~/.tmux ./tmux
cp ~/.vimrc ./vimrc

tar -zcf  ~/personal_conf.tar.gz ~/personal_conf


