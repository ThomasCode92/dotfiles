#!/bin/bash

set -euo pipefail

REPO_RAW="https://raw.githubusercontent.com/ThomasCode92/dotfiles/main"

# DOTFILES_LOCAL=1 -> use the scripts from the local chezmoi source directory
# instead of downloading. Hardcoded because `curl ... | bash` leaves
# BASH_SOURCE unset.
DOTFILES_LOCAL="${DOTFILES_LOCAL:-0}"
SCRIPT_DIR="$HOME/.local/share/chezmoi"

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
  if [[ ! -f "$SCRIPT_DIR/$SCRIPT" ]]; then
    echo "❌ $SCRIPT not found in $SCRIPT_DIR (run chezmoi init first)"
    exit 1
  fi

  echo "📁 Using local $SCRIPT"
  bash "$SCRIPT_DIR/$SCRIPT" "$@"
else
  TMP_SCRIPT="$(mktemp)"
  trap 'rm -f "$TMP_SCRIPT"' EXIT

  if ! command -v curl &>/dev/null; then
    echo "❌ curl is required to download $SCRIPT"
    exit 1
  fi

  echo "⬇️ Downloading $SCRIPT"
  curl -fsSL "$REPO_RAW/$SCRIPT" -o "$TMP_SCRIPT"

  bash "$TMP_SCRIPT" "$@"
fi
