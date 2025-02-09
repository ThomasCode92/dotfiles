#!/bin/sh

## Package
sudo apt install fzf
sudo apt install fd-find
sudo apt install bat
sudo apt install fastfetch
sudo apt install tmux
sudo apt install ripgrep

## Install starship
if ! command -v starship >/dev/null 2>&1; then
    echo "Installing starship..."
    curl -fsSL https://starship.rs/install.sh | bash -s -- -y
else
    echo "starship already installed, installation skipped"
    echo "version: $(starship --version)"
fi

## Setup for bat
if [ ! -e ~/.local/bin/bat ]; then
    echo "Setting up bat..."
    mkdir -p ~/.local/bin
    ln -s /usr/bin/batcat ~/.local/bin/bat

    mkdir -p "$(bat --config-dir)/themes"
    wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Latte.tmTheme
    wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Frappe.tmTheme
    wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme
    wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
    bat cache --build

    echo "bat configured and catppuccin theme set" 
else
    echo "bat already configured, configuration skipped"
    echo "version: $(bat --version)"
fi

## Install asdf
if [ ! -d ~/.asdf ]; then
    echo "Installing asdf..."
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.15.0
else
    echo "asdf already installed, installation skipped"
    echo "version: $(asdf --version)"
fi

## Install Tmux Plugin Manager
if [ ! -e  ~/.tmux/plugins/ ]; then
    echo "Install tpm..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo "tmp already installed, installation skipped"
fi

