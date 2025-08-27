#!/bin/bash

# Make script executable
chmod +x "$0"

# Check if Node.js is installed
if command -v node &>/dev/null; then
  echo "Node.js is installed, (version: $(node --version))"

  # Check if Gemini CLI is installed
  if command -v gemini &>/dev/null; then
    echo "Gemini CLI is already installed, skipping installation."
  else
    # Install Gemini CLI globally
    echo "Installing the Google Gemini CLI..."
    npm install -g @google/gemini-cli
  fi
else
  echo "Node.js is not installed"
fi

if command -v opencode &>/dev/null; then
  echo "Opencode CLI is already installed, skipping installation."
else
  echo "Installing the Opencode CLI..."
  curl -fsSL https://opencode.ai/install | bash
fi
