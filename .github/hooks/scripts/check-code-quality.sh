#!/usr/bin/env bash
# check-code-quality.sh
# PostToolUse hook — lightweight quality lint on just-written source files.
# Warns (stdout) but never blocks (always exits 0).
set -uo pipefail

INPUT=$(cat)

PY="$(command -v python3 || command -v python || command -v py)"
[ -n "$PY" ] || PY=python3


FILE_PATH=$(echo "$INPUT" | "$PY" -c "
import json, sys
try:
    data = json.load(sys.stdin)
except Exception:
    print(''); sys.exit(0)
ti = data.get('tool_input', data)
for field in ['path', 'file_path', 'target', 'destination']:
    if isinstance(ti, dict) and field in ti:
        print(ti[field]); sys.exit(0)
print('')
" 2>/dev/null || echo "")

[ -n "$FILE_PATH" ] && [ -f "$FILE_PATH" ] || exit 0

case "$FILE_PATH" in
  *.ts|*.tsx|*.js|*.jsx|*.py|*.cs|*.go|*.rs|*.java|*.rb|*.php) ;;
  *) exit 0 ;;
esac

WARNINGS=0

if grep -nE '^(<<<<<<<|=======|>>>>>>>)' "$FILE_PATH" >/dev/null 2>&1; then
  echo "WARN [$FILE_PATH]: merge-conflict markers present"
  WARNINGS=$((WARNINGS + 1))
fi

if grep -nE '(console\.log\(|debugger;|print\(.*#.*DEBUG|breakpoint\(\)|pdb\.set_trace)' "$FILE_PATH" >/dev/null 2>&1; then
  echo "WARN [$FILE_PATH]: possible debug statements left in source"
  WARNINGS=$((WARNINGS + 1))
fi

# TODO/FIXME without the framework's DEV-STATUS annotation = silent skip risk (Principle IV)
if grep -nE '\b(TODO|FIXME)\b' "$FILE_PATH" | grep -v 'DEV-STATUS' >/dev/null 2>&1; then
  echo "WARN [$FILE_PATH]: TODO/FIXME without DEV-STATUS annotation (Constitution Principle IV)"
  WARNINGS=$((WARNINGS + 1))
fi

[ "$WARNINGS" -gt 0 ] && echo "check-code-quality: $WARNINGS warning(s) — review before handoff"
exit 0
