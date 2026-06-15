#!/usr/bin/env bash
# log-tool-use.sh
# PostToolUse hook — appends a structured entry to wiki/log.md for file-writing tool calls.
# Never blocks (always exits 0).
set -uo pipefail

INPUT=$(cat)

read -r TOOL_NAME FILE_PATH < <(echo "$INPUT" | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
except Exception:
    print(' '); sys.exit(0)
tool = data.get('tool_name', data.get('tool', 'unknown'))
ti = data.get('tool_input', data)
fp = ''
for field in ['path', 'file_path', 'target', 'destination']:
    if isinstance(ti, dict) and field in ti:
        fp = ti[field]; break
print(f'{tool} {fp}')
" 2>/dev/null || echo " ")

# Only log writes that touched a file; skip wiki/log.md itself to avoid recursion.
if [ -z "${FILE_PATH:-}" ] || [[ "$FILE_PATH" == *"wiki/log.md"* ]]; then
  exit 0
fi

ROOT="$(pwd)"
LOG="$ROOT/wiki/log.md"
[ -f "$LOG" ] || exit 0

TS="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
printf '| %s | hook | %s | - | - | file written | %s |\n' "$TS" "${TOOL_NAME:-unknown}" "$FILE_PATH" >> "$LOG"
exit 0
