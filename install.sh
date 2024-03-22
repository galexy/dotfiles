#!/bin/bash

# Get an optional configuration to install
if [ -z "$1" ]; then
    echo "No configuration specified, installing all"
    CONFIG="all"
else
    CONFIG="$1"
fi

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# bash
if [ "$CONFIG" == "all" ] || [ "$CONFIG" == "bash" ]; then
    echo "Linking bash config"
    ln -f -s ${BASEDIR}/bash/bash_profile ~/.bash_profile
    ln -f -s ${BASEDIR}/bash/bashrc ~/.bashrc
    ln -f -s ${BASEDIR}/bash/bash_aliases ~/.bash_aliases
    ln -f -s ${BASEDIR}/bash/profile ~/.profile
fi

if [ "$CONFIG" == "all" ] || [ "$CONFIG" == "zsh" ]; then
    echo "Linking zsh config"
    mkdir -p ~/.zsh
    ln -f -s ${BASEDIR}/zsh/completion ~/.zsh/completion
    ln -f -s ${BASEDIR}/zsh/zshrc ~/.zshrc
    ln -f -s ${BASEIDR}/zsh/zshenv ~/.zshenv
    ln -f -s ${BASEDIR}/zsh/zprofile ~/.zprofile
fi

if [ "$CONFIG" == "all" ] || [ "$CONFIG" == "spacemacs" ]; then
    # spacemacs
    echo "Linking spacemacs config"
    ln -f -s ${BASEDIR}/emacs/spacemacs ~/.spacemacs
    echo "Linking custom private layer"
    ln -f -s ${BASEDIR}/emacs/galexy ~/.emacs.d/private/galexy
fi

# powerline
if [ "$CONFIG" == "all" ] || [ "$CONFIG" == "powerline" ]; then
    echo "Linking powerline config"
    mkdir -p ~/.config/powerline
    ln -f -s ${BASEDIR}/powerline/config.json ~/.config/powerline/config.json
    ln -f -s ${BASEDIR}/powerline/themes ~/.config/powerline/themes
fi

# git
if [ "$CONFIG" == "all" ] || [ "$CONFIG" == "git" ]; then
    echo "Linking git config"
    ln -f -s ${BASEDIR}/git/gitconfig ~/.gitconfig
fi

# tmux
if [ "$CONFIG" == "all" ] || [ "$CONFIG" == "tmux" ]; then
    echo "Linking tmux config"
    ln -f -s ${BASEDIR}/tmux/tmux.conf ~/.tmux.conf
fi

# local bin
if [ "$CONFIG" == "all" ] || [ "$CONFIG" == "bin" ]; then
    echo "Linking local bin files"
    ln -f -s ${BASEDIR}/bin/* ~/.local/bin
fi

# ghci
if [ "$CONFIG" == "all" ] || [ "$CONFIG" == "ghci" ]; then
    echo "Linking GHCi configuration"
    mkdir -p ~/.ghc/
    ln -f -s ${BASEDIR}/ghc/ghci.conf ~/.ghc/ghci.conf
fi

# readline
if [ "$CONFIG" == "all" ] || [ "$CONFIG" == "readline" ]; then
    echo "Linking readline inputrc"
    ln -f -s ${BASEDIR}/readline/inputrc ~/.inputrc
fi

# cargo
if [ "$CONFIG" == "all" ] || [ "$CONFIG" == "cargo" ]; then
    echo "Linking Cargo configuration"
    mkdir -p ~/.cargo
    ln -f -s ${BASEDIR}/cargo/env ~/.cargo/env
fi

# guile
if [ "$CONFIG" == "all" ] || [ "$CONFIG" == "guile" ]; then
    echo "Linking Guile Configuration"
    ln -f -s ${BASEDIR}/guile/guile ~/.guile
fi

# AWS cli
if [ "$CONFIG" == "all" ] || [ "$CONFIG" == "aws" ]; then
    echo "Linking AWS CLI Configuration"
    mkdir -p ~/.aws
    ln -f -s ${BASEDIR}/aws/config ~/.aws/config
fi

# cabal
if [ "$CONFIG" == "all" ] || [ "$CONFIG" == "cabal" ]; then
    echo "Linking Cabal Configuration"
    mkdir -p ~/.cabal
    ln -f -s ${BASEDIR}/cabal/config ~/.cabal/config
fi

# 1Password
if [ "$CONFIG" == "all" ] || [ "$CONFIG" == "1password" ]; then
    echo "Linking 1Password Configuration"
    mkdir -p ~/.config/1Password
    ln -f -s ${BASEDIR}/1Password/config.toml ~/.config/1Password/config.toml
fi
