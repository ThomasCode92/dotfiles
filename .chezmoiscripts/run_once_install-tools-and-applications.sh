#!/bin/bash

if [[ "$(uname -s)" == "Darwin" ]]; then
  echo "macOS detected"
  echo "CLI tools will be installed via Homebrew"
  echo "See Brewfile for more details"
  exit 0
fi

echo "🐟 Installing fish and dependencies..."

CLI_TOOLS=(base-devel bat eza fd fzf htop jq lazydocker lazygit podman tmux unzip zip)
APPLICATIONS=(kitty neovim)

echo "📦 Installing CLI tools and applications..."
if command -v pacman &>/dev/null; then
  sudo pacman -S --needed --noconfirm fish starship fzf "${CLI_TOOLS[@]}" "${APPLICATIONS[@]}"

elif command -v apt &>/dev/null; then
  sudo apt update
  sudo apt install -y fish starship fzf "${CLI_TOOLS[@]}" "${APPLICATIONS[@]}"

else
  echo "Unsupported Linux distribution for fish install"
  exit 1
fi

echo "✅ Installation complete!"
