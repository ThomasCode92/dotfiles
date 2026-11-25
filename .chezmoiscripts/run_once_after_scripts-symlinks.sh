#!/bin/bash

# Link every ~/scripts/*.sh into ~/.local/bin without the .sh suffix.
# ~/.local/bin is already on PATH, so each script becomes callable by its short name.

set -euo pipefail

scripts_dir="$HOME/scripts"
bin_dir="$HOME/.local/bin"

[[ -d "$scripts_dir" ]] || exit 0
mkdir -p "$bin_dir"

for script in "$scripts_dir"/*.sh; do
  [[ -e "$script" ]] || continue

  name=$(basename "$script" .sh)
  link="$bin_dir/$name"

  if [[ -e "$link" && ! -L "$link" ]]; then
    printf 'Skipping %s: a real file already exists\n' "$link" >&2
    continue
  fi

  ln -sfn "$script" "$link"
done
