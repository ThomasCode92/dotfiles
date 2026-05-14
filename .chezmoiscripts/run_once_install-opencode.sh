#!/bin/bash

if ! command -v opencode &>/dev/null; then
  echo "🤖 Installing the Opencode CLI..."
  curl -fsSL https://opencode.ai/install | bash
  echo "✅ Opencode CLI installed successfully."
else
  echo "⏭️ Opencode CLI already installed."
fi
