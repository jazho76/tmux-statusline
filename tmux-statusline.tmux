set_opt() {
  tmux set-option -gq "$1" "$2"
}

get_opt() {
  local val
  val=$(tmux show-option -gqv "$1")
  echo "${val:-$2}"
}

# Config params
rdec=$(get_opt "@statusline-decorator-right" '')
ldec=$(get_opt "@statusline-decorator-left" '')
# Theme: source the palette defaults, then let per-color options override.
CURRENT_DIR="$(cd "$(dirname "$0")" && pwd)"
theme=$(get_opt "@statusline-theme" 'mono')
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

# Window status format
set_opt window-status-format         "#[fg=$BG,bg=$G2]$rdec#[fg=$AC,bg=$G2] #I:#W #[fg=$G2,bg=$BG]$rdec"
set_opt window-status-current-format "#[fg=$BG,bg=$AC]$rdec#[fg=$BG,bg=$AC,bold] #I:#W #[fg=$AC,bg=$BG,nobold]$rdec"

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

