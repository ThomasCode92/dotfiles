if status is-interactive
    # Commands to run in interactive sessions can go here
end

# set the key bindings to use vi mode
fish_vi_key_bindings

# set a catppuccin theme
echo y | fish_config theme save catppuccin-mocha >/dev/null 2>&1

# source applications
starship init fish | source
zoxide init fish | source
source ~/.asdf/asdf.fish

# environment variables
set -gx PATH ~/.local/bin $PATH
set -gx EDITOR nvim
set -gx VISUAL nvim

# aliases
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias lg="lazygit"
alias ld="lazydocker"
alias swsh="~/scripts/switch_shell.sh"

# search shell history with atuin
atuin init fish --disable-up-arrow | source

# set java home, via asdf
source ~/.asdf/plugins/java/set-java-home.fish
