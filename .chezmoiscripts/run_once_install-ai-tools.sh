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

if ! command -v codex &>/dev/null; then
  echo "🤖 Installing the Codex CLI..."
  curl -fsSL https://chatgpt.com/codex/install.sh | sh
  echo "✅ Codex CLI installed successfully."
else
  echo "⏭️ Codex CLI already installed."
fi

if ! command -v copilot &>/dev/null; then
  echo "🤖 Installing the Copilot CLI..."
  curl -fsSL https://gh.io/copilot-install | bash
  echo "✅ Copilot CLI installed successfully."
else
  echo "⏭️ Copilot CLI already installed."
fi

if ! command -v ollama &>/dev/null; then
  echo "🤖 Installing Ollama..."
  curl -fsSL https://ollama.com/install.sh | sh
  echo "✅ Ollama installed successfully."
else
  echo "⏭️ Ollama already installed."
fi
