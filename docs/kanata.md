# ⌨️ Kanata - Keyboard Remapping Setup

## 🍎 Installation and Background Services on MacOS

Kanata comes from the Brewfile; the hook installs DriverKit v6.2.0 and boot
services. Keep the driver version compatible with Kanata (currently 1.12.0).

```sh
chezmoi apply --exclude scripts "$HOME/.config/kanata"
chezmoi apply --source-path \
  "$(chezmoi source-path)/.chezmoiscripts/run_once_after_kanata.sh.tmpl"
```

In **System Settings**, allow Kanata under **Privacy & Security → Input
Monitoring**. Approve the driver and background helper under **General → Login
Items & Extensions**.

After config changes or connecting an external keyboard, confirm the keyboard is
listed, then restart Kanata (not the setup hook):

```sh
kanata --list
sudo launchctl kickstart -k system/com.my.kanata
```

Logs: `/Library/Logs/Kanata/`.

## 🐧 Installation and User Service on Arch Linux

Requires `yay` and upstream
[input/uinput permissions](https://github.com/jtroo/kanata/blob/main/docs/setup-linux.md).
The hook installs `kanata-bin` and enables a systemd user service.

```sh
chezmoi apply --exclude scripts "$HOME/.config/kanata"
chezmoi apply --source-path \
  "$(chezmoi source-path)/.chezmoiscripts/run_once_after_kanata.sh.tmpl"
```

After config changes, restart; check status and logs as needed:

```sh
systemctl --user restart kanata.service
systemctl --user status kanata.service
journalctl --user -u kanata.service -b
```
