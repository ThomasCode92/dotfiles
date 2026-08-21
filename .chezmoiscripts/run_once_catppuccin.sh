#!/bin/bash

echo "🦇 Setting up bat..."
mkdir -p "$(bat --config-dir)/themes"
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
bat cache --build

echo "🐶  Setting up k9s"
if [ "$(uname -s)" = "Darwin" ]; then
  OUT="${XDG_CONFIG_HOME:-$HOME/Library/Application Support}/k9s/skins"
else
  OUT="${XDG_CONFIG_HOME:-$HOME/.config}/k9s/skins"
fi
mkdir -p "$OUT"
curl -L https://github.com/catppuccin/k9s/archive/main.tar.gz |
  tar xz -C "$OUT" --strip-components=2 k9s-main/dist

echo "🎨 Setting up tmux"
DIR="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/plugins/catppuccin/tmux"
rm -rf "$DIR" && mkdir -p "$DIR"
git clone -b v2.3.0 https://github.com/catppuccin/tmux.git "$DIR"
