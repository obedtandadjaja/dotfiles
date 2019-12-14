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

echo "moving .zprofile..."
cp ./.zprofile ~/.
echo "done"

echo "moving .bashrc..."
cp ./.bashrc ~/.
echo "done"

echo "moving .bash_profile..."
cp ./.bash_profile ~/.
echo "done"

echo "moving .git_cleanup.bash..."
cp ./.git_cleanup.bash ~/.
echo "done"
