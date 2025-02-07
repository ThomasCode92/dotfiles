#!/bin/bash

# Check if Neovim is already installed
if command -v nvim &> /dev/null; then
    echo "Neovim is already installed. Skipping installation."
    exit 0
fi

# Install dependencies
echo "Installing dependencies..."
sudo apt-get update
sudo apt-get install -y ninja-build gettext cmake curl build-essential

# Clone Neovim repository
echo "Cloning Neovim repository..."
NVIM_DIR="$HOME/neovim"
if [ ! -d "$NVIM_DIR" ]; then
    git clone https://github.com/neovim/neovim.git "$NVIM_DIR"
else
    echo "Neovim repository already exists. Pulling latest changes..."
    cd "$NVIM_DIR" && git pull
fi

# Build and install Neovim
echo "Building and installing Neovim..."
cd "$NVIM_DIR" && git checkout stable
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install

echo "Neovim installation complete."
