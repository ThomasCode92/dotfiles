#!/bin/bash

echo "🚀 Setting up dotfiles"

if which -s "brew"; then
  echo "✅ Homebrew is already installed."
else
  echo "🍺 Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "✅ Homebrew installed successfully."
fi

if which -s "gpg"; then
  echo "✅ GPG is already installed."
else
  echo "🔐 Installing GPG"
  brew install gnupg
  echo "✅ GPG installed successfully."
fi

if which -s "chezmoi"; then
  echo "✅ Chezmoi is already installed."
else
  echo "⚪️ Installing Chezmoi"
  brew install chezmoi
fi

if [ -d "$HOME/.local/share/chezmoi/.git" ]; then
  echo "ℹ️ Chezmoi already initialized, pulling latest changes..."
  chezmoi update
  echo "✅ Chezmoi updated"
else
  echo "🗝️ Setting up GPG key"
  gpg --import ~/privatekey.asc
  gpg --import ~/publickey.asc
  export PASS_GPG_KEY=$(gpg --list-keys --keyid-format long --with-colons | grep '^pub' | cut -d: -f5)

  echo "🔧 Initializing Chezmoi"
  chezmoi init $GITHUB_USERNAME
  chezmoi apply
  echo "✅ Chezmoi initialized"
fi
