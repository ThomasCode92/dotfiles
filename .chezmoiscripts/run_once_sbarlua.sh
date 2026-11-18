#!/usr/bin/env bash

# This is only needed once to install the sketchybar module
# (or for an update of the module)

set -e

if [ ! -d "$HOME/.local/share/sketchybar_lua/" ]; then
  git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua
  (cd /tmp/SbarLua/ && make install)
  rm -rf /tmp/SbarLua/
fi
