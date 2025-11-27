# config.nu
#
# Installed by:
# version = "0.107.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

# Set & configure vi-mode
$env.config.edit_mode = 'vi'          # set vi mode
$env.PROMPT_INDICATOR_VI_NORMAL = ""  # reset normal mode indicator
$env.PROMPT_INDICATOR_VI_INSERT = ""  # reset insert mode indicator
$env.config.cursor_shape = {
  vi_normal: underscore
  vi_insert: block
}

# External completions
source completers/external_completer.nu
$env.config.completions.external = {enable: true, completer: $external_completer}

$env.EZA_CONFIG_DIR = $"($env.HOME)/.config/eza" # set eza config dir

# Aliases
alias swsh = ~/scripts/switch_shell.sh

# Starship prompt
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# Source additional configuration files 
source ($nu.default-config-dir | path join "themes/catppuccin_mocha.nu")
source ($nu.default-config-dir | path join "atuin.nu")  # source atuin
source ~/.zoxide.nu                   # source zoxide
use yazi_wrapper.nu y                 # use yazi wrapper

# Source additional helper functions
source ($nu.default-config-dir | path join "helpers/load-dotenv.nu")
