# Repository Guidelines

## Project Structure & Module Organization

This repository manages personal dotfiles with chezmoi for macOS and Arch Linux.
Root-level `dot_*` files become home-directory dotfiles; `private_dot_config/`
maps to `~/.config/` and contains Fish, Neovim, tmux-adjacent tools, and desktop
configuration. Neovim Lua modules live in `private_dot_config/nvim/lua/`.

`.chezmoiscripts/` contains installation and configuration hooks. `bootstrap.sh`
selects `bootstrap-macos.sh` or `bootstrap-arch.sh`. `scripts/` contains
utilities, including GPG backup. Package and runtime lists live in
`private_dot_config/homebrew/Brewfile` and `dot_tool-versions`.

## Build, Test, and Development Commands

There is no application build step. Run commands from the repository root:

- `chezmoi diff`: preview differences between source files and installed
  dotfiles.
- `chezmoi apply --dry-run --verbose`: preview application actions.
- `chezmoi apply`: install configuration changes and execute eligible hooks.
- `DOTFILES_LOCAL=1 bash bootstrap.sh`: bootstrap using local OS scripts; this
  installs packages, imports GPG keys, and applies dotfiles.

## Commit & Pull Request Guidelines

Follow the Git history's Conventional Commit pattern, for example
`feat(nvim): add navigation mappings` or `chore(fish): remove unused plugin`.
Use `/draft-commit-message` to draft a commit message.
