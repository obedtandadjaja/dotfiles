# Executes commands at the start of an interactive session.
# Author: Obed Tandadjaja

##########
# Prezto #
##########

if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

###########
# aliases #
###########

alias ..="cd .."
alias cf="cd /Users/obedt/code"
alias cgo="cd $GOPATH"
alias k="kubectl"
alias be="bundle exec"
alias public-api-pod="k get pods | grep 'public-api' | head -1 | cat; k get pods | grep 'public-api' | head -1 | grep -Eo '^[^ ]+' | head -1 | tr -d '\n' | pbcopy"

##########
# prompt #
##########

autoload -U promptinit; promptinit
prompt pure

#########
# PATHS #
#########

export PATH=./node_modules/.bin:$PATH
export PGDATA=/usr/local/var/postgres
export GOPATH="/Users/obedt/go"
export PATH="$PATH:$GOPATH/bin"

#########
# pyenv #
#########

eval "$(pyenv init -)"

#######
# nvm #
#######

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

####################
# git autocomplete #
####################

autoload -Uz compinit && compinit

#######
# RVM #
#######

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

