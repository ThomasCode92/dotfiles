#!/bin/bash

# Install Unity Hub on Linux (Arch and Ubuntu)
# https://docs.unity.com/en-us/hub/install-hub-linux

if [[ "$(uname -s)" == "Darwin" ]]; then
  echo "macOS detected"
  echo "Unity Hub will be installed via Homebrew"
  echo "See Brewfile for more details"
  exit 0
fi

if command -v unityhub &>/dev/null; then
  echo "✓ Unity Hub is already installed, skipping"
  exit 0
fi

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

echo "🎮 Installing Unity Hub..."

if command -v pacman &>/dev/null; then
  # Arch Linux: community-maintained AUR package
  echo "📦 Installing unityhub from AUR..."
  git clone https://aur.archlinux.org/unityhub.git "$TMP_DIR/unityhub-aur"
  cd "$TMP_DIR/unityhub-aur" && makepkg -si --noconfirm
elif command -v apt &>/dev/null; then
  # Ubuntu/Debian: official Unity Hub repository for auto-updates
  echo "📦 Adding Unity Hub repository..."

  sudo install -d /etc/apt/keyrings
  curl -fsSL https://hub.unity3d.com/linux/keys/public | sudo gpg --dearmor -o /etc/apt/keyrings/unityhub.gpg
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/unityhub.gpg] https://hub.unity3d.com/linux/repos/deb stable main" | sudo tee /etc/apt/sources.list.d/unityhub.list

  sudo apt update
  sudo apt install -y unityhub
else
  echo "❌ Unsupported Linux distribution for Unity Hub install"
  exit 1
fi

echo "✅ Unity Hub installation complete!"
