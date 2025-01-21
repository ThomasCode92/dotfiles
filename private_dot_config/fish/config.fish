if status is-interactive
    # Commands to run in interactive sessions can go here
end

export PATH="~/.local/bin:$PATH"

starship init fish | source
source ~/.asdf/asdf.fish

export EDITOR=nano
export VISUAL=nano
