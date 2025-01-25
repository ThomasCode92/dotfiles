#!/usr/bin/env fish

## install kitty
if not command -v kitty >/dev/null; then
    echo "Installing kitty..."
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
else
    echo "kitty already installed, installation skipped"
    echo "version: $(kitty --version)"
end

## install ghostty
if not command -v ghostty >/dev/null; then
    echo "Installing ghostty..."
    set ARCH (dpkg --print-architecture)
    set VERSION_ID (lsb_release -rs)
    set GHOSTTY_DEB_URL (
        curl -s https://api.github.com/repos/mkasberg/ghostty-ubuntu/releases/latest | \
        grep -oP "https://github.com/mkasberg/ghostty-ubuntu/releases/download/[^\s/]+/ghostty_[^\s/_]+_"$ARCH"_"$VERSION_ID".deb"
    )
    set GHOSTTY_DEB_FILE (basename "$GHOSTTY_DEB_URL")
    curl -L "$GHOSTTY_DEB_URL" -o "$GHOSTTY_DEB_FILE"
    sudo dpkg -i "$GHOSTTY_DEB_FILE"
    rm "$GHOSTTY_DEB_FILE"
else
    echo "ghostty already installed, installation skipped"
    echo "version: $(ghostty --version)"
end
