#!/bin/bash
# Close tabs that hold nothing but a shell prompt. Each tab is re-read right before
# closing; anything on screen besides a login line and a prompt means skip.
# Usage: close_empty.sh [--dry-run] <workspace-ref>/<surface-ref> ...
#   e.g. close_empty.sh --dry-run workspace:12/surface:40 workspace:12/surface:41
# PROMPT_RE must match your idle shell prompt line (default: "user@host dir % ").
set -u
export CMUX_QUIET=1
TESTED="0.65.2" # the only cmux version this was run against
case "$(cmux version 2>/dev/null)" in *" $TESTED "*) ;; *) echo "warning: written for cmux $TESTED, running: $(cmux version 2>/dev/null)" >&2 ;; esac
PROMPT_RE=${PROMPT_RE:-'^[^ ]+@[^ ]+ [^ ]+ [%$#] ?$'}
dry=0
if [ "${1:-}" = "--dry-run" ]; then dry=1; shift; fi

for pair in "$@"; do
  ws=${pair%%/*}; sf=${pair##*/}
  extra=$(cmux read-screen --workspace "$ws" --surface "$sf" --scrollback --lines 200 2>&1 \
    | grep -v '^[[:space:]]*$' | grep -v '^Last login' | grep -v -E "$PROMPT_RE" | wc -l | tr -d ' ')
  if [ "$extra" != "0" ]; then echo "SKIP $sf ($extra other lines on screen)"; continue; fi
  if [ "$dry" = "1" ]; then echo "WOULD CLOSE $sf"; continue; fi
  res=$(cmux close-surface --workspace "$ws" --surface "$sf" 2>&1)
  case "$res" in
    *confirmation_required*) res=$(cmux close-surface --workspace "$ws" --surface "$sf" --force 2>&1) ;;
  esac
  echo "CLOSED $sf: $res"
done
