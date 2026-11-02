if test -d /opt/homebrew/opt/sdkman-cli/libexec
    set -gx SDKMAN_DIR /opt/homebrew/opt/sdkman-cli/libexec
else if test -d $HOME/.sdkman
    set -gx SDKMAN_DIR $HOME/.sdkman
else
    set -e SDKMAN_DIR
end

# TODO: Remove these API exports once sdkman-for-fish fixes SDKMAN initialization.
# For more information: https://github.com/reitzig/sdkman-for-fish/issues/111
set -gx SDKMAN_CANDIDATES_API https://api.sdkman.io/2
set -gx SDKMAN_BROKER_API https://broker.sdkman.io
