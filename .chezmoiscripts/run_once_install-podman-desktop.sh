#!/bin/bash

# Install Podman Desktop on Linux
# https://podman-desktop.io/downloads/linux

if [[ "$(uname -s)" == "Darwin" ]]; then
  echo "macOS detected"
  echo "Podman Desktop will be installed via Homebrew"
  echo "See Brewfile for more details"
  exit 0
fi

if command -v podman-desktop &>/dev/null; then
  echo "✓ Podman Desktop is already installed, skipping"
  exit 0
fi

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

echo "🧭 Installing Podman Desktop..."

if command -v flatpak &>/dev/null; then
  # Flatpak: official Flathub package with auto-updates
  echo "📦 Installing Podman Desktop from Flathub..."
  flatpak install -y flathub io.podman_desktop.PodmanDesktop
elif [[ "$(uname -m)" == "aarch64" || "$(uname -m)" == "arm64" ]]; then
  # ARM64 binary
  echo "📦 Installing Podman Desktop ARM64 binary..."
  wget -qO "$TMP_DIR/podman-desktop.tar.gz" \
    https://github.com/podman-desktop/podman-desktop/releases/download/v1.29.3/podman-desktop-1.29.3-arm64.tar.gz
  tar -xzf "$TMP_DIR/podman-desktop.tar.gz" -C "$TMP_DIR"
  sudo install -Dm755 "$TMP_DIR/podman-desktop-1.29.3-arm64/podman-desktop" /usr/bin/podman-desktop
else
  # AMD64 binary
  echo "📦 Installing Podman Desktop AMD64 binary..."
  wget -qO "$TMP_DIR/podman-desktop.tar.gz" \
    https://github.com/podman-desktop/podman-desktop/releases/download/v1.29.3/podman-desktop-1.29.3-x64.tar.gz
  tar -xzf "$TMP_DIR/podman-desktop.tar.gz" -C "$TMP_DIR"
  sudo install -Dm755 "$TMP_DIR/podman-desktop-1.29.3-x64/podman-desktop" /usr/bin/podman-desktop
fi

echo "✅ Podman Desktop installation complete!"