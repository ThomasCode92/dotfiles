# SketchyBar Overview

This macOS status bar uses
[SketchyBar](https://github.com/FelixKratz/SketchyBar) with
[SbarLua](https://github.com/FelixKratz/SbarLua) for Lua configuration and event
callbacks. Its modular layout follows
[FelixKratz's dotfiles](https://github.com/FelixKratz/dotfiles/tree/master/.config/sketchybar).

The source lives in `private_dot_config/sketchybar/`; chezmoi deploys it to
`~/.config/sketchybar/`. AeroSpace starts the bar, rather than a Homebrew
service.

## Configuration Layout

Paths below are relative to `private_dot_config/sketchybar/`.

| File or directory          | Responsibility                                                                                                                      |
| -------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| `executable_sketchybarrc`  | Lua entry point, deployed as executable `sketchybarrc`. Loads `helpers`, then `init`.                                               |
| `helpers/init.lua`         | Adds `~/.local/share/sketchybar_lua/?.so` to Lua's native module search path.                                                       |
| `init.lua`                 | Loads SbarLua, applies `bar`, `default`, and `items` in one configuration transaction, enables hot reload, and runs the event loop. |
| `bar.lua`                  | Bar placement and dimensions: top of screen, 32 pixels high, with horizontal padding.                                               |
| `default.lua`              | Shared item styling, fonts, padding, backgrounds, and popup appearance. Loaded before items are created.                            |
| `settings.lua`             | Shared spacing, icon selection, and font configuration.                                                                             |
| `helpers/default_font.lua` | Text and number font families, plus the shared font style map.                                                                      |
| `colors.lua`               | Bar, item, popup, and status colors.                                                                                                |
| `icons.lua`                | SF Symbols and alternative Nerd Font glyphs, selected through `settings.icons`.                                                     |
| `items/init.lua`           | Registers the top-level items and widgets.                                                                                          |
| `items/widgets/init.lua`   | Registers battery and volume widgets.                                                                                               |

Lua callbacks handle system events and periodic updates. The event loop keeps
those callbacks active after the initial configuration has been applied.

## Current Items

| Module                      | Behavior                                                                                                                                                                                                      |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `items/apple.lua`           | Apple icon with a double-border background. Currently decorative, with no click action.                                                                                                                       |
| `items/calendar.lua`        | Date and time on the right, refreshed every 30 seconds and on wake. Clicking opens Calendar.                                                                                                                  |
| `items/widgets/battery.lua` | Charge percentage and charging/low-battery icons, read through `pmset`. Refreshes every three minutes, on power-source changes, and on wake. Clicking toggles a remaining-time popup.                         |
| `items/widgets/volume.lua`  | Volume percentage and icon, updated by volume-change events. Clicking opens a slider and output-device picker; right-clicking opens Sound settings. Scrolling adjusts volume, with Control for finer changes. |

Some items use automatically generated names. Explicit widget names include
`widgets.battery`, `widgets.volume1` (percentage), and `widgets.volume2` (icon).

## Fonts and Appearance

`settings.font` loads `helpers/default_font.lua`, which separates fonts by use:

- **Text and SF Symbols:** `SF Pro`.
- **Numbers:** `JetBrainsMono Nerd Font`, used by the time, battery percentage,
  and volume percentage.
- **Styles:** a shared `style_map` supplies named weights to defaults and items.

The current icon set is `sf-symbols`. `icons.lua` also provides a `NerdFont`
alternative; changing the icon set should be paired with a compatible text/icon
font and style map.

Colors use `0xAARRGGBB` notation. Keep the alpha component explicit: a six-digit
RGB value has zero alpha and is fully transparent. The bar background comes from
`colors.bar.bg`; item and popup colors are shared through the same module.

## Dependencies and Startup

`private_dot_config/homebrew/Brewfile` declares Lua, SketchyBar,
`switchaudio-osx` (which provides `SwitchAudioSource` for the device picker), SF
Pro, and JetBrains Mono Nerd Font. The widgets also use macOS tools such as
`pmset`, `osascript`, and `open`.

`.chezmoiscripts/run_once_sbarlua.sh` clones and builds SbarLua when
`~/.local/share/sketchybar_lua/` is absent. The native module must be compatible
with the Lua interpreter used by the entry point (`#!/usr/bin/env lua`).

Startup is configured in `private_dot_config/aerospace/aerospace.toml`:

- `after-startup-command` launches `sketchybar` when AeroSpace starts.
- In **service binding mode**, `alt-shift-r` starts SketchyBar if it is stopped
  or reloads its configuration if it is already running.
- Enter service mode with `alt-shift-semicolon`; press `esc` to reload the
  AeroSpace configuration and return to main mode.

The SketchyBar shortcut is not a main-mode binding. Reloading AeroSpace's
configuration does not rerun its startup commands. Keep the Homebrew service
disabled to avoid competing launch mechanisms; AeroSpace startup does not
provide automatic crash recovery.

## Editing and Reloading

Edit the chezmoi source rather than the deployed files, then apply just this
configuration without running installation hooks:

```sh
chezmoi apply --exclude scripts "$HOME/.config/sketchybar"
```

`sbar.hotload(true)` enables automatic reload when deployed configuration files
change. Saving only the source file does not update the running bar until
chezmoi applies it. A manual reload is also available while the daemon is
running:

```sh
sketchybar --reload
```

To extend the bar, add an item module under `items/` (or `items/widgets/`) and
require it from the corresponding `init.lua`. Keep reusable appearance settings
in `default.lua`, `settings.lua`, `colors.lua`, or the font helper instead of
duplicating them in each item.

## Basic Checks

```sh
# Daemon and Lua configuration process
pgrep -fl sketchybar
pgrep -fl sketchybarrc

# Applied bar configuration and item names
sketchybar --query bar

# Example named widget
sketchybar --query widgets.battery
```

If the bar is missing, first check whether the daemon is running, then inspect
the applied bar state. A Lua error or missing required module can prevent the
configuration transaction from completing. Check the `require` chain and ensure
each directory module has an `init.lua`.

For startup errors, stop the existing daemon and run `sketchybar` in a terminal
to see its output. After debugging, stop the foreground process and use the
AeroSpace service-mode shortcut to start it again through the normal path.
