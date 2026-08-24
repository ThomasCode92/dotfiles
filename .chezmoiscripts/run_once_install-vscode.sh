#!/bin/bash

# Install Visual Studio Code on Linux (Arch and Ubuntu)
# https://code.visualstudio.com/docs/setup/linux

if [[ "$(uname -s)" == "Darwin" ]]; then
  echo "macOS detected"
  echo "VS Code will be installed via Homebrew"
  echo "See Brewfile for more details"
  exit 0
fi

if command -v code &>/dev/null; then
  echo "✓ VS Code is already installed, skipping"
  exit 0
fi

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

echo "🧭 Installing Visual Studio Code..."

if command -v pacman &>/dev/null; then
  # Arch Linux: community-maintained AUR package
  echo "📦 Installing visual-studio-code-bin from AUR..."
  git clone https://aur.archlinux.org/visual-studio-code-bin.git "$TMP_DIR/vscode-aur"
  cd "$TMP_DIR/vscode-aur" && makepkg -si --noconfirm
elif command -v apt &>/dev/null; then
  # Ubuntu/Debian: official .deb package with apt repository for auto-updates
  echo "📦 Installing VS Code from official Microsoft repository..."

  # Non-interactive installation of the apt repository and signing key
  echo "code code/add-microsoft-repo boolean true" | sudo debconf-set-selections

  wget -qO "$TMP_DIR/vscode.deb" https://go.microsoft.com/fwlink/?LinkID=760868
  sudo apt install -y "$TMP_DIR/vscode.deb"
else
  echo "❌ Unsupported Linux distribution for VS Code install"
  exit 1
fi

echo "✅ VS Code installation complete!"
