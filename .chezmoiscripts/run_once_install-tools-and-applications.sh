#!/bin/bash

if [[ "$(uname -s)" == "Darwin" ]]; then
  echo "macOS detected"
  echo "CLI tools will be installed via Homebrew"
  echo "See Brewfile for more details"
  exit 0
fi

echo "🐟 Installing fish and dependencies..."

CLI_TOOLS=(base-devel bat eza fd fzf htop jq lazydocker lazygit tmux unzip zip)
APPLICATIONS=(kitty neovim)

echo "📦 Installing CLI tools and applications..."
if command -v pacman &>/dev/null; then
  sudo pacman -S --needed --noconfirm fish starship fzf "${CLI_TOOLS[@]}" "${APPLICATIONS[@]}"

  # asdf
  git clone https://aur.archlinux.org/asdf-vm.git "$HOME/.asdf-vm"
  cd "$HOME/.asdf-vm" && makepkg -si
elif command -v apt &>/dev/null; then
  sudo apt update
  sudo apt install -y fish starship fzf "${CLI_TOOLS[@]}" "${APPLICATIONS[@]}"

  # asdf
  git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf" --branch v0.20.0
  cd "$HOME/.asdf" && make
  export PATH="$HOME/.asdf/bin:$PATH"

else
  echo "Unsupported Linux distribution for fish install"
  exit 1
fi

# zoxide
echo "📦 Installing zoxide..."
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# carapace
echo "📦 Installing carapace..."
VERSION=$(curl -fsSL https://api.github.com/repos/carapace-sh/carapace-bin/releases/latest | grep tag_name | cut -d'"' -f4)
ARCH=$(uname -m)
[ "$ARCH" = "x86_64" ] && ARCH=amd64
[ "$ARCH" = "aarch64" ] && ARCH=arm64
curl -fsSL "https://github.com/carapace-sh/carapace-bin/releases/download/${VERSION}/carapace-bin_${VERSION#v}_linux_${ARCH}.tar.gz" | sudo tar -xzC /usr/local/bin carapace

# atuin
echo "📦 Installing atuin..."
if command -v atuin &>/dev/null; then
  echo "✓ atuin is already installed, skipping"
else
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
fi

# sdkman
echo "📦 Installing SDKMAN..."
if [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
  echo "✓ SDKMAN is already installed, skipping"
else
  curl -s "https://get.sdkman.io" | bash
fi

echo "✅ Installation complete!"
