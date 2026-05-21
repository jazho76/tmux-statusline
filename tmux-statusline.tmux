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
AC=$(get_opt "@statusline-accent-color" '#888888')
PC=$(get_opt "@statusline-prefix-color" '#888888')
PI=$(get_opt "@statusline-prefix-icon" '')
PL=$(get_opt "@statusline-prefix-label" '')
G1=$(get_opt "@statusline-bg-color"      '#262626')
G2=$(get_opt "@statusline-segment-color" '#3a3a3a')
G3=$(get_opt "@statusline-border-color"  '#444444')
G4=$(get_opt "@statusline-fg-color"      '#626262')
G5=$(get_opt "@statusline-muted-color"   '#767676')
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

