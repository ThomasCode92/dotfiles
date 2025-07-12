# Dotfiles - Fishy Terminal Setup

Repository to manage dotfiles with [chezmoi](https://www.chezmoi.io/).

## Introduction ✨🎨

This repository contains my personal dotfiles, optimized for a productive and
visually appealing terminal experience. It features
[Fish shell](https://fishshell.com/) paired with the
[Starship prompt](https://starship.rs/), a fast, customizable, and minimalistic
prompt for any shell.

## Setup ⚙️🔧

This section covers how to set up and sync these dotfiles to your system. Follow
the steps below to get started.

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

A _password manager_, called [`pass`](https://www.passwordstore.org/), will be
used to manage encrypted passwords and API keys. These will be stored in a local
directory at `~/.password-store`. The password store will be initialized during
`chezmoi init`, but GPG keys must be imported beforehand. To handle GPG keys,
create a `backup-keys` folder in the directory. Save the private and public keys
as `private-key.asc` and `public-key.asc`, respectively. Then, import the keys
into your GPG keyring using the following commands:

```bash
# Import GPG keys
gpg --import ~/backup-keys/private-key.asc
gpg --import ~/backup-keys/public-key.asc

# Export the key ID for initial setup
gpg -K  # Locate and copy the key ID for password management
export PASS_GPG_KEY=<PASS_GPG_KEY>
```

Replace `<PASS_GPG_KEY>` with the actual key ID copied from the previous
command.

### Syncing Dotfiles with Chezmoi 🔄📁

```bash
## install and init chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply ThomasCode92
```

## Fish and Fisher 🐟🪝

_coming soon_

### Tools, Plugins and Commands ⚡⌨️

To install a new plugin (e.g.
[autopair.fish](https://github.com/jorgebucaran/autopair.fish)), simply follow
these steps:

```bash
chezmoi edit $__fish_config_dir/fish_plugins --apply # add jorgebucaran/autopair.fish
chezmoi apply
```

### Terminal - Ghostty 🖥️👻

[Ghostty](https://ghostty.org/) is a fast, feature-rich, and cross-platform
terminal emulator that uses platform-native UI and GPU acceleration.

## Keyboard Remapping ⌨️🔄

This setup uses a custom keyboard remapping configuration to enhance
productivity by modifying the behavior of the Caps Lock key to function as an
additional escape key and left control key. This is done with the help of
[Kanata](https://github.com/jtroo/kanata).

### Running Kanata as a Service

Create a _systemd_ service file at `~/.config/systemd/user/kanata.service` and
place the following content in it:

```ini
  [Unit]
  Description=Kanata keyboard remapper
  Documentation=<https://github.com/jtroo/kanata>

  [Service]
  Type=simple ExecStart=/home/%u/.local/share/bin/kanata Restart=no

  [Install] WantedBy=default.target </code>
```

To enable the service, run:

```bash
systemctl --user enable kanata.service
systemctl --user start kanata.service
```

## Neovim and tmux 📜🌀

### LazyVim 💤

This setup includes [LazyVim](https://www.lazyvim.org/) , a Neovim distribution
that enhances the editing experience with smart defaults, performance
optimizations, and a modular plugin system. By leveraging _lazy-loading_, it
ensures minimal startup times while delivering a powerful, IDE-like environment.

### 📟 Tmux

[Tmux](https://github.com/tmux/tmux/wiki) is a terminal multiplexer for managing
multiple terminal sessions within a single window. It supports split panes,
persistent sessions, and efficient task switching. Often paired with Neovim, it
enables smooth navigation between tools and can be customized with themes,
keybindings, and a status bar.

## 🎨 Catppuccin Theme

This setup is styled with [Catppuccin](https://catppuccin.com/)'s Mocha theme.
It offers broad support across editors, terminals, and browsers for a cohesive
visual experience. Designed for easy customization, it is actively maintained
and widely adopted in modern development environments.

## Resources 📚🔗

- **Chezmoi**: [Official Website](https://www.chezmoi.io/) -
  [GitHub Repository](https://github.com/twpayne/chezmoi)
- **Fish Shell**: [Official Website](https://fishshell.com/) -
  [Documentation](https://fishshell.com/docs/current/)
- **Starship**: [Official Website](https://starship.rs/) -
  [Configuration](https://starship.rs/config/)
- **Fisher**: [Fisher GitHub](https://github.com/jorgebucaran/fisher)

### Kanata Specific Resources

- [escapecontrol: Kanata config for Linux](https://github.com/dreamsofcode-io/escapecontrol/blob/main/linux/kanata/README.md)
- [Using Kanata to Remap Any Keyboard – shom.dev](https://shom.dev/start/using-kanata-to-remap-any-keyboard/)
