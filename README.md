# Dotfiles - Fishy Terminal Setup

Repository to manage dotfiles with [chezmoi](https://www.chezmoi.io/).

## Introduction ✨🎨

This repository contains my personal dotfiles, optimized for a productive and visually appealing terminal experience. It features [Fish shell](https://fishshell.com/) paired with the [Starship prompt](https://starship.rs/), a fast, customizable, and minimalistic prompt for any shell. Fish provides user-friendly scripting, autosuggestions, and syntax highlighting, while Starship enhances the terminal with a sleek, informative interface. Together, they create a streamlined environment for developers and enthusiasts alike.

## Setup ⚙️🔧

This section covers how to set up and sync these dotfiles to your system. Follow the steps below to get started.

### Prerequisites 🛠️📦

```bash
## install fish
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt install fish

chsh -s $(which fish) # set default shell

## install fisher, a plugin manager
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
```

### Syncing Dotfiles with Chezmoi 🔄📁

```bash
## install and init chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply ThomasCode92
```

## Fish and Fisher 🐟🪝

_coming soon_

### Tools, Plugins and Commands ⚡⌨️

### Terminal (Kitty, for now) 🖥️🐈

## Neovim and Tmux 📜🌀

_coming soon_

## Overall Theming 🌃🎴

_More about Tokyo Night coming soon_
