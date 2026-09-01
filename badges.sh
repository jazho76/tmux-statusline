BADGE_FALLBACK_GLYPH='●'
BADGE_CLASSES=$(get_opt "@statusline-badges" '')
BADGE_SEPARATOR=$(get_opt "@statusline-badge-separator" ' ')

style_directives() {
  local attribute IFS=', '
  for attribute in $1; do
    [ -n "$attribute" ] && printf '#[%s]' "$attribute"
  done
}

badge_markup() {
  local glyph=$1 style=$2 restore_style=$3
  printf '%s%s%s%s' "$(style_directives "$style")" "$glyph" "${style:+$restore_style}" "$BADGE_SEPARATOR"
}

when_pane_badged() {
  printf '#{?@statusline-badge,%s,}' "$1"
}

when_pane_badged_as() {
  printf '#{?#{==:#{@statusline-badge},%s},%s,}' "$1" "$2"
}

per_badged_pane() {
  local presence=$1 glyphs=$2 gap_before_window_name=''
  [ -n "$glyphs" ] || return 0
  [ -n "$BADGE_SEPARATOR" ] || gap_before_window_name=' '
  printf '#{?#{P:%s},#{P:%s}%s,}' "$presence" "$glyphs" "$gap_before_window_name"
}

declared_badges_format() {
  local restore_style=$1 class glyph style glyphs='' presence=''

  for class in $BADGE_CLASSES; do
    case $class in *[!A-Za-z0-9_-]*) continue ;; esac
    glyph=$(get_opt "@statusline-badge-$class-glyph" "$BADGE_FALLBACK_GLYPH")
    [ -n "$glyph" ] || continue
    style=$(get_opt "@statusline-badge-$class-style" '')
    glyphs="$glyphs$(when_pane_badged_as "$class" "$(badge_markup "$glyph" "$style" "$restore_style")")"
    presence="$presence$(when_pane_badged_as "$class" 1)"
  done

  per_badged_pane "$presence" "$glyphs"
}

default_badge_format() {
  local restore_style=$1 glyph style
  glyph=$(get_opt "@statusline-badge-glyph" "$BADGE_FALLBACK_GLYPH")
  [ -n "$glyph" ] || return 0
  style=$(get_opt "@statusline-badge-style" '')
  per_badged_pane "$(when_pane_badged 1)" \
                  "$(when_pane_badged "$(badge_markup "$glyph" "$style" "$restore_style")")"
}

badges_format() {
  if [ -n "$BADGE_CLASSES" ]; then
    declared_badges_format "$1"
  else
    default_badge_format "$1"
  fi
}
