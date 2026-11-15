#!/bin/bash
# Example: one stable color per cmux workspace, matched by workspace name.
# Copy it somewhere private, put your own workspace names in, then run it.
# Lesson from first use: cmux's 16 named colors are too close to use many at once.
# About 9 hues spaced around the wheel can be told apart at a glance; give
# everything that is not a list item one shared gray, so gray means "not on the list".
# Undo one: cmux workspace-action --action clear-color --workspace <ref>
set -u
export CMUX_QUIET=1
TESTED="0.65.2" # the only cmux version this was run against
case "$(cmux version 2>/dev/null)" in *" $TESTED "*) ;; *) echo "warning: written for cmux $TESTED, running: $(cmux version 2>/dev/null)" >&2 ;; esac

GRAY="#607D8B"
color_for() {
  case "$1" in
    "first list item") echo "#D32F2F" ;;
    "second list item") echo "#EF6C00" ;;
    "third list item") echo "#F9A825" ;;
    "fourth list item") echo "#2E7D32" ;;
    "fifth list item") echo "#00ACC1" ;;
    "sixth list item") echo "#1E88E5" ;;
    "seventh list item") echo "#8E24AA" ;;
    "eighth list item") echo "#EC407A" ;;
    "ninth list item") echo "#6D4C41" ;;
    "something not on the list"|"another one") echo "$GRAY" ;;
    *) echo "" ;;
  esac
}

cmux workspace list | while IFS= read -r line; do
  ref=$(printf '%s\n' "$line" | grep -o 'workspace:[0-9]*' | head -n 1)
  name=$(printf '%s\n' "$line" | sed -E 's/^[* ]*workspace:[0-9]+ +//; s/ +\[selected\]$//')
  c=$(color_for "$name")
  if [ -z "$c" ]; then echo "no color for: $name"; continue; fi
  echo "$name -> $c: $(cmux workspace-action --action set-color --color "$c" --workspace "$ref" 2>&1)"
done
