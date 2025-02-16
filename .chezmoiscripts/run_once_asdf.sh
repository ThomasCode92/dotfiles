#!/bin/sh

## Install asdf
if [ ! -d ~/.asdf ]; then
    echo "Installing asdf..."
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.15.0
else
    echo "asdf already installed, installation skipped"
    echo "version: $(asdf --version)"
fi
