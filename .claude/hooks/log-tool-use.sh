#!/usr/bin/env bash
# log-tool-use.sh (Claude Code PostToolUse hook — POSIX variant)
# Appends a structured entry to wiki/log.md for file-writing tool calls (Principle VII).
# Never blocks (always exits 0).
set -uo pipefail

INPUT=$(cat)

eval "$(echo "$INPUT" | python3 -c "
import json, shlex, sys
try:
    data = json.load(sys.stdin)
except Exception:
    sys.exit(0)
ti = data.get('tool_input') or {}
fp = next((ti[f] for f in ['file_path', 'path', 'notebook_path'] if f in ti), '')
print('TOOL_NAME=' + shlex.quote(data.get('tool_name', 'unknown')))
print('FILE_PATH=' + shlex.quote(fp))
print('ROOT=' + shlex.quote(data.get('cwd', '.')))
" 2>/dev/null)" || exit 0

[ -n "${FILE_PATH:-}" ] || exit 0
case "$FILE_PATH" in *wiki/log.md*) exit 0 ;; esac

LOG="${ROOT:-.}/wiki/log.md"
[ -f "$LOG" ] || exit 0

TS="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
printf '| %s | hook | %s | - | - | file written | %s |\n' "$TS" "${TOOL_NAME:-unknown}" "$FILE_PATH" >> "$LOG"
exit 0
