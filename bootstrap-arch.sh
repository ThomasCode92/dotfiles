#!/usr/bin/env bash
set -euo pipefail

echo "🐧 Setting up dotfiles (Arch Linux)"

# ---------------------------------------------------------
# Packages (& yay)
# ---------------------------------------------------------
echo "📦 Installing packages"
sudo pacman -Syu --needed --noconfirm yay git curl gnupg chezmoi base-devel

# ---------------------------------------------------------
# GPG
# ---------------------------------------------------------
if command -v gpg &>/dev/null; then
  echo "✅ GPG is installed"
else
  echo "❌ GPG installation failed"
  exit 1
fi

for key in privatekey.asc publickey.asc; do
  if [[ ! -f "$HOME/$key" ]]; then
    echo "❌ ~/$key is missing (see the prerequisites in README.md)"
    exit 1
  fi
done

echo "🗝️ Importing GPG keys"
gpg --import "$HOME/privatekey.asc"
gpg --import "$HOME/publickey.asc"

PASS_GPG_KEY="$(
  gpg --list-keys \
    --keyid-format long \
    --with-colons |
    awk -F: '$1 == "pub" { print $5; exit }'
)"
export PASS_GPG_KEY

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
