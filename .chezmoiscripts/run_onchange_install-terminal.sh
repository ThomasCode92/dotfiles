#!/bin/sh

## Install packages
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt install fish
sudo apt install fd-find
sudo apt install bat

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

## Configure bat
if [ ! -f "$HOME/.local/bin/bat" ]; then
  mkdir -p ~/.local/bin
  ln -s /usr/bin/batcat ~/.local/bin/bat
else
  echo "bat was already configured."
fi
