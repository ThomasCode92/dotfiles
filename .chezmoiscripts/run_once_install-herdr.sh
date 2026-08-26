#!/bin/bash

echo "📦 Installing herdr..."
curl -fsSL https://herdr.dev/install.sh | sh

echo "📦 Installing plugins..."
mkdir -p "$HOME/.herdr"
git clone git@github.com:paulbkim-dev/vim-herdr-navigation.git "$HOME/.herdr/vim-herdr-navigation"
herdr plugin link "$HOME/.herdr/vim-herdr-navigation"
herdr plugin action list --plugin vim-herdr-navigation
