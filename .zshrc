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

##########
# prompt #
##########

#autoload -U promptinit; promptinit
#PURE_CMD_MAX_EXEC_TIME=5
#prompt pure

#########
# theme #
#########

ZSH_THEME="agnoster"

#########
# pyenv #
#########

# eval "$(pyenv init -)"

#######
# nvm #
#######

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

####################
# git autocomplete #
####################

autoload -Uz compinit && compinit

#############
# functions #
#############

export TMP_FILE="temporary_file"

## Git ##
function cleanup_merged() {
  git branch --merged | grep -v "master" | grep -v "develop" > $TMP_FILE
  if [ -s "$TMP_FILE" ]; then
      vim $TMP_FILE
      xargs git branch -d < $TMP_FILE
      rm $TMP_FILE
  fi
}

function cleanup_local() {
  # Fetch latest, prunes remote
  git fetch -p
  # list branches that are no longer on remote
  git branch -vv | awk '/: gone]/{print $1}' >$TMP_FILE
  if [ -s "$TMP_FILE" ]; then
      vim $TMP_FILE
      xargs git branch -D <$TMP_FILE
      rm $TMP_FILE
  fi
}

## Get Fair public-api latest pod ##
function public_api_pod() {
  pod="$(k get pods | grep 'public-api' | head -1 | cat)";
  echo $pod;
  echo $pod | grep -Eo '^[^ ]+' | head -1 | tr -d '\n' | pbcopy;
}

## General ##
# Returns what app is running on specified port
function whichapp() {
  lsof -i tcp:$1
}
