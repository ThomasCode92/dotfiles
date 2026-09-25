#!/bin/bash

# Install Postman on Linux (Arch and Ubuntu) from official tar.gz
# https://learning.postman.com/docs/getting-started/installation/install-app#install-postman-on-linux

if [[ "$(uname -s)" == "Darwin" ]]; then
  echo "macOS detected"
  echo "Postman will be installed via Homebrew"
  echo "See Brewfile for more details"
  exit 0
fi

if command -v postman &>/dev/null; then
  echo "✓ Postman is already installed, skipping"
  exit 0
fi

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

echo "🧭 Installing Postman..."

if ! command -v openssl &>/dev/null; then
  echo "❌ openssl is required for Postman but not installed"
  exit 1
fi

# Official tar.gz bundle (avoids snap); no package manager specific path
if [[ "$(uname -m)" == "aarch64" || "$(uname -m)" == "arm64" ]]; then
  echo "📦 Downloading Postman ARM64 bundle..."
  wget -qO "$TMP_DIR/postman.tar.gz" https://dl.pstmn.io/download/latest/linux_arm64
else
  echo "📦 Downloading Postman Linux x64 bundle..."
  wget -qO "$TMP_DIR/postman.tar.gz" https://dl.pstmn.io/download/latest/linux64
fi

tar -xzf "$TMP_DIR/postman.tar.gz" -C "$TMP_DIR"

echo "📁 Installing to /opt/Postman..."
sudo rm -rf /opt/Postman
sudo install -d /opt/Postman
sudo cp -r "$TMP_DIR/Postman/." /opt/Postman/
sudo chown -R root:root /opt/Postman

sudo ln -sf /opt/Postman/app/Postman /usr/local/bin/postman

echo "🔌 Creating desktop launcher..."
mkdir -p ~/.local/share/applications
cat > ~/.local/share/applications/postman.desktop <<EOF
[Desktop Entry]
Encoding=UTF-8
Name=Postman
Exec=/opt/Postman/app/Postman %U
Icon=/opt/Postman/app/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;
EOF

echo "✅ Postman installation complete!"