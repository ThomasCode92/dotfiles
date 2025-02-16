#!/bin/sh

## Package
for pkg in fzf fd-find bat fastfetch ripgrep; do
    sudo apt install -y $pkg
done

## Install starship
echo "Installing starship..."
curl -sS https://starship.rs/install.sh | sh
echo "Starship version: $(starship --version)"

## Setup for bat
echo "Setting up bat..."
mkdir -p ~/.local/bin
ln -s /usr/bin/batcat ~/.local/bin/bat

rm -rf "$(bat --config-dir)/themes"
mkdir -p "$(bat --config-dir)/themes"
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Latte.tmTheme
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Frappe.tmTheme
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
bat cache --build

echo "bat configured and catppuccin theme set" 
echo "version: $(bat --version)"
