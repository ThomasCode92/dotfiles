#!/bin/bash
set -e

echo "🚀 Setting up dotfiles"

# ---------------------------------------------------------
# Detect OS and install packages
# ---------------------------------------------------------

if [[ "$(uname)" == "Darwin" ]]; then
  echo "🍎 macOS detected"

  if ! command -v brew &>/dev/null; then
    echo "🍺 Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if [[ -f /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f /usr/local/bin/brew ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi

  brew install gnupg chezmoi

elif [[ "$(uname)" == "Linux" ]]; then
  echo "🐧 Linux detected"

  if command -v pacman &>/dev/null; then
    echo "🔵 Manjaro/Arch detected"
    sudo pacman -S --needed --noconfirm gnupg chezmoi

  elif command -v apt &>/dev/null; then
    echo "🟠 Ubuntu/Debian detected"
    sudo apt update
    sudo apt install -y gnupg chezmoi

  else
    echo "❌ Unsupported Linux distribution"
    exit 1
  fi

else
  echo "❌ Unsupported operating system"
  exit 1
fi

# ---------------------------------------------------------
# GPG
# ---------------------------------------------------------

if command -v gpg &>/dev/null; then
  echo "✅ GPG is installed"
else
  echo "❌ GPG installation failed"
  exit 1
fi

echo "🗝️ Importing GPG keys"

gpg --import "$HOME/privatekey.asc"
gpg --import "$HOME/publickey.asc"

export PASS_GPG_KEY="$(
  gpg --list-keys \
    --keyid-format long \
    --with-colons |
    awk -F: '$1 == "pub" { print $5; exit }'
)"

if [[ -z "$PASS_GPG_KEY" ]]; then
  echo "❌ Could not determine GPG key"
  exit 1
fi

echo "🔑 GPG key: $PASS_GPG_KEY"

# ---------------------------------------------------------
# Chezmoi
# ---------------------------------------------------------

if command -v chezmoi &>/dev/null; then
  echo "✅ Chezmoi is installed"
else
  echo "❌ Chezmoi installation failed"
  exit 1
fi

if [[ -d "$(chezmoi source-path)/.git" ]]; then
  echo "ℹ️ Chezmoi already initialized"
  chezmoi update
  echo "✅ Chezmoi updated"
  exit 0
fi

if [[ -z "${GITHUB_USERNAME:-}" ]]; then
  echo "❌ GITHUB_USERNAME is not set"
  exit 1
fi

echo "🔧 Initializing Chezmoi"

chezmoi init "$GITHUB_USERNAME"
chezmoi apply

echo "✅ Dotfiles setup complete"
