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

## Requirements

- tmux ≥ 3.2
- Nerd Font (for icons and separators)
- True color terminal recommended

## Installation (TPM)

```
set -g @plugin 'jazho76/tmux-statusline'
```

Reload tmux environment:

```
tmux source-file ~/.tmux.conf
```

## Configuration

| Option                      | Default     | Description  |
| --------------------------- | ----------- | ------------ |
| `@statusline-accent-color`  | `#888888`   | Accent color |

Example:
```
set -g @statusline-accent-color "#ff79c6"
```

## Optional Extensions

Pomodoro support (used if available):
```
set -g @plugin 'olimorris/tmux-pomodoro-plus'
```
