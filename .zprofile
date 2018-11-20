 commands at login pre-zshrc.
# Author: Obed Tandadjaja

# Browser
if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

# Editors
export EDITOR='vi'
export VISUAL='vi'
export PAGER='less'

# Language
if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

# Paths
# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Set the list of directories that Zsh searches for programs.
path=(
  /usr/local/{bin,sbin}
  $path
)

# Less
# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -X -z-4'

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

source ~/git-completion.bash

export GITHUB_OAUTH_TOKEN="0d767a224aa6baf1ad49acfe658d937f26f69d57"
export BUNDLE_GEMS__CONTRIBSYS__COM="91f7eb26:c35856ff"
export GOPATH="/Users/obedt/go"
export PATH="$PATH:$GOPATH/bin"
export CLICOLOR=1

alias ..="cd .."
alias cf="cd /Users/obedt/code"
alias cgo="cd $GOPATH"
alias gofair="cd $GOPATH/src/github.com/wearefair"
alias k="kubectl"
alias be="bundle exec"
alias public-api-pod="k get pods | grep 'public-api' | head -1 | cat; k get pods | grep 'public-api' | head -1 | grep -Eo '^[^ ]+' | head -1 | tr -d '\n' | pbcopy"

# fo [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fo() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

