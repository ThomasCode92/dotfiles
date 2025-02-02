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

To install a new plugin (e.g. [autopair.fish](https://github.com/jorgebucaran/autopair.fish)), simply follow these steps:

```bash
chezmoi edit $__fish_config_dir/fish_plugins --apply # add jorgebucaran/autopair.fish
chezmoi apply
```

### Terminal Emulator (Kitty, for now) 🖥️🐈

[Kitty](https://sw.kovidgoyal.net/kitty/) is a fast, feature-rich, and GPU-accelerated terminal emulator. Kitty offers _GPU rendering_ for fast performance, _multi-layout support_ with tabs and splits, and highly customizable _themes and shortcuts_.

#### Ghostty 🖥️👻

[Ghostty](https://ghostty.org/) is a fast, feature-rich, and cross-platform terminal emulator that uses platform-native UI and GPU acceleration.

## Neovim and tmux 📜🌀

_coming soon_

## Overall Theming 🎨🍮

The [Catppuccin](https://github.com/catppuccin/catppuccin) theme is a popular, soothing pastel color scheme with variants like Latte, Frappé, Macchiato, and Mocha to suit different preferences. It’s highly versatile, supporting code editors (VS Code, Neovim), terminals (Kitty, Ghostty), browsers (Firefox, Chrome), and more, ensuring a consistent look across tools. Its open-source, community-driven nature means frequent updates and ports for new applications. Easy to install and customize, Catppuccin is ideal for developers and designers seeking a modern, cohesive, and aesthetically pleasing theme for long work sessions. Its popularity and community support, makes it a top choice for workflow customization.

## Resources 📚🔗

- **Fish Shell**: [Official Website](https://fishshell.com/) - [Documentation](https://fishshell.com/docs/current/)
- **Starship**: [Official Website](https://starship.rs/) - [Configuration](https://starship.rs/config/)
- **Fisher**: [Fisher GitHub](https://github.com/jorgebucaran/fisher)
- **Chezmoi**: [Official Website](https://www.chezmoi.io/) - [GitHub Repository](https://github.com/twpayne/chezmoi)
