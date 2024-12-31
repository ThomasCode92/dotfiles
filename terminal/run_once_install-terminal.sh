#!/bin/sh

# Install asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0

# Install fish
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt install fish
sudo apt install tmux

# Install curl
sudo apt install curl

# Install starship
curl -sS https://starship.rs/install.sh | sh

# Change default shell to fish
chsh -s $(which fish)

# Install asdf plugins
mkdir -p ~/.config/fish/completions
ln -sf ~/.asdf/completions/asdf.fish ~/.config/fish/completions
