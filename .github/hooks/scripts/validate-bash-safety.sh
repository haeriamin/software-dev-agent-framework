#!/usr/bin/env bash
# validate-bash-safety.sh (Copilot PreToolUse hook — terminal/run commands, POSIX variant)
# Same guard as the Claude variant: blocks shell writes touching /standards/ or /exemplars/,
# and `git push` / `git merge` (human-only, Constitution Principle VI).
# Protocol: stdin JSON; reads tool_input.command (or command at top level); exit 1 = block.
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
ti = data.get('tool_input', data)
print(ti.get('command', '') if isinstance(ti, dict) else '')
" 2>/dev/null || echo "")

[ -n "$CMD" ] || exit 0
C="${CMD//\\//}"

if echo "$C" | grep -qE '(^|[;&|][[:space:]]*)git[[:space:]]+(push|merge)\b'; then
  echo "BLOCKED: 'git push' / 'git merge' are human-only actions (Constitution Principle VI)."
  echo "Present the sdd/<slice> branch in your report; the human merges."
  exit 1
fi

if echo "$C" | grep -qE '(^|/|[[:space:]"'"'"'=])(standards|exemplars)/'; then
  if echo "$C" | grep -qE '(>|>>|\btee\b|\bcp\b|\bmv\b|\brm\b|\brmdir\b|\btouch\b|\bln\b|\bsed[[:space:]]+-i\b|\bdd\b|\binstall\b)'; then
    echo "BLOCKED: shell command combines an immutable path (/standards/ or /exemplars/) with a write operation (Constitution Principle I)."
    echo "These directories are human-curated and READ ONLY to agents. Read without redirection, or stop and escalate."
    exit 1
  fi
fi
exit 0
