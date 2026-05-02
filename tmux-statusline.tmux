set_opt() {
  tmux set-option -gq "$1" "$2"
}

# Config params
rarrow=''
larrow=''
AC='#888888'
G1=#262626 #235
G01=#303030 #236
G2=#3a3a3a #237
G3=#444444 #238
G4=#626262 #241
G5=#767676 #243
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
LS="#[fg=$G1,bg=$AC,bold] #{?client_prefix,,} #[fg=$AC,bg=$G2,nobold]$rarrow#[fg=$AC,bg=$G2]  #S "
LS="$LS#[fg=$G2,bg=$BG]$rarrow"
set_opt status-left "$LS"

# Right status
set_opt status-right-bg "$BG"
set_opt status-right-fg "$G5"
set_opt status-right-length 150
RS="#[fg=$AC,bg=$G2]$larrow#[fg=$G1,bg=$AC] #{pomodoro_status} #{?window_zoomed_flag,,󱇙} #{=/15/…:pane_title}#[fg=$AC,bg=$AC]."
RS="#[fg=$G2]$larrow#[fg=$AC,bg=$G2]  #{server_sessions} $RS"
set_opt status-right "$RS"

# Copy mode
set_opt mode-style "bg=$AC,fg=$FG"

# Pane border
set_opt pane-border-style "fg=$G3,bg=default"
set_opt pane-active-border-style "fg=$AC,bg=default"
set_opt display-panes-colour "$G3"
set_opt display-panes-active-colour "$AC"

# Window status format
set_opt window-status-format         "#[fg=$BG,bg=$G2]$rarrow#[fg=$AC,bg=$G2] #I:#W #[fg=$G2,bg=$BG]$rarrow"
set_opt window-status-current-format "#[fg=$BG,bg=$AC]$rarrow#[fg=$BG,bg=$AC,bold] #I:#W #[fg=$AC,bg=$BG,nobold]$rarrow"

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
