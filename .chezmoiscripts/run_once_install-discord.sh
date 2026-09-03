#!/bin/bash

# Install Discord on Linux (Arch and Ubuntu)
# https://discord.com/download

if [[ "$(uname -s)" == "Darwin" ]]; then
  echo "macOS detected"
  echo "Discord will be installed via Homebrew"
  echo "See Brewfile for more details"
  exit 0
fi

echo "🔊 Installing Discord..."

if command -v discord &>/dev/null; then
  echo "✓ Discord is already installed, skipping"
  exit 0
fi

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

if command -v pacman &>/dev/null; then
  # Arch Linux: official Discord package directly from Discord
  echo "📦 Installing Discord from official Arch package..."
  wget -qO "$TMP_DIR/discord.pkg.tar.zst" "https://discord.com/api/download/stable?platform=linux&format=pkg.tar.zst"
  sudo pacman -U --noconfirm "$TMP_DIR/discord.pkg.tar.zst"
elif command -v apt &>/dev/null; then
  # Ubuntu/Debian: official .deb package from Discord
  echo "📦 Installing Discord from official .deb package..."
  wget -qO "$TMP_DIR/discord.deb" "https://discord.com/api/download?platform=linux&format=deb"
  sudo apt install -y "$TMP_DIR/discord.deb"
else
  echo "❌ Unsupported Linux distribution for Discord install"
  exit 1
fi

if [[ $? -ne 0 ]]; then
  echo "❌ Discord installation failed"
  exit 1
fi

echo "✅ Discord installation complete!"
