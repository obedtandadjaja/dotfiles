# Dotfiles
My dotfiles configuration.

## Configuration
* Prezto - https://github.com/sorin-ionescu/prezto
* neovim
* Alacritty
* fzf
* ag
* tmux

### Zsh

```
# check if you have zsh
zsh --version

# if not installed
brew install zsh

# check if it is already default shell
echo $SHELL

# set as default shell
chsh -s /bin/zsh
```

### Prezto

```
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

git clone https://github.com/zdharma/fast-syntax-highlighting ~/.zsh/fast-syntax-highlighting
```

### neovim

```
brew install neovim

# install ycm: https://github.com/ycm-core/YouCompleteMe#macos
```

### Python

```
brew install python

pip3 install --user neovim
```

### Tmux

```
# check if installed
tmux -V

brew install tmux
```

### Alacritty

```
brew cask install alacritty
```

### fzf / ag

```
brew install fzf
/usr/local/opt/fzf/install

brew install the_silver_searcher
brew install ripgrep
```

### zsh autocompletion

```
brew install zsh-autosuggestions
```

## Installation
Note: this command will replace all your settings with the setting in the repo!

```
chmod +x sync_to_local.sh
./sync_to_local.sh
```

## Backup
```
chmod +x sync_to_repo.sh
./sync_to_repo.sh
```
