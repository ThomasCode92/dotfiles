#!/bin/bash

# Install Nerd Fonts (Hack and JetBrains Mono)

set -e

FONT_DIR="$HOME/.local/share/fonts"

echo "🔤 Setting up Nerd Fonts..."

# Create fonts directory if it doesn't exist
mkdir -p "$FONT_DIR"

# Function to install a Nerd Font from GitHub releases
install_nerd_font() {
  local font_name=$1
  local font_display_name=$2

  # Check if font is already installed
  if fc-list | grep -qi "$font_display_name"; then
    echo "⏭️  $font_display_name is already installed"
    return 0
  fi

  echo "📥 Downloading $font_display_name..."
  TEMP_DIR=$(mktemp -d)
  cd "$TEMP_DIR" || return 1

  # Get the latest release URL from GitHub
  FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font_name}.zip"

  if ! curl -fLo "${font_name}.zip" "$FONT_URL" 2>/dev/null; then
    echo "❌ Failed to download $font_display_name"
    rm -rf "$TEMP_DIR"
    return 1
  fi

  echo "📦 Extracting $font_display_name..."
  unzip -q "${font_name}.zip" -d "$font_name"

  # Install fonts (only .ttf files)
  echo "💾 Installing $font_display_name to $FONT_DIR..."
  find "$font_name" -name "*.ttf" -exec cp {} "$FONT_DIR/" \;

  # Cleanup
  rm -rf "$TEMP_DIR"

  echo "✅ $font_display_name installed successfully"
}

# Install Hack Nerd Font
install_nerd_font "Hack" "Hack Nerd Font"

# Install JetBrains Mono Nerd Font
install_nerd_font "JetBrainsMono" "JetBrainsMono Nerd Font"

# Update font cache
echo "🔄 Updating font cache..."
fc-cache -f "$FONT_DIR" &>/dev/null

echo "✅ Nerd Fonts setup complete!"
echo "🔤 Installed font families:"
fc-list | grep -iE "(Hack|JetBrains).*Nerd Font" | cut -d: -f2 | cut -d, -f1 | sort -u | head -10
