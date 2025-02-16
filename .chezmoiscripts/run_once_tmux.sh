#!/bin/sh

## Install Tmux
if ! command -v tmux >/dev/null 2>&1; then
    echo "Installing tmux..."
    sudo apt install tmux
else
    echo "tmux already installed, installation skipped"
    echo "version: $(tmux -V)"
fi

## Install Tmux Plugin Manager
if [ ! -e  ~/.tmux/plugins/ ]; then
    echo "Installing tpm..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo "tmp already installed, installation skipped"
fi
