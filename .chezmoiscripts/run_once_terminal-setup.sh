#!/bin/sh

## Package
for pkg in fzf fd-find bat fastfetch ripgrep; do
    sudo apt install -y $pkg
done

## Install starship
echo "Installing starship..."
curl -sS https://starship.rs/install.sh | sh
echo "Starship version: $(starship --version)"

## Install eza
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza

## Setup for fd
ln -s $(which fdfind) ~/.local/bin/fd

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

## Install zoxide
echo "Installing zoxide..."
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
echo "zoxide version: $(zoxide --version)"
