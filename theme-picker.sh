#!/usr/bin/env bash
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEMES_DIR="$CURRENT_DIR/themes"
PLUGIN_TMUX="$CURRENT_DIR/tmux-statusline.tmux"

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/tmux-statusline"
STATE_FILE="$STATE_DIR/theme"

# Top-of-list entry that clears the override so @statusline-theme wins again.
DEFAULT_ENTRY='● use config default'

# Persist the theme override ($1, empty to clear it) and re-render the running
# bar. The plugin reads the state file first, so this is all "applying" means.
set_theme() {
  if [ -n "$1" ]; then
    mkdir -p "$STATE_DIR"
    printf '%s\n' "$1" >"$STATE_FILE"
  else
    rm -f "$STATE_FILE"
  fi
  sh "$PLUGIN_TMUX" >/dev/null 2>&1 || true
}

apply_theme() {
  if [ "$1" = "$DEFAULT_ENTRY" ]; then set_theme ""; else set_theme "$1"; fi
}

# Render a 24-bit color swatch followed by its hex and role.
swatch() {
  local h="${1#\#}"
  printf '\033[48;2;%d;%d;%dm    \033[0m  %-9s %s\n' \
    "$((16#${h:0:2}))" "$((16#${h:2:2}))" "$((16#${h:4:2}))" "$1" "$2"
}

show_preview() {
  if [ "$1" = "$DEFAULT_ENTRY" ]; then
    printf 'use config default\n\n'
    printf 'Clears the saved override and falls back to\n'
    printf 'the @statusline-theme option (or mono).\n'
    return
  fi
  local file="$THEMES_DIR/$1.sh"
  [ -f "$file" ] || { printf 'unknown theme\n'; return; }
  # shellcheck disable=SC1090
  . "$file"
  printf '%s\n\n' "$1"
  swatch "$t_AC" accent
  swatch "$t_PC" prefix
  swatch "$t_G1" bg
  swatch "$t_G2" segment
  swatch "$t_G3" border
  swatch "$t_G4" fg
  swatch "$t_G5" muted
}

# Callbacks invoked by fzf for each entry.
case "${1:-}" in
  --apply)   apply_theme "$2"; exit 0 ;;
  --preview) show_preview "$2"; exit 0 ;;
esac

if ! command -v fzf >/dev/null 2>&1; then
  tmux display-message "tmux-statusline: fzf is required for the theme picker"
  exit 1
fi

# Collect themes (glob is already sorted alphabetically).
themes=()
for f in "$THEMES_DIR"/*.sh; do
  themes+=("$(basename "$f" .sh)")
done

# Remember the active theme so ESC can restore it, and to position the cursor.
if [ -r "$STATE_FILE" ]; then
  had_state=1
  IFS= read -r orig <"$STATE_FILE" || true
else
  had_state=0
  orig=""
fi
current="$orig"
[ -n "$current" ] || current="$(tmux show-option -gqv @statusline-theme)"
[ -n "$current" ] || current="mono"

# 1-based line of the current theme (line 1 is the default entry).
pos=1
i=1
for t in "${themes[@]}"; do
  i=$((i + 1))
  if [ "$t" = "$current" ]; then pos=$i; break; fi
done

restore_state() {
  if [ "$had_state" -eq 1 ]; then set_theme "$orig"; else set_theme ""; fi
}

SELF="$CURRENT_DIR/theme-picker.sh"
if selection="$(printf '%s\n' "$DEFAULT_ENTRY" "${themes[@]}" | fzf \
  --sync --reverse --cycle --no-multi \
  --prompt 'theme> ' \
  --header 'enter: keep   esc: cancel' \
  --preview "\"$SELF\" --preview {}" \
  --preview-window 'right:52%' \
  --bind "start:pos($pos)" \
  --bind "focus:execute-silent(\"$SELF\" --apply {})")"; then
  if [ "$selection" = "$DEFAULT_ENTRY" ]; then
    tmux display-message "tmux-statusline: using @statusline-theme default"
  else
    tmux display-message "tmux-statusline: theme set to $selection"
  fi
else
  restore_state
fi
