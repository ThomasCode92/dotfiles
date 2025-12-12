#!/bin/bash

# Install Tmux
if ! command -v tmux &>/dev/null; then
  echo "📦 Installing tmux..."

  # Define dependencies
  dependencies=(
    libevent-dev
    autoconf
    pkg-config
    automake
    bison
  )

  # Install dependencies
  echo "🔧 Installing dependencies..."
  for dep in "${dependencies[@]}"; do
    echo "Installing $dep..."
    sudo apt install -y "$dep"
  done

  # Fetch latest tmux tag
  echo "🔍 Fetching latest tmux version..."
  latest_tag=$(curl -s https://api.github.com/repos/tmux/tmux/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')

  if [[ -z "$latest_tag" ]]; then
    echo "⚠️ Could not fetch latest tag, using master branch"
    latest_tag="master"
  else
    echo "📥 Latest version: $latest_tag"
  fi

  cd "$HOME"
  git clone https://github.com/tmux/tmux.git
  cd tmux

  # Checkout latest tag if available
  if [[ "$latest_tag" != "master" ]]; then
    git checkout "$latest_tag"
  fi

  echo "🔨 Building tmux..."
  sh autogen.sh
  ./configure && make
  sudo make install

  if [[ $? -eq 0 ]]; then
    echo "✅ tmux installed successfully"
  else
    echo "❌ tmux installation failed"
    exit 1
  fi
else
  echo "⏭️  tmux already installed, installation skipped"
  echo "   version: $(tmux -V)"
fi

# Install Tmux Plugin Manager
if [[ ! -e ~/.tmux/plugins/ ]]; then
  echo "📦 Installing tpm..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  echo "✅ tpm installed successfully"
else
  echo "⏭️  tpm already installed, installation skipped"
fi
