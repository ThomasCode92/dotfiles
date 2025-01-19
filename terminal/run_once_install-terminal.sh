#!/bin/sh

# Install fish, zsh and tmux
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt install fish
sudo apt install tmux

# Install asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0

# Change default shell to zsh
chsh -s $(which zsh)
