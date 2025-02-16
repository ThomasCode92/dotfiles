if status is-interactive
    # Commands to run in interactive sessions can go here
    fastfetch
    
end

export PATH="~/.local/bin:$PATH"

starship init fish | source
source ~/.asdf/asdf.fish

export EDITOR=nvim
export VISUAL=nvim

# Custom settings for fzf.fish
set --export -gx $EDITOR "nvim" # or "vim", or "code", etc.
set --export fzf_directory_opts --bind "ctrl-o:execute($EDITOR {} &> /dev/tty)"
set fzf_fd_opts --hidden --max-depth 3
