#!/bin/bash
# Scan what git would publish (the staged + committed files) for things that should
# not be public: links, emails, home paths, chat/ticket ids, tokens.
# Usage: check_public.sh [extra-patterns-file]
#   extra-patterns-file: one regex per line, matched case-insensitively. Use it for
#   names, employer and product terms, hostnames. Keep that file OUTSIDE this repo.
# Exit code 1 if anything matched. A match is a prompt to look, not proof of a leak.
set -u
cd "$(git rev-parse --show-toplevel)" || exit 2
self="scripts/check_public.sh"
fail=0

scan() { # label, flags, regex
  hits=$(git grep --cached -nI $2 -E -e "$3" -- . ":(exclude)$self" 2>/dev/null)
  if [ -n "$hits" ]; then fail=1; echo "== $1"; echo "$hits"; echo; fi
}

scan "link"                  ""   'https?://[^ )>"]+'
scan "email"                 ""   '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}'
scan "home path"             ""   '/(Users|home)/[A-Za-z0-9._-]+'
scan "chat id (slack shape)" ""   '[UCDGW]0[0-9A-Z]{8,}'
scan "uuid"                  "-i" '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}'
scan "32-char hex id"        "-i" '[0-9a-f]{32}'
scan "ticket id"             ""   '[A-Z]{2,6}-[0-9]{2,}'
scan "token shape"           ""   '(sk-[A-Za-z0-9]{16,}|xox[abprs]-[A-Za-z0-9-]{10,}|gh[pousr]_[A-Za-z0-9]{20,}|AKIA[0-9A-Z]{16}|BEGIN [A-Z ]*PRIVATE KEY)'
scan "secret with a value"   "-i" '(password|passwd|secret|token|api[_-]?key)[[:space:]]*[:=][[:space:]]*[^[:space:]<]+'

if [ -n "${1:-}" ]; then
  while IFS= read -r pat; do
    case "$pat" in ""|\#*) continue ;; esac
    scan "private pattern: $pat" "-i" "$pat"
  done < "$1"
fi

echo "files scanned: $(git ls-files | wc -l | tr -d ' ')"
if [ "$fail" = "0" ]; then echo "no matches"; fi
exit $fail
