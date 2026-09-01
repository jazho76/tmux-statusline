set_opt() {
  tmux set-option -gq "$1" "$2"
}

get_opt() {
  local val
  if val=$(tmux show-option -gv "$1" 2>/dev/null); then printf '%s' "$val"; else printf '%s' "$2"; fi
}

# Config params
rdec=$(get_opt "@statusline-decorator-right" '')
ldec=$(get_opt "@statusline-decorator-left" '')
# Theme: source the palette defaults, then let per-color options override.
# An interactive pick (theme-picker.sh) lands in the state file and wins over
# the @statusline-theme option; falling back to the option, then mono.
CURRENT_DIR="$(cd "$(dirname "$0")" && pwd)"
theme=""
state_file="${XDG_STATE_HOME:-$HOME/.local/state}/tmux-statusline/theme"
[ -r "$state_file" ] && IFS= read -r theme < "$state_file" 2>/dev/null
[ -n "$theme" ] || theme=$(get_opt "@statusline-theme" 'mono')
theme_file="$CURRENT_DIR/themes/$theme.sh"
[ -f "$theme_file" ] || theme_file="$CURRENT_DIR/themes/mono.sh"
. "$theme_file"

AC=$(get_opt "@statusline-accent-color"  "$t_AC")
PC=$(get_opt "@statusline-prefix-color"  "$t_PC")
PI=$(get_opt "@statusline-prefix-icon" '')
PL=$(get_opt "@statusline-prefix-label" '')
G1=$(get_opt "@statusline-bg-color"      "$t_G1")
G2=$(get_opt "@statusline-segment-color" "$t_G2")
G3=$(get_opt "@statusline-border-color"  "$t_G3")
G4=$(get_opt "@statusline-fg-color"      "$t_G4")
G5=$(get_opt "@statusline-muted-color"   "$t_G5")
FG="$G4"
BG="$G1"

if [ -f "$CURRENT_DIR/badges.sh" ]; then
  . "$CURRENT_DIR/badges.sh"
  BADGE=$(badges_format "#[fg=$AC]")
  BADGE_CURRENT=$(badges_format "#[fg=$BG]#[bold]")
fi

# Status options
set_opt status on
set_opt status-interval 1
set_opt status-fg "$FG"
set_opt status-bg "$BG"
set_opt status-attr none

# Left status
set_opt status-left-bg "$G1"
set_opt status-left-fg "$G5"
set_opt status-left-length 150
LS="#[fg=$G1,bg=$PC,bold] #{?client_prefix,,$PI}${PL:+ $PL} #[fg=$PC,bg=$G2,nobold]$rdec#[fg=$AC,bg=$G2]  #S "
LS="$LS#[fg=$G2,bg=$BG]$rdec"
set_opt status-left "$LS"

# Right status
set_opt status-right-bg "$BG"
set_opt status-right-fg "$G5"
set_opt status-right-length 150
RS="#[fg=$PC,bg=$G2]$ldec#[fg=$G1,bg=$PC] #{pomodoro_status} #{?window_zoomed_flag,,󱇙} #{=/15/…:pane_title}#[fg=$PC,bg=$PC]."
RS="#[fg=$G2]$ldec#[fg=$AC,bg=$G2]  #{server_sessions} $RS"
set_opt status-right "$RS"

# Copy mode
set_opt mode-style "bg=$AC,fg=$FG"

# Pane border
set_opt pane-border-style "fg=$G3,bg=default"
set_opt pane-active-border-style "fg=$AC,bg=default"
set_opt display-panes-colour "$G3"
set_opt display-panes-active-colour "$AC"

# Popup border
set_opt popup-border-style "fg=$AC,bg=default"
set_opt popup-border-lines "rounded"

# Window status format
set_opt window-status-format         "#[fg=$BG,bg=$G2]$rdec#[fg=$AC,bg=$G2] $BADGE#I:#W #[fg=$G2,bg=$BG]$rdec"
set_opt window-status-current-format "#[fg=$BG,bg=$AC]$rdec#[fg=$BG,bg=$AC,bold] $BADGE_CURRENT#I:#W #[fg=$AC,bg=$BG,nobold]$rdec"

# Window
set_opt window-status-style          "fg=$AC,bg=$BG,none"
set_opt window-status-last-style     "fg=$AC,bg=$BG,bold"
set_opt window-status-activity-style "fg=$AC,bg=$BG,bold"
set_opt window-status-separator ""

# Messages
set_opt message-style "fg=$AC,bg=$BG"
set_opt message-command-style "fg=$AC,bg=$BG"

# Clock
set_opt clock-mode-colour "$AC"
set_opt clock-mode-style 24

# Theme picker command: run it from the prompt with `prefix + :` then type
# `statusline-theme`. Reuse our slot if already registered so reloads stay
# idempotent; otherwise let tmux append a fresh array index, which never
# clobbers tmux's built-in aliases or another plugin's.
picker_cmd="display-popup -w 70% -h 60% -E '$CURRENT_DIR/theme-picker.sh'"
alias_idx=$(tmux show-options -g command-alias 2>/dev/null \
  | awk -F'[][]' '/statusline-theme=/ { print $2; exit }')
if [ -n "$alias_idx" ]; then
  set_opt "command-alias[$alias_idx]" "statusline-theme=$picker_cmd"
else
  tmux set-option -gqa command-alias "statusline-theme=$picker_cmd"
fi

