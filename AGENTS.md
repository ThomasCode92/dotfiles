# Agent Guidelines for Chezmoi Dotfiles Repository

## Build/Test/Lint Commands
- **Apply all dotfiles**: `chezmoi apply` (sync all changes to home directory)
- **Apply single file**: `chezmoi apply ~/.config/nvim/init.lua`
- **Preview changes**: `chezmoi diff` (show what would change)
- **Edit then apply**: `chezmoi edit --apply <file>` (edit source and apply in one command)
- **Validate setup**: `chezmoi verify` and `chezmoi doctor`
- **Format JSON/Markdown**: `prettier --write <file>` (80 char width, prose wrap)
- **Format Lua**: `stylua .` in nvim directory (2 spaces, 120 columns)

## Code Style Guidelines
- **Bash scripts** (.sh): Use `#!/bin/bash`, check with `command -v`, use `is_package_installed()` helper, emoji logging (✅🦀📦⏭️🔧🦇🧭🐢🔌🐙📁🎨), redirect stderr with `&>/dev/null`, use double brackets `[[ ]]` for conditionals
- **Fish scripts** (.fish): Use `#!/usr/bin/env fish`, check with `if not command -v`, use `set` for variables, redirect with `>/dev/null` or `2>&1`, use `function` and `end` blocks
- **Fish config**: Spaces for indentation, `export` for env vars, `alias` for shortcuts, `function` for complex logic, source external tools with `| source`
- **Lua (Neovim)**: 2-space indent, 120 column width, minimal comments, follow LazyVim conventions
- **TOML/Config files**: Grouped sections with blank lines, consistent key formatting
- **Chezmoi templates**: Use `{{- ... -}}` for no whitespace, `{{ .variable }}` for data access, `.tmpl` extension for conditional files, use `promptBoolOnce` and `promptStringOnce` for interactive prompts

## File Organization & Naming
- Install scripts: `.chezmoiscripts/run_once_<name>.sh` (runs once per content change)
- Update scripts: `.chezmoiscripts/run_onchange_<name>.sh.tmpl` (runs on template variable change)
- Config files: `private_dot_config/<app>/` maps to `~/.config/<app>/`
- Hidden files: `dot_` prefix (e.g., `dot_gitconfig` → `~/.gitconfig`)

## Error Handling
- **Bash**: Check command existence: `if ! command -v tool &>/dev/null; then ... fi`
- **Fish**: Check command existence: `if not command -v tool >/dev/null; then ... end`
- Check package installation: `if ! is_package_installed "pkg"; then ... fi` (bash scripts)
- Always validate before operations: directory existence, file permissions, git status