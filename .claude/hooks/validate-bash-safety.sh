#!/usr/bin/env bash
# validate-bash-safety.sh (Claude Code PreToolUse hook, matcher: Bash — POSIX variant)
# Closes the shell bypass of the write-boundary and merge rules:
#  - blocks shell writes (redirect/copy/move/delete/in-place edit) touching /standards/ or /exemplars/
#  - blocks `git push` and `git merge` (merging/pushing is human — Constitution Principle VI)
# Conservative by design: read-only commands mentioning an immutable path together with a
# write token are blocked too — re-form the command without the write token.
# Protocol: stdin JSON {tool_name, tool_input:{command}}; exit 2 + stderr = block.
set -uo pipefail

INPUT=$(cat)

PY="$(command -v python3 || command -v python || command -v py)"
[ -n "$PY" ] || PY=python3


CMD=$(echo "$INPUT" | "$PY" -c "
import json, sys
try:
    data = json.load(sys.stdin)
except Exception:
    print(''); sys.exit(0)
print((data.get('tool_input') or {}).get('command', ''))
" 2>/dev/null || echo "")

[ -n "$CMD" ] || exit 0
C="${CMD//\\//}"

if echo "$C" | grep -qE '(^|[;&|][[:space:]]*)git[[:space:]]+(push|merge)\b'; then
  echo "BLOCKED: 'git push' / 'git merge' are human-only actions (Constitution Principle VI)." >&2
  echo "Present the sdd/<slice> branch in your report; the human merges." >&2
  exit 2
fi

if echo "$C" | grep -qE '(^|/|[[:space:]"'"'"'=])(standards|exemplars)/'; then
  if echo "$C" | grep -qE '(>|>>|\btee\b|\bcp\b|\bmv\b|\brm\b|\brmdir\b|\btouch\b|\bln\b|\bsed[[:space:]]+-i\b|\bdd\b|\binstall\b)'; then
    echo "BLOCKED: shell command combines an immutable path (/standards/ or /exemplars/) with a write operation (Constitution Principle I)." >&2
    echo "These directories are human-curated and READ ONLY to agents. Read without redirection, or stop and escalate." >&2
    exit 2
  fi
fi
exit 0
