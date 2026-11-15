#!/bin/bash
# Example only: the shape of a regroup. Copy, fill in refs and names, show the
# owner the plan, and run it only after a yes. Closes nothing that holds a session.
# Refs come from `cmux tree --all` (workspace:<n>, surface:<n>).
set -u
export CMUX_QUIET=1
TESTED="0.65.2" # the only cmux version this was run against
case "$(cmux version 2>/dev/null)" in *" $TESTED "*) ;; *) echo "warning: written for cmux $TESTED, running: $(cmux version 2>/dev/null)" >&2 ;; esac

ren()    { echo "rename $2: $(cmux rename-tab --workspace "$1" --surface "$2" "$3" 2>&1)"; }
rw()     { echo "rename $1: $(cmux rename-workspace --workspace "$1" "$2" 2>&1)"; }
new_ws() { cmux new-workspace --name "$1" --description "$2" --focus false 2>&1 | grep -o 'workspace:[0-9]*'; }
mv_to()  { t=$1; shift; for s in "$@"; do echo "move $s -> $t: $(cmux move-surface --surface "$s" --workspace "$t" --focus false 2>&1)"; done; }

# 1. name tabs for what they hold (rename before moving: the workspace ref is still known)
ren workspace:1 surface:3 "what this tab really is"

# 2. a workspace that keeps most of its tabs takes the list item's name
rw workspace:1 "the list item, in the owner's words"

# 3. a workspace per list item that has none yet
ITEM=$(new_ws "another list item" "list item: <his wording>")

# 4. move tabs
mv_to "$ITEM" surface:7 surface:9

# 5. afterwards:
#    - new-workspace adds a blank starter tab: close it with close_empty.sh
#    - close workspaces left with no tabs: cmux workspace close --workspace <ref>
#    - put focus back on the owner's tab: cmux focus-panel --panel <surface> --workspace <ref>
cmux tree --all
