#!/bin/sh

# Install Zig 0.13
wget https://ziglang.org/download/0.13.0/zig-linux-x86_64-0.13.0.tar.xz
sudo tar -xf zig-linux-x86_64-0.13.0.tar.xz -C /opt

# Install required dependencies
sudo apt install libgtk-4-dev libadwaita-1-dev

# Clone the Ghostty repository
git clone https://github.com/ghostty-org/ghostty.git
cd ghostty
git checkout v1.0.0

# Build Ghostty
/opt/zig-linux-x86_64-0.13.0/zig build -p $HOME/.local -Doptimize=ReleaseFast
sudo update-desktop-database
