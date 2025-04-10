#!/bin/bash

## Function to check if a package is installed
is_package_installed() {
  dpkg -l | grep "$1" &>/dev/null
  return $?
}

## List of packages to install
packages=("fzf" "fd-find" "bat" "fastfetch" "ripgrep" "eza" "jq" "ffmpeg")

## Install packages
for pkg in "${packages[@]}"; do
  if ! is_package_installed "$pkg"; then
    echo "Installing $pkg..."

    ### Special handling for eza
    if [[ "$pkg" == "eza" ]]; then
      sudo mkdir -p /etc/apt/keyrings
      wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
      echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
      sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
      sudo apt update
    fi

    ### Install the package
    sudo apt install -y $pkg

    ### Post installation setup
    if [[ "$pkg" == "fd-find" ]]; then
      echo "Setting up fd..."
      ln -s $(which fdfind) ~/.local/bin/fd
    elif [[ "$pkg" == "bat" ]]; then
      echo "Setting up bat..."
      mkdir -p ~/.local/bin
      ln -s /usr/bin/batcat ~/.local/bin/bat
      mkdir -p "$(bat --config-dir)/themes"
      wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Latte.tmTheme
      wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Frappe.tmTheme
      wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme
      wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
      bat cache --build
    fi

    echo "$pkg installed successfully."
  else
    echo "Installation for $pkg is skipped, was already installed."
  fi
done

## Install zoxide
if ! command -v zoxide &>/dev/null; then
  echo "Installing zoxide..."
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
else
  echo "Installation for zoxide is skipped, was already installed."
fi

## Install Yazi
if ! command -v yazi &>/dev/null; then
  if command -v rustup &>/dev/null; then
    echo "Installing Yazi..."
    git clone http://github.com/sxyazi/yazi.git
    cd yazi
    cargo build --release --locked
    mv target/release/yazi target/release/ya /usr/local/bin/
  else
    echo "Rustup is not installed, skipping Yazi installation."
  fi
else
  echo "Installation for Yazi is skipped, was already installed."
fi
