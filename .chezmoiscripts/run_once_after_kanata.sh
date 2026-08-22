#!/bin/bash

if [[ "$(uname -s)" == "Darwin" ]]; then
  sudo cp /Users/$(whoami)/.config/kanata/com.my.kanata.plist /Library/LaunchDaemons/

  sudo launchctl load /Library/LaunchDaemons/com.my.kanata.plist
  sudo launchctl start com.my.kanata
fi

if [[ "$(uname -s)" == "Linux" ]]; then
  mkdir -p "$HOME/.local/bin"

  if ! command -v kanata &>/dev/null; then
    echo "📥 Installing kanata"
    curl -fLo ~/kanata.zip https://github.com/jtroo/kanata/releases/latest/download/linux-binaries-x64.zip
    unzip -p ~/kanata.zip kanata_linux_x64 >"$HOME/.local/bin/kanata"
    chmod +x "$HOME/.local/bin/kanata"
    rm ~/kanata.zip
  fi

  echo "📄 Using config file at ~/.config/kanata/config.kbd"
  DIR="$HOME/.config/systemd/user/"
  mkdir -p "$DIR"
  cp "$HOME/.config/kanata/kanata.service" "$DIR"

  echo "⚙️ Setting up system service"
  systemctl --user daemon-reload
  systemctl --user enable kanata.service
  systemctl --user restart kanata.service
  systemctl --user status kanata.service # check whether the service is running

  echo "✅ Kanata installation complete"
fi
