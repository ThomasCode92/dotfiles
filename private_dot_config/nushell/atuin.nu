# Initialize Atuin
# Creates init script if it doesn't exist, then sources it
# For more information, see: https://docs.atuin.sh/guide/installation/#installing-the-shell-plugin

if not ($"($env.HOME)/.local/share/atuin/init.nu" | path exists) {
    mkdir ~/.local/share/atuin/
    atuin init nu --disable-up-arrow | save ~/.local/share/atuin/init.nu
}

source ~/.local/share/atuin/init.nu
