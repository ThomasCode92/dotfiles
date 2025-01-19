#!/bin/sh

# Install starship
curl -sS https://starship.rs/install.sh | sh

# Install asdf plugins for fish
mkdir -p ~/.config/fish/completions
ln -sf ~/.asdf/completions/asdf.fish ~/.config/fish/completions
