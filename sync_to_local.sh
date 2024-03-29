#!/bin/bash

echo "Moving dot-files from repo to local"

echo "Moving .vimrc..."
cp ./.vimrc ~/.
echo "Done"

echo "moving .spacemacs..."
cp ./.spacemacs ~/.
echo "done"

echo "moving .gitconfig..."
cp ./.gitconfig ~/.
echo "done"

echo "moving .zshrc..."
cp ./.zshrc ~/.
echo "done"

echo "moving .zpreztorc..."
cp ./.zpreztorc ~/.
echo "done"

echo "moving .bashrc..."
cp ./.bashrc ~/.
echo "done"

echo "moving .tmux.conf..."
cp ./.tmux.conf ~/.
echo "done"

echo "moving .tmux.conf.local..."
cp ./.tmux.conf.local ~/.
echo "done"

echo "moving .agingore..."
cp ./.agignore ~/.

echo "moving alacritty.yml..."
cp ./alacritty.yml ~/.config/alacritty/

echo "moving nvim/init.vim..."
cp ./nvim/init.vim ~/.config/nvim/init.vim

echo "moving lvim..."
cp -R ./lvim ~/.config/lvim
