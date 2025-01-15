if status is-interactive
    # Commands to run in interactive sessions can go here
end

export PATH="~/.local/bin:$PATH"

export EDITOR=nano
export VISUAL=nano

starship init fish | source

source ~/.asdf/asdf.fish
