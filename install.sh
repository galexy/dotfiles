#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# bash
ln -s ${BASEDIR}/bash/bash_profile ~/.bash_profile
ln -s ${BASEDIR}/bash/bashrc ~/.bashrc

# spacemacs
ln -s ${BASEDIR}/emacs/spacemacs ~/.spacemacs

