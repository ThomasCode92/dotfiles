if test -d /opt/homebrew/opt/sdkman-cli/libexec
    set -gx SDKMAN_DIR /opt/homebrew/opt/sdkman-cli/libexec
else if test -d /home/linuxbrew/.linuxbrew/opt/sdkman-cli/libexec
    set -gx SDKMAN_DIR /home/linuxbrew/.linuxbrew/opt/sdkman-cli/libexec
else if test -d $HOME/.sdkman
    set -gx SDKMAN_DIR $HOME/.sdkman
else
    set -e SDKMAN_DIR
end
