# Tmux Statusline

![screenshot](./images/screenshot.png)

A minimal, grayscale tmux statusline focused on clarity and low visual noise.

Inspired by [wfxr/tmux-power](https://github.com/wfxr/tmux-power/tree/master), but simplified and opinionated. Unlike tmux-power, this statusline favors a fixed, minimal layout over extensive configurability, aiming for simplicity while will also (probably) serve me as a solid starting point for building other custom statusline.

## Features

- Clean palette
- Powerline-style separators
- Session & window awareness
- Prefix/zoom indicators
- Pane title on the right for context
- Optional Pomodoro integration
- Per-environment overrides (color, icon, label, decorators) for distinguishing machines at a glance

## Requirements

- tmux ≥ 3.2
- Nerd Font (for icons and separators)
- True color terminal recommended
- [`fzf`](https://github.com/junegunn/fzf) — only for the interactive theme picker

## Installation (TPM)

```
set -g @plugin 'jpinilloslr/tmux-statusline'
```

Reload tmux environment:

```
tmux source-file ~/.tmux.conf
```

## Configuration

| Option                        | Default   | Description                                                |
| ----------------------------- | --------- | ---------------------------------------------------------- |
| `@statusline-theme`           | `mono`    | Named palette; individual `*-color` options override it    |
| `@statusline-accent-color`    | `#888888` | Accent color (session block, windows, decorators, borders) |
| `@statusline-prefix-color`    | `#888888` | Color of the leading prefix block and trailing pane block  |
| `@statusline-bg-color`        | `#262626` | Bar background and dark text on the pills/active window    |
| `@statusline-segment-color`   | `#3a3a3a` | Raised segments (session, session count, inactive windows) |
| `@statusline-border-color`    | `#444444` | Inactive pane borders and display-panes numbers            |
| `@statusline-fg-color`        | `#626262` | Default bar text and copy-mode text                        |
| `@statusline-muted-color`     | `#767676` | Status-left/right base foreground (fallback)               |
| `@statusline-prefix-icon`     | ``       | Glyph shown in the leading block when prefix is inactive   |
| `@statusline-prefix-label`    | (empty)   | Optional short label rendered next to the prefix icon      |
| `@statusline-decorator-right` | ``       | Right-pointing segment separator                           |
| `@statusline-decorator-left`  | ``       | Left-pointing segment separator                            |

Example: per-host coloring and labeling so the same statusline reads differently across machines (drop into `~/.config/tmux/local.conf` or equivalent):

```
set -g @statusline-prefix-color '#0ea5e9'
set -g @statusline-prefix-icon  ''
set -g @statusline-prefix-label 'host'
set -g @statusline-decorator-right ''
set -g @statusline-decorator-left  ''
```

## Themes

A theme supplies the whole palette in one option. Individual `@statusline-*-color`
options still override whatever the theme sets, so you can pick a theme and tweak a
single color per host.

```
set -g @statusline-theme 'mono'
```

Available themes:

Dark:

- `mono` - minimal grayscale (default)
- `tokyonight` - Tokyo Night
- `tokyonight-storm` - Tokyo Night Storm
- `catppuccin` - Catppuccin Mocha
- `nord` - Nord
- `gruvbox` - Gruvbox dark
- `gruvbox-material` - Gruvbox Material
- `rosepine` - Rosé Pine
- `dracula` - Dracula
- `everforest` - Everforest (dark medium)
- `kanagawa` - Kanagawa Wave
- `onedark` - One Dark
- `solarized` - Solarized Dark
- `oxocarbon` - Oxocarbon (IBM Carbon)
- `ayu` - Ayu Mirage
- `nightfox` - Nightfox
- `monokai` - Monokai Pro

Light:

- `catppuccin-latte` - Catppuccin Latte
- `rosepine-dawn` - Rosé Pine Dawn
- `solarized-light` - Solarized Light

### Picking a theme interactively

The plugin registers a `statusline-theme` command. From inside a tmux session,
press `prefix` + `:` and type:

```
statusline-theme
```

This opens an fzf popup to browse themes with a **live preview** - the status bar
re-renders as you move through the list. `Enter` keeps the highlighted theme,
`ESC` restores the one you started with.

The choice is **persisted automatically** and survives restarts: it is saved to
`${XDG_STATE_HOME:-~/.local/state}/tmux-statusline/theme`, which the plugin reads
on load. A saved pick takes precedence over `@statusline-theme`; pick the
`● use config default` entry at the top of the list to clear it and fall back to
your configured theme.

The picker requires [`fzf`](https://github.com/junegunn/fzf). You can also run it
directly:

```
~/.config/tmux/plugins/tmux-statusline/theme-picker.sh
```

To add one, drop a `themes/<name>.sh` file that sets the palette variables:

```
# themes/<name>.sh
t_AC='#888888'  # accent
t_PC='#888888'  # prefix
t_G1='#262626'  # bg
t_G2='#3a3a3a'  # segment
t_G3='#444444'  # border
t_G4='#626262'  # fg
t_G5='#767676'  # muted
```

An unknown theme name falls back to `mono`.

## Optional Extensions

Pomodoro support (used if available):

```
set -g @plugin 'olimorris/tmux-pomodoro-plus'
```
