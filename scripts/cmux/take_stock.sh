#!/bin/bash
# Read-only. Save the last screen of every cmux tab: one file per tab plus all.txt.
# Usage: take_stock.sh <output-dir> [lines-kept-per-tab]
# Note: reading a restored tab that was never opened makes cmux start a shell in it.
set -u
out=${1:?usage: take_stock.sh <output-dir> [lines-kept-per-tab]}
keep=${2:-28}
export CMUX_QUIET=1
TESTED="0.65.2" # the only cmux version this was run against
case "$(cmux version 2>/dev/null)" in *" $TESTED "*) ;; *) echo "warning: written for cmux $TESTED, running: $(cmux version 2>/dev/null)" >&2 ;; esac
mkdir -p "$out"
cmux tree --all > "$out/tree.txt"
: > "$out/all.txt"

ws=""
while IFS= read -r line; do
  case "$line" in
    *"workspace workspace:"*)
      ws=$(printf '%s\n' "$line" | grep -o 'workspace:[0-9]*' | head -n 1)
      ;;
    *"surface surface:"*)
      sf=$(printf '%s\n' "$line" | grep -o 'surface:[0-9]*' | head -n 1)
      title=$(printf '%s\n' "$line" | sed -E 's/^[^"]*"//; s/".*$//')
      f="$out/${ws#workspace:}-${sf#surface:}.txt"
      cmux read-screen --workspace "$ws" --surface "$sf" --scrollback --lines 120 > "$f" 2>&1
      {
        echo "=================== $ws $sf \"$title\""
        grep -v '^[[:space:]]*$' "$f" | grep -v '^[─━ ]*$' | cut -c1-180 | tail -n "$keep"
      } >> "$out/all.txt"
      ;;
  esac
done < "$out/tree.txt"

echo "tabs read: $(grep -c '^===================' "$out/all.txt")"
echo "exited sessions (resume line on screen): $(grep -l 'Resume this session with' "$out"/*-*.txt 2>/dev/null | wc -l | tr -d ' ')"
echo "written to: $out"
