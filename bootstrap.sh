#!/bin/bash

set -euo pipefail

REPO_RAW="https://raw.githubusercontent.com/ThomasCode92/dotfiles/main"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# DOTFILES_LOCAL=1 -> use the scripts next to this file instead of downloading
DOTFILES_LOCAL="${DOTFILES_LOCAL:-0}"

echo "🚀 Setting up dotfiles"

# ---------------------------------------------------------
# Detect OS
# ---------------------------------------------------------
case "$(uname -s)" in
Darwin)
  SCRIPT="bootstrap-macos.sh"
  echo "🍎 macOS detected"
  ;;
Linux)
  if [[ -f /etc/arch-release ]]; then
    SCRIPT="bootstrap-arch.sh"
    echo "🐧 Arch Linux detected"
  else
    echo "❌ Unsupported Linux distribution (only Arch is supported)"
    exit 1
  fi
  ;;
*)
  echo "❌ Unsupported operating system"
  exit 1
  ;;
esac

# ---------------------------------------------------------
# Run the OS-specific script (local copy or download)
# ---------------------------------------------------------
if [[ "$DOTFILES_LOCAL" == "1" ]]; then
  echo "📁 Using local $SCRIPT"
  bash "$SCRIPT_DIR/$SCRIPT" "$@"
else
  TMP_SCRIPT="$(mktemp)"
  trap 'rm -f "$TMP_SCRIPT"' EXIT

  echo "⬇️ Downloading $SCRIPT"
  curl -fsSL "$REPO_RAW/$SCRIPT" -o "$TMP_SCRIPT"

  bash "$TMP_SCRIPT" "$@"
fi
