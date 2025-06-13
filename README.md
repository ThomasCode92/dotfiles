# Dotfiles - Fishy Terminal Setup

Repository to manage dotfiles with [chezmoi](https://www.chezmoi.io/).

## Introduction ✨🎨

This repository contains my personal dotfiles, optimized for a productive and visually appealing terminal experience. It features [Fish shell](https://fishshell.com/) paired with the [Starship prompt](https://starship.rs/), a fast, customizable, and minimalistic prompt for any shell.

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

## install rustup, needed for Yazi
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup update
```

#### Password Manager Setup 🔐🗝️

A _password manager_, called [`pass`](https://www.passwordstore.org/), will be used to manage encrypted passwords and API keys. These will be stored in a local directory at `~/.password-store`. The password store will be initialized during `chezmoi init`, but GPG keys must be imported beforehand.
To handle GPG keys, create a `backup-keys` folder in the directory. Save the private and public keys as `private-key.asc` and `public-key.asc`, respectively. Then, import the keys into your GPG keyring using the following commands:

```bash
# Import GPG keys
gpg --import ~/backup-keys/private-key.asc
gpg --import ~/backup-keys/public-key.asc

# Export the key ID for initial setup
gpg -K  # Locate and copy the key ID for password management
export PASS_GPG_KEY=<PASS_GPG_KEY>
```

Replace `<PASS_GPG_KEY>` with the actual key ID copied from the previous command.

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

### Terminal - Ghostty 🖥️👻

[Ghostty](https://ghostty.org/) is a fast, feature-rich, and cross-platform terminal emulator that uses platform-native UI and GPU acceleration.

## Code Editing

### VS Code

_Coming Soon_

### Neovim with lazy.nvim 💤

_Coming Soon_

### tmux 📟

[Tmux](https://github.com/tmux/tmux/wiki) is a terminal multiplexer for managing multiple sessions in one window. It supports pane splitting, persistent sessions, and seamless task switching—even after disconnection.

## Resources 📚🔗

- **Chezmoi**: [Official Website](https://www.chezmoi.io/) - [GitHub Repository](https://github.com/twpayne/chezmoi)
- **Fish Shell**: [Official Website](https://fishshell.com/) - [Documentation](https://fishshell.com/docs/current/)
- **Starship**: [Official Website](https://starship.rs/) - [Configuration](https://starship.rs/config/)
- **Fisher**: [Fisher GitHub](https://github.com/jorgebucaran/fisher)
