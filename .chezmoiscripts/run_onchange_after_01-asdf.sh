#!/bin/bash

set -euo pipefail

# Path to the tool-versions file (default: .tool-versions in current dir)
TOOL_VERSIONS_FILE="${1:-.tool-versions}"

if [[ ! -f "$TOOL_VERSIONS_FILE" ]]; then
  echo "❌ Error: file '$TOOL_VERSIONS_FILE' not found."
  exit 1
fi

echo "📄 Reading tools from: $TOOL_VERSIONS_FILE"
echo "----------------------------------------"

while IFS= read -r line || [[ -n "$line" ]]; do
  # Skip empty lines and comments
  [[ -z "$line" || "$line" == \#* ]] && continue

  plugin=$(echo "$line" | awk '{print $1}')
  version=$(echo "$line" | awk '{print $2}')

  echo ""
  echo "🔧 Plugin: $plugin  Version: $version"

  # Add plugin if not already added
  if asdf plugin list 2>/dev/null | grep -qx "$plugin"; then
    echo "    ⏭️  Plugin '$plugin' already added."
  else
    echo "    ➕ Adding plugin '$plugin'..."
    asdf plugin add "$plugin"
  fi

  # Install the specific version
  if asdf list "$plugin" 2>/dev/null | grep -q "^\s*${version}$"; then
    echo "    ⏭️  '$plugin $version' already installed."
  else
    echo "    📦 Installing '$plugin $version'..."
    asdf install "$plugin" "$version"
  fi

done <"$TOOL_VERSIONS_FILE"

echo ""
echo "----------------------------------------"
echo "✅ Done. All plugins and versions processed."
