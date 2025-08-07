#!/bin/bash

# Make script executable
chmod +x "$0"

# Check if Node.js is installed
if command -v node &>/dev/null; then
  echo "Node.js is installed, (version: $(node --version))"

  # Install Gemini CLI globally
  echo "Installing the Google Gemini CLI..."
  npm install -g @google/gemini-cli
else
  echo "Node.js is not installed"
fi
