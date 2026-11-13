#!/bin/bash

set -euo pipefail

# Install SDKMAN! if it is not already present.
# `sdk` is a fish function, so detect an existing installation by its init script.

sdkman_dir="${SDKMAN_DIR:-$HOME/.sdkman}"

if [[ -f "$sdkman_dir/bin/sdkman-init.sh" ]]; then
  echo "⏭️  SDKMAN already installed at $sdkman_dir."
  exit 0
fi

echo "📥 Installing SDKMAN"
sudo pacman -S --needed --noconfirm curl zip unzip
curl -s "https://get.sdkman.io" | bash

if [[ ! -f "$sdkman_dir/bin/sdkman-init.sh" ]]; then
  echo "❌ SDKMAN installation failed (no init script at $sdkman_dir)."
  exit 1
fi

echo "✅ SDKMAN installed at $sdkman_dir"
