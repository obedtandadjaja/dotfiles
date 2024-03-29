# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Executes commands at the start of an interactive session.
# Author: Obed Tandadjaja

##########
# Prezto #
##########

if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

########
# tmux #
########

work() { tmux new-session -A -s ${1:-work}; }

export TERM=screen-256color
alias tmux="tmux -2"
if [ "$TMUX" = "" ]; then work; fi

#######
# vim #
#######

alias vim="nvim"

##########
# golang #
##########

export GOPATH=$HOME/go
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin
export PATH="$HOME/.cargo/bin:$PATH"
export EDITOR="nvim"
export VISUAL="nvim"

###########
# flutter #
###########

export PATH="$PATH:/Users/obedt/code/flutter/bin"

###########
# aliases #
###########

alias ..="cd .."
alias cf="cd /Users/obedt/code"
alias cgo="cd $GOPATH"
alias k="kubectl"
alias be="bundle exec"
# Note that this only works on Mac
alias apply_gitignore="git ls-files -ci --exclude-standard -z | xargs -0 git rm --cached"

###########
# kubectl #
###########

source <(kubectl completion zsh)
export PATH="/Users/obedt/google-cloud-sdk/bin:$PATH"

##########
# prompt #
##########

#autoload -U promptinit; promptinit
#PURE_CMD_MAX_EXEC_TIME=5
#prompt pure

#########
# theme #
#########

# ZSH_THEME="agnoster"
source ~/powerlevel10k/powerlevel10k.zsh-theme
ZSH_THEME="powerlevel10k/powerlevel10k"

#########
# pyenv #
#########

# eval "$(pyenv init -)"

#######
# nvm #
#######

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

#############
# functions #
#############

export TMP_FILE="temporary_file"

## Git ##
function cleanup_merged() {
  git branch --merged | grep -v "master" | grep -v "dev" > $TMP_FILE
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

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/obedtandadjaja/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/obedtandadjaja/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/obedtandadjaja/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/obedtandadjaja/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

###########
# General #
###########

# ignore duplicated history
setopt histignorealldups

# share history between multiple instances of zsh
setopt sharehistory

# keep 10000 lines of history within shell and save it to ~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# use modern completion system
autoload -Uz compinit
compinit

# completion configuration
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

# completion kill process
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# syntax highlighting
[ -f ~/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ] && source ~/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# enables fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# enables zsh-history-substring-search
source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey "$terminfo[cuu1]" history-substring-search-up
bindkey "$terminfo[cud1]" history-substring-search-down

plugins=(history-substring-search fast-syntax-highlighting fzf)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
