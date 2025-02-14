#!/usr/bin/env fish

if not command -v lazygit >/dev/null; then
    echo "Installing lazygit..."
    set LAZYGIT_VERSION $(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v"$LAZYGIT_VERSION"/lazygit_"$LAZYGIT_VERSION"_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit -D -t /usr/local/bin/
    rm lazygit.tar.gz lazygit
else
    echo "lazygit already installed, installation skipped"
    echo "version: $(lazygit --version)"
end
