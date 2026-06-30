# Dotfiles - Fishy Terminal Setup

Repository to manage dotfiles with [chezmoi](https://www.chezmoi.io/). Supports
Linux and MacOS.

> Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/),
> bootstrapped via [bootstrap.sh](./bootstrap.sh). Installs
> [Homebrew](https://brew.sh/), GPG, and chezmoi, then initializes (or updates)
> the dotfiles and a GPG key for [pass](https://www.passwordstore.org/).

## Setup ⚙️🔧

### Prerequisites 🛠️📦

Before running the script, make sure these exist on the target machine:

- `~/privatekey.asc` and `~/publickey.asc` — your GPG keypair, used to set up
  [pass](https://www.passwordstore.org/). Only needed the first time you
  bootstrap a machine (i.e. when `~/.local/share/chezmoi` doesn't exist yet).
- `GITHUB_USERNAME` environment variable set to your GitHub username, since the
  script passes it straight to `chezmoi init`.

### Syncing Dotfiles 🔄📁

```bash
export GITHUB_USERNAME=ThomasCode92
curl -fsSL https://raw.githubusercontent.com/ThomasCode92/dotfiles/main/bootstrap.sh | bash
```

## Fish and Fisher 🐟🪝

The [Fish shell](https://fishshell.com/) is a smart and user-friendly command
line shell, with [Fisher](https://github.com/jorgebucaran/fisher) a couple of
plugins can be installed to enhance the shell experience.

For a fast, customizable, and minimalistic prompt,
[starship](https://starship.rs/) is configured.

### Tools, Plugins and Commands ⚡⌨️

To install a new plugin (e.g.
[autopair.fish](https://github.com/jorgebucaran/autopair.fish)), simply follow
these steps:

```bash
chezmoi edit $__fish_config_dir/fish_plugins --apply
chezmoi apply
```
