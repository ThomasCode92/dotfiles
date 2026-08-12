#!/bin/bash

if ! command -v opencode &>/dev/null; then
  echo "🤖 Installing the Opencode CLI..."
  curl -fsSL https://opencode.ai/install | bash
  echo "✅ Opencode CLI installed successfully."
else
  echo "⏭️ Opencode CLI already installed."
fi

if ! command -v pi &>/dev/null; then
  echo "🤖 Installing the Pi CLI..."
  # TODO: check node version (22.19.0 or higher) and install if not present
  curl -fsSL https://pi.dev/install.sh | sh
  echo "✅ Pi CLI installed successfully."
else
  echo "⏭️ Pi CLI already installed."
fi
