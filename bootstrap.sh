#!/bin/bash
set -e

echo "🚀 Setting up dotfiles"

# ---------------------------------------------------------
# Install and Configure Homebrew
# ---------------------------------------------------------

echo "🍺 Installing Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

if [[ "$(uname)" == "Darwin" ]]; then
  echo "🍎 macOS detected"
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi

elif [[ "$(uname)" == "Linux" ]]; then
  echo "🐧 Linux detected"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

else
  echo "❌ Unsupported operating system"
  exit 1
fi

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# ---------------------------------------------------------
# GPG
# ---------------------------------------------------------

if ! command -v gpg &>/dev/null; then
  echo "🍺 Installing GPG"
  brew install gnupg
fi

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

echo "🍺 Installing chezmoi"
brew install chezmoi

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
