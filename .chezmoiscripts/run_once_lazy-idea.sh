#!/bin/bash

# Install lazy-idea: LazyVim key mappings for JetBrains IDEs
# https://github.com/cufarvid/lazy-idea

LAZY_IDEA_DIR="$HOME/.lazy-idea"

echo "🧭 Setting up lazy-idea for IntelliJ IDEA..."

# Clone or update lazy-idea repository
if [ ! -d "$LAZY_IDEA_DIR" ]; then
    echo "📦 Cloning lazy-idea repository..."
    if git clone https://github.com/cufarvid/lazy-idea.git "$LAZY_IDEA_DIR" &>/dev/null; then
        echo "✅ lazy-idea cloned successfully to ~/.lazy-idea"
    else
        echo "❌ Failed to clone lazy-idea repository"
        exit 1
    fi
else
    echo "📁 lazy-idea already exists, updating..."
    cd "$LAZY_IDEA_DIR" || exit 1
    if git pull &>/dev/null; then
        echo "✅ lazy-idea updated successfully"
    else
        echo "⏭️  lazy-idea update skipped (no changes or offline)"
    fi
fi

# Check if .ideavimrc exists and is managed by chezmoi
if [ -f "$HOME/.ideavimrc" ]; then
    echo "✅ .ideavimrc found"
else
    echo "⚠️  .ideavimrc not found - run 'chezmoi apply' to create it"
fi

echo ""
echo "🎨 Required JetBrains plugins (install from Marketplace):"
echo "   1. IdeaVim - https://plugins.jetbrains.com/plugin/164-ideavim"
echo "   2. Which-Key - https://plugins.jetbrains.com/plugin/15976-which-key"
echo "   3. EasyMotion - https://plugins.jetbrains.com/plugin/13360-ideavim-easymotion"
echo ""
echo "✅ lazy-idea setup complete! Restart your JetBrains IDE to apply changes."
