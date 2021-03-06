#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# bash
echo "Linking bash config"
ln -f -s ${BASEDIR}/bash/bash_profile ~/.bash_profile
ln -f -s ${BASEDIR}/bash/bashrc ~/.bashrc
ln -f -s ${BASEDIR}/bash/bash_aliases ~/.bash_aliases

echo "Linking zsh config"
ln -f -s ${BASEDIR}/zsh/zshrc ~/.zshrc

# spacemacs
echo "Linking spacemacs config"
ln -f -s ${BASEDIR}/emacs/spacemacs ~/.spacemacs
echo "Linking custom private layer"
ln -f -s ${BASEDIR}/emacs/galexy ~/.emacs.d/private/galexy

# powerline
echo "Linking powerline config"
mkdir -p ~/.config/powerline
ln -f -s ${BASEDIR}/powerline/config.json ~/.config/powerline/config.json
ln -f -s ${BASEDIR}/powerline/themes ~/.config/powerline/themes

# git
echo "LInking git config"
ln -f -s ${BASEDIR}/git/gitconfig ~/.gitconfig

# tmux
echo "Linking tmux config"
ln -f -s ${BASEDIR}/tmux/tmux.conf ~/.tmux.conf

# local bin
echo "Linking local bin files"
ln -f -s ${BASEDIR}/bin/* ~/.local/bin

# ghci
echo "Linking GHCi configuration"
mkdir -p ~/.ghc/
ln -f -s ${BASEDIR}/ghc/ghci.conf ~/.ghc/ghci.conf

# readline
echo "Linking readline inputrc"
ln -f -s ${BASEDIR}/readline/inputrc ~/.inputrc
