#!/bin/bash

if [[ "$(uname -s)" == "Darwin" ]]; then
  echo "macOS detected"
  echo "CLI tools will be installed via Homebrew"
  echo "See Brewfile for more details"
  exit 0
fi

echo "🐟 Installing fish and dependencies..."

CLI_TOOLS=(bat eza fd fzf htop jq lazydocker lazygit tmux)
APPLICATIONS=(kitty neovim)

if command -v pacman &>/dev/null; then
  sudo pacman -S --needed --noconfirm fish starship fzf "${CLI_TOOLS[@]}" "${APPLICATIONS[@]}"
elif command -v apt &>/dev/null; then
  sudo apt update
  sudo apt install -y fish starship fzf "${CLI_TOOLS[@]}" "${APPLICATIONS[@]}"
else
  echo "Unsupported Linux distribution for fish install"
  exit 1
fi

# zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# carapace
VERSION=$(curl -fsSL https://api.github.com/repos/carapace-sh/carapace-bin/releases/latest | grep tag_name | cut -d'"' -f4)
ARCH=$(uname -m)
[ "$ARCH" = "x86_64" ] && ARCH=amd64
[ "$ARCH" = "aarch64" ] && ARCH=arm64
curl -fsSL "https://github.com/carapace-sh/carapace-bin/releases/download/${VERSION}/carapace-bin_${VERSION#v}_linux_${ARCH}.tar.gz" | sudo tar -xzC /usr/local/bin carapace

# atuin
if command -v atuin &>/dev/null; then
  echo "✓ atuin is already installed, skipping"
else
  echo "📦 Installing atuin..."
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
fi

# sdkman
if [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
  echo "✓ SDKMAN is already installed, skipping"
else
  echo "📦 Installing SDKMAN..."
  curl -s "https://get.sdkman.io" | bash
fi

echo "✅ Installation complete!"
