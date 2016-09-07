export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

alias ls='ls -GFh'

export PATH="~/galex/bin:$PATH"

export GNUTERM=X11

alias jump-prod="ssh galex@jump.remitly.com"

export JAVA_HOME=`/usr/libexec/java_home -v 1.7`

OPT_PREFIX="/Users/galex/opt"

powerline-daemon -q
export POWERLINE_BASH_CONTINUATION=1
export POWERLINE_BASH_SELECT=1

source .nix-profile/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh
export PATH=$HOME/.local/bin:$PATH
