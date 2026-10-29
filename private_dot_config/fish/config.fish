if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -g fish_key_bindings fish_vi_key_bindings # vi mode

echo y | fish_config theme save catppuccin-mocha >/dev/null 2>&1

starship init fish | source
zoxide init fish | source
atuin init fish --disable-up-arrow | source
carapace _carapace | source

# enable transience, using starship
enable_transience

# update $PATH
fish_add_path "$HOME/.opencode/bin"

# environment variables
set -gx PATH ~/.local/bin $PATH
set -gx EDITOR nvim
set -gx VISUAL nvim
set -Ux CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense'

# remove duplicate and missing PATH entries
set -l clean_path
for dir in $PATH
    if test -d $dir; and not contains -- $dir $clean_path
        set -a clean_path $dir
    end
end
set -gx PATH $clean_path

# aliases
alias lz="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias lg="lazygit"
alias ld="lazydocker"
alias wm="workmux"
