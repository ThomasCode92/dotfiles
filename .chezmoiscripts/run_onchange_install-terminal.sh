#!/bin/sh

## Install packages
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt install fish

## Install Starship
if [ ! command -v starship &> /dev/null; ]; then
  echo "Starship is not installed. Installing now..."
  curl -sS https://starship.rs/install.sh | sh
else
  echo "Starship is already installed."
fi

## Install asdf
if [ ! -d "$HOME/.asdf" ]; then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.15.0
else
  echo "asdf is already installed."
fi
