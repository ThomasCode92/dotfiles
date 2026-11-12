if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_config theme choose catppuccin-mocha --color-theme=dark
end

starship init fish | source
zoxide init fish | source
atuin init fish --disable-up-arrow | source
carapace _carapace | source

# environment variables
set -gx PATH ~/.local/bin $PATH
set -gx EDITOR nvim
set -gx VISUAL nvim
set -Ux CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense'

set -g fish_key_bindings fish_vi_key_bindings # vi mode
set -g fzf_directory_opts --bind "ctrl-o:execute($EDITOR {} &> /dev/tty)"
set fzf_fd_opts --hidden --max-depth 5
set fzf_preview_dir_cmd eza --all --color=always --icons=always

enable_transience
fzf_configure_bindings --git_log=ctrl-alt-g --variables=ctrl-alt-v

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
