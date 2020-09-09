export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

export PATH=$PATH:$(go env GOPATH)/bin
export GOPATH=$(go env GOPATH)

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" 

source ~/git-completion.bash

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
