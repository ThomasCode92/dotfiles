#!/bin/bash

# Function to check if a package is installed
is_package_installed() {
  dpkg -l | grep "$1" &>/dev/null
  return $?
}

# Install or update fish shell
if ! is_package_installed "fish"; then
  echo "🐟 Installing fish shell..."
  sudo apt-add-repository ppa:fish-shell/release-4 -y
  sudo apt update
  sudo apt install -y fish
  echo "✅ fish installed successfully."
else
  echo "🐟 Updating fish shell..."
  sudo apt upgrade -y fish
  echo "✅ fish updated successfully."
fi

# Set fish as the default shell
if [[ "$(basename "$SHELL")" != "fish" ]]; then
  echo "🔧 Setting fish as the default shell..."
  if chsh -s "$(which fish)"; then
    echo "✅ Default shell set to fish. Re-login to apply."
  else
    echo "🔧 Could not set fish as default shell automatically."
    echo "   Run manually: chsh -s \$(which fish)"
  fi
else
  echo "⏭️ fish is already the default shell."
fi
