#!/bin/bash

# Shell switcher script
# Usage: ./switch_shell.sh [fish|nu|nushell]

CURRENT_SHELL=$(basename "$(readlink /proc/$PPID/exe)")

switch_to_shell() {
  local target_shell="$1"

  case "$target_shell" in
  "fish")
    echo "Switching to fish shell..."
    exec fish
    ;;
  "nu" | "nushell")
    echo "Switching to nushell..."
    exec nu
    ;;
  *)
    echo "Unknown shell: $target_shell"
    echo "Available options: fish, nu, nushell"
    exit 1
    ;;
  esac
}

toggle_shell() {
  case "$CURRENT_SHELL" in
  "fish")
    echo "Currently in fish, switching to nushell..."
    exec nu
    ;;
  "nu")
    echo "Currently in nushell, switching to fish..."
    exec fish
    ;;
  *)
    echo "Currently in $CURRENT_SHELL"
    echo "Choose a shell to switch to:"
    echo "1) fish"
    echo "2) nushell"
    read -p "Enter choice (1-2): " choice

    case "$choice" in
    1) switch_to_shell "fish" ;;
    2) switch_to_shell "nu" ;;
    *) echo "Invalid choice" ;;
    esac
    ;;
  esac
}

# Main logic
if [ $# -eq 0 ]; then
  # No arguments - toggle between shells
  toggle_shell
else
  # Argument provided - switch to specific shell
  switch_to_shell "$1"
fi
