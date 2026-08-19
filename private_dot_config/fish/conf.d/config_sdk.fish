if test -d /opt/homebrew/opt/sdkman-cli/libexec
    set -Ux SDKMAN_DIR /opt/homebrew/opt/sdkman-cli/libexec
else if test -d $HOME/.sdkman
    set -Ux SDKMAN_DIR $HOME/.sdkman
else
    set -e -U SDKMAN_DIR
end
