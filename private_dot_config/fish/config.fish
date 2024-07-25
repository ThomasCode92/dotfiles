if status is-interactive
    # Commands to run in interactive sessions can go here
end

export PATH="~/.local/bin:$PATH"

export EDITOR=nano
export VISUAL=nano
export JAVA_OPTS="$JAVA_OPTS -Dspring.profiles.active=local"

starship init fish | source
source ~/.asdf/asdf.fish
source ~/.asdf/plugins/dotnet/set-dotnet-env.fish
