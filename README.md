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

## Installation (TPM)

```
set -g @plugin 'jpinilloslr/tmux-statusline'
```

Reload tmux environment:

```
tmux source-file ~/.tmux.conf
```

## Configuration

| Option                         | Default     | Description                                                |
| ------------------------------ | ----------- | ---------------------------------------------------------- |
| `@statusline-accent-color`     | `#888888`   | Accent color (session block, windows, decorators, borders) |
| `@statusline-prefix-color`     | `#888888`   | Color of the leading prefix block and trailing pane block  |
| `@statusline-prefix-icon`      | ``          | Glyph shown in the leading block when prefix is inactive   |
| `@statusline-prefix-label`     | (empty)     | Optional short label rendered next to the prefix icon      |
| `@statusline-decorator-right`  | ``          | Right-pointing segment separator                           |
| `@statusline-decorator-left`   | ``          | Left-pointing segment separator                            |

Example: per-host coloring and labeling so the same statusline reads differently across machines (drop into `~/.config/tmux/local.conf` or equivalent):
```
set -g @statusline-prefix-color '#0ea5e9'
set -g @statusline-prefix-icon  ''
set -g @statusline-prefix-label 'host'
set -g @statusline-decorator-right ''
set -g @statusline-decorator-left  ''
```

## Optional Extensions

Pomodoro support (used if available):
```
set -g @plugin 'olimorris/tmux-pomodoro-plus'
```
