#!/bin/bash

echo "📦 Installing herdr..."
if ! command -v herdr &>/dev/null; then
  curl -fsSL https://herdr.dev/install.sh | sh
else
  echo "✓ herdr is already installed, skipping"
fi

echo "📦 Installing plugins..."
mkdir -p "$HOME/.herdr"
git clone git@github.com:paulbkim-dev/vim-herdr-navigation.git "$HOME/.herdr/vim-herdr-navigation"
herdr plugin link "$HOME/.herdr/vim-herdr-navigation"
herdr plugin action list --plugin vim-herdr-navigation
