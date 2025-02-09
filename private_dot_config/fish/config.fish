if status is-interactive
    # Commands to run in interactive sessions can go here
    fastfetch
end

export PATH="~/.local/bin:$PATH"

starship init fish | source
source ~/.asdf/asdf.fish

export EDITOR=nvim
export VISUAL=nvim
