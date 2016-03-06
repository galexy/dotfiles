export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

alias ls='ls -GFh'
alias dock='docker-machine restart default; eval "$(docker-machine env default)"'

export PATH="~/galex/bin:$PATH"
export PATH="/usr/local/activator:/usr/local/scala/bin:$PATH"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

export GNUTERM=X11

alias jump-prod="ssh galex@jump.remitly.com"
alias jump-dw="ssh galex@jump-dw.remitly.com"

alias dp="~/aws/datapipeline-cli/datapipeline --credentials ~/aws/creds.json"
alias tunnel-dw="ssh -L 5439:dw.ca5auwvlxrml.us-west-2.redshift.amazonaws.com:5439 -L 3389:10.1.0.7:3389 galex@jump-dw.remitly.com"

[ -s "/Users/galex/.nvm/nvm.sh" ] && . "/Users/galex/.nvm/nvm.sh" # This loads nvm

export JAVA_HOME=`/usr/libexec/java_home -v 1.7`

OPT_PREFIX="/Users/galex/opt"

export HADOOP_INSTALL="$OPT_PREFIX/hadoop"
export PATH="$PATH:$HADOOP_INSTALL/bin:$HADOOP_INSTALL/sbin"
export HADOOP_HOME=$HADOOP_INSTALL

# Setting PATH for Python 3.4
# The orginal version is saved in .bash_profile.pysave
#PATH="/Library/Frameworks/Python.framework/Versions/3.4/bin:${PATH}"
#export PATH

export ANT_HOME="/opt/apache-ant"
export PATH=$PATH:$ANT_HOME/bin

export M2_HOME=/opt/maven
export M2=$M2_HOME/bin
export PATH=$M2:$PATH

# Add GHC 7.8.4 to the PATH, via http://ghcformacosx.github.io/
export GHC_DOT_APP="/Applications/ghc-7.8.4.app"
if [ -d "$GHC_DOT_APP" ]; then
    export PATH="${HOME}/.cabal/bin:${GHC_DOT_APP}/Contents/bin:${PATH}"
fi

# added by Miniconda 3.16.0 installer
export PATH="/Users/galex/miniconda/bin:$PATH"

powerline-daemon -q
export POWERLINE_BASH_CONTINUATION=1
export POWERLINE_BASH_SELECT=1

source ~/miniconda/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh
