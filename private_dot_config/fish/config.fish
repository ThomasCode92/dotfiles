if status is-interactive
    # Commands to run in interactive sessions can go here
    fastfetch
end

export PATH="~/.local/bin:$PATH"

starship init fish | source
fzf --fish | source
zoxide init fish | source
source ~/.asdf/asdf.fish

export EDITOR=nvim
export VISUAL=nvim

alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias cd="z"

# Custom settings for fzf.fish
set --export -gx $EDITOR "nvim" # or "vim", or "code", etc.
set --export fzf_directory_opts --bind "ctrl-o:execute($EDITOR {} &> /dev/tty)"
set fzf_fd_opts --hidden --max-depth 2
set fzf_preview_dir_cmd eza --all --color=always --icons=always
