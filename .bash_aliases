# Import constants
if [ -f ~/.bash_constants ]; then
    . ~/.bash_constants
fi

# ----------------------------------------------------------------------------
# Environment variables
# ----------------------------------------------------------------------------

# Set locales
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export PYTHONIOENCODING=UTF-8   # http://stackoverflow.com/a/6361471/1054939

# Tell 'ls' to be colorful
export CLICOLOR=1
export LSCOLORS="GxFxCxDxBxegedabagacedx"
pgb() {
    # Show git branch
    git branch --no-color | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/' -e 's/(master)//'
}
export PS1='\n\[\033[01;35m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w\[\033[33m\]$(pgb)\[\033[00m\]\$ '


# ----------------------------------------------------------------------------
# Aliases
# ----------------------------------------------------------------------------

alias sourceb="source ~/.bashrc"

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ..2='cd ../..'
alias ..3='cd ../../..'
alias ..4='cd ../../../..'
alias ..5='cd ../../../../..'

alias agi="ag --ignore-dir"
alias duh='du -d 0 -h'
alias duhs='du -hs * | gsort -h'
alias e2u="iconv -f euckr -t utf8"
alias ports="lsof -Pn -i4 | grep LISTEN"
alias rm='rm -i'
alias rmed='find . -type d -empty -delete'
# for many small files
alias rscp="rsync -r --ignore-existing --progress --rsh=ssh"
# for a few big files
alias rscpb="rsync -r --partial --progress --rsh=ssh"
alias tl='tree -L 2'

# ----------------------------------------------------------------------------
# App specific
# ----------------------------------------------------------------------------

# bleu
alias bleulook="sed 's/[_a-zA-Z]* *= *//g; s/)//g; s/\//,/g; s/ (/,/g' | csvsort -r -c bleu | csvlook"
alias bleubar="sed 's/[_a-zA-Z]* *= *//g; s/)//g' | csvsort -r -c bleu | csvcut -c engine,bleu | tail -n +2 | sed 's/,/ /' | bar_chart.py -Avr -m 100"

# c
export LD_LIBRARY_PATH="/usr/local/lib"

# dbs
alias start_mongo='mongod --fork'
alias stop_mongo='killall -SIGTERM mongod 2>/dev/null'
alias status_mongo="killall -0 mongod 2>/dev/null; if [ \$? -eq 0 ]; then echo 'started'; else echo 'stopped'; fi"
alias start_pg='pg_ctl -D /usr/local/var/postgres -l logfile start'
alias stop_pg='pg_ctl -D /usr/local/var/postgres stop -s -m fast'
alias status_pg='pg_ctl -D /usr/local/var/postgres status'

# fasd
alias s='fasd -si'                      # show / search / select
alias c='fasd_cd -b current'            # cd in current folder
alias cc='fasd_cd -b current -i'        # cd in current folder (interactive)
alias v='fasd -e vim -b current'        # open file in current folder
alias vv='fasd -e vim -b current -i'    # open file in current folder (interactive)
alias zz='fasd_cd -d -i'                # global cd (interactive)
eval "$(fasd --init auto)"
. ~/.fasdrc
alias f="open ." # overwrite f
alias emem="sudo bash -c 'sync; echo 1 > /proc/sys/vm/drop_caches'"

# gae
alias gae='dev_appserver.py --port=8192 .'
alias gaeup='appcfg.py update .'

# github/gist
alias gistc='git clone git@gist.github.com:'
alias gistup="gistup --private --"

# nvm
export NVM_DIR="$HOME/.nvm"
# NOTE: The following line is VERY SLOW
alias sourcen='. "$(brew --prefix nvm)/nvm.sh"'

# python
alias pyserv='python -m SimpleHTTPServer'
alias profile='python -m cProfile'
alias profilec='python -m cProfile --sort=cumulative'
#alias python='hilite time python'
alias python3='time python3'
# https://github.com/daleroberts/itermplot
export MPLBACKEND="module://itermplot"
export ITERMPLOT="rv"

# tmux
#alias tmux_clean="tmux kill-session -a -t `tmux display-message -p "#S"`"
alias tmux_rw="tmux rename-window"
alias ta="tmux attach || tmux"

# Spark
export SPARK_HOME="$HOME/dev/pkgs/spark-2.0.0-bin-hadoop2.7"
PATH=$PATH:$SPARK_HOME/bin

# SCM Breeze
[ -s "$HOME/.scm_breeze/scm_breeze.sh" ] && source "$HOME/.scm_breeze/scm_breeze.sh"

# rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
# export RBENV_ROOT=/usr/local/opt/rbenv

# [virtualenvwrapper](https://virtualenvwrapper.readthedocs.org/en/latest/)
# export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
# export WORKON_HOME=~/envs
# mkdir -p $WORKON_HOME
# source /usr/local/bin/virtualenvwrapper.sh

# [autoenv](https://github.com/kennethreitz/autoenv)
# source `which activate.sh`
alias e="workon venv"
# activate venv every time there is a file named .env in pwd
if [ -f "$PWD/.env" ]; then
    if [ -z "$VIRTUAL_ENV" ]; then workon venv; fi
fi
alias da="deactivate"

# ----------------------------------------------------------------------------
# Misc
# ----------------------------------------------------------------------------

# bash history logging

if [ -f "$HOME/.logs" ]; then
    export HISTCONTROL=ignoredups:erasedups
    shopt -s histappend
    export PROMPT_COMMAND='if [ "$(id -u)" -ne 0 ]; then echo "$(date "+%Y-%m-%d.%H:%M:%S") $(pwd) $(history 1)" >> ~/.logs/bash-history-$(date "+%Y-%m-%d").log; fi'
fi

# os specific
if [ "$(uname)" == "Darwin" ]; then
    . ~/.bash_macosx
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    . ~/.bash_linux
# elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
fi
