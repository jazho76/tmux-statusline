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
- Per-pane badges any tool can raise, surfaced on the window that holds the pane

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
| `@statusline-badges`          | (empty)   | Space-separated badge class names; see [Badges](#badges)   |
| `@statusline-badge-separator` | (space)   | Emitted after every badge glyph                            |
| `@statusline-badge-glyph`     | `●`       | Glyph used when no classes are declared                    |
| `@statusline-badge-style`     | (empty)   | Style for that default glyph, e.g. `fg=red,bold`           |

Any option can be set to an empty string to switch that piece off, including
ones with a non-empty default such as the decorators and the prefix icon.

Example: per-host coloring and labeling so the same statusline reads differently across machines (drop into `~/.config/tmux/local.conf` or equivalent):

```
set -g @statusline-prefix-color '#0ea5e9'
set -g @statusline-prefix-icon  ''
set -g @statusline-prefix-label 'host'
set -g @statusline-decorator-right ''
set -g @statusline-decorator-left  ''
```

## Badges

Any tool can badge the pane it runs in, and the window holding that pane shows a
glyph for it. It is a way to surface background state on windows you are *not*
looking at: a finished build, a watcher gone red, a process waiting on input.

The writer only ever names a class. Glyphs and styles live here, in the
statusline:

```sh
tmux set  -p -t "$TMUX_PANE" @statusline-badge done
tmux set -pu -t "$TMUX_PANE" @statusline-badge
```

```
set -g @statusline-badges 'running done failed'
set -g @statusline-badge-running-glyph ''
set -g @statusline-badge-done-glyph    ''
set -g @statusline-badge-done-style    'fg=green'
set -g @statusline-badge-failed-glyph  ''
set -g @statusline-badge-failed-style  'fg=red,bold'
```

Each class reads `@statusline-badge-<class>-glyph` and
`@statusline-badge-<class>-style`. A style is written in normal tmux syntax and
may contain commas; it is split apart before it reaches the format.

Wrapping a long command is then a one-liner:

```sh
tmux set -p -t "$TMUX_PANE" @statusline-badge running
make && tmux set -p -t "$TMUX_PANE" @statusline-badge done \
     || tmux set -p -t "$TMUX_PANE" @statusline-badge failed
```

Behaviour worth knowing:

- Every badged pane contributes its own glyph, in pane order, so a window
  running two jobs shows two glyphs rather than one.
- A value that is not a declared class contributes nothing at all, not even
  padding.
- Class names may contain letters, digits, `-` and `_`. Anything else is skipped,
  since a class name reaches the format as a literal.
- With no `@statusline-badges` declared, any non-empty value renders
  `@statusline-badge-glyph`, so a single generic badge needs no configuration.
- Setting a class glyph to `''` disables that class; emptying
  `@statusline-badge-glyph` disables badges entirely.
- Badging a *window* (`set -w`) works too, since the option lookup walks pane
  then window. Never badge globally or per-session: that same walk would badge
  every window.
- Glyphs drawn wider than their cell (any East Asian Ambiguous character, which
  most geometric shapes are) bleed into each other, which is what
  `@statusline-badge-separator` defaults to a space for. Set it to `''` for
  tighter badges once you know your glyphs are single-cell; a gap before the
  window name is kept either way.
- Classes, glyphs, styles and the separator are baked in when the plugin runs,
  so changing them needs a config reload. Badge values themselves are live.

## Themes

A theme supplies the whole palette in one option. Individual `@statusline-*-color`
options still override whatever the theme sets, so you can pick a theme and tweak a
single color per host.

```
set -g @statusline-theme 'mono'
```

Available themes:

- `mono` - minimal grayscale (default)
- `tokyonight` - Tokyo Night
- `tokyonight-storm` - Tokyo Night Storm
- `catppuccin` - Catppuccin Mocha
- `catppuccin-frappe` - Catppuccin Frappé
- `catppuccin-macchiato` - Catppuccin Macchiato
- `nord` - Nord
- `gruvbox` - Gruvbox dark
- `gruvbox-material` - Gruvbox Material
- `rosepine` - Rosé Pine
- `rosepine-moon` - Rosé Pine Moon
- `dracula` - Dracula
- `everforest` - Everforest (dark medium)
- `kanagawa` - Kanagawa Wave
- `onedark` - One Dark
- `solarized` - Solarized Dark
- `oxocarbon` - Oxocarbon (IBM Carbon)
- `ayu` - Ayu Mirage
- `nightfox` - Nightfox
- `duskfox` - Duskfox (Nightfox)
- `carbonfox` - Carbonfox (Nightfox)
- `terafox` - Terafox (Nightfox)
- `monokai` - Monokai Pro
- `sonokai` - Sonokai
- `edge` - Edge (dark)
- `github-dark` - GitHub Dark
- `github-dark-dimmed` - GitHub Dark Dimmed
- `material` - Material (oceanic)
- `material-palenight` - Material Palenight
- `melange` - Melange (dark)
- `iceberg` - Iceberg (dark)
- `cyberdream` - Cyberdream
- `vesper` - Vesper
- `poimandres` - Poimandres
- `flexoki` - Flexoki (dark)
- `zenburn` - Zenburn

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
