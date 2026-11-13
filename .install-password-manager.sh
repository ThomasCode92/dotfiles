#!/bin/sh

set -eu

PASS_DIR="${PASSWORD_STORE_DIR:-$HOME/.password-store}"
PASS_REPO="git@github.com:ThomasCode92/password-store.git"

# Install pass if it is not available yet
if ! command -v pass >/dev/null 2>&1; then
  if command -v pacman >/dev/null 2>&1; then
    sudo pacman -S --needed --noconfirm pass
  elif command -v brew >/dev/null 2>&1; then
    brew install pass
  else
    echo "❌ No supported package manager found" >&2
    exit 1
  fi
fi

# Clone the store on first setup
if [ ! -d "$PASS_DIR/.git" ]; then
  echo "📥 Cloning password store"
  git clone "$PASS_REPO" "$PASS_DIR"
fi

# Initialise the store if it has no recipients yet
if [ ! -f "$PASS_DIR/.gpg-id" ]; then
  if [ -z "${PASS_GPG_KEY:-}" ]; then
    echo "❌ Set PASS_GPG_KEY to initialise the password store" >&2
    exit 1
  fi

  PASSWORD_STORE_DIR="$PASS_DIR" pass init "$PASS_GPG_KEY"
fi
