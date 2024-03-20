#!/bin/sh

# Install asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0

# Install fish
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt install fish

# Install starship
curl -sS https://starship.rs/install.sh | sh

# Change default shell to fish
chsh -s $(which fish)

# Install asdf plugins
mkdir -p ~/.config/fish/completions; and ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions

# Install VS Code
sudo snap install --classic code
