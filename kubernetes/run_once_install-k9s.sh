#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Updating package list..."
sudo apt update

echo "Fetching the latest version of k9s..."
K9S_VERSION=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')

if [ -z "$K9S_VERSION" ]; then
    echo "Failed to fetch the latest k9s version. Please check your internet connection or GitHub API status."
    exit 1
fi

echo "Latest k9s version: $K9S_VERSION"

K9S_TARBALL="k9s_Linux_amd64.tar.gz"
K9S_DOWNLOAD_URL="https://github.com/derailed/k9s/releases/download/v$K9S_VERSION/$K9S_TARBALL"

echo "Downloading k9s from $K9S_DOWNLOAD_URL..."
wget -q --show-progress "$K9S_DOWNLOAD_URL"

echo "Extracting k9s binary..."
tar -xzf "$K9S_TARBALL"

echo "Moving k9s binary to /usr/local/bin..."
sudo mv k9s /usr/local/bin/

echo "Cleaning up..."
rm -f "$K9S_TARBALL"

echo "Verifying installation..."
k9s version

echo "k9s installation complete!"
