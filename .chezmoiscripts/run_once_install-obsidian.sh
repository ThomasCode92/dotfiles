#!/bin/bash

if [[ "$(uname -s)" == "Darwin" ]]; then
  echo "macOS detected"
  echo "Obsidian will be installed via Homebrew"
  echo "See Brewfile for more details"
  exit 0
fi

echo "📓 Installing Obsidian..."

if command -v obsidian &>/dev/null; then
  echo "✓ Obsidian is already installed, skipping"
  exit 0
fi

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

if command -v pacman &>/dev/null; then
  # Arch Linux: community-maintained AUR package
  # The package builds two conflicting sub-packages (obsidian-bin and
  # obsidian-appimage); install only obsidian-bin (official binary).
  echo "📦 Installing obsidian from AUR..."
  git clone https://aur.archlinux.org/obsidian.git "$TMP_DIR/obsidian-aur"
  cd "$TMP_DIR/obsidian-aur" || exit 1
  makepkg -s --noconfirm || {
    echo "❌ Failed to build obsidian"
    exit 1
  }
  sudo pacman -U --noconfirm obsidian-bin-*.pkg.tar.zst || {
    echo "❌ Failed to install obsidian"
    exit 1
  }
elif command -v apt &>/dev/null; then
  # Ubuntu/Debian: official .deb package
  echo "📦 Installing official Obsidian .deb..."
  VERSION=$(curl -fsSL https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest | grep tag_name | cut -d'"' -f4)
  DEB="obsidian_${VERSION}_amd64.deb"
  echo "📦 Downloading ${DEB}..."

  curl -fsSL -o "$TMP_DIR/$DEB" "https://github.com/obsidianmd/obsidian-releases/releases/download/${VERSION}/${DEB}" || {
    echo "❌ Failed to download ${DEB}"
    exit 1
  }
  sudo dpkg -i "$TMP_DIR/$DEB" || {
    echo "🔧 Fixing dependencies..."
    sudo apt update && sudo apt install -f -y
    sudo dpkg -i "$TMP_DIR/$DEB" || {
      echo "❌ Failed to install obsidian"
      exit 1
    }
  }
else
  echo "❌ Unsupported Linux distribution for Obsidian install"
  exit 1
fi

echo "✅ Obsidian installation complete!"
