#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# bash
echo "Linking bash config"
ln -f -s ${BASEDIR}/bash/bash_profile ~/.bash_profile
ln -f -s ${BASEDIR}/bash/bashrc ~/.bashrc

# spacemacs
echo "Linking spacemacs config"
ln -f -s ${BASEDIR}/emacs/spacemacs ~/.spacemacs

# powerline
echo "Linking powerline config"
mkdir -p ~/.config/powerline
ln -f -s ${BASEDIR}/powerline/config.json ~/.config/powerline/config.json

# git
echo "LInking git config"
ln -f -s ${BASEDIR}/git/gitconfig ~/.gitconfig

# tmux
echo "Linking tmux config"
ln -f -s ${BASEDIR}/tmux/tmux.conf ~/.tmux.conf
