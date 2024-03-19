#!/bin/sh

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0

sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt install fish

mkdir -p ~/.config/fish/completions; and ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions

chsh -s $(which fish)

sudo snap install --classic code
