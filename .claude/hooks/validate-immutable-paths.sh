#!/usr/bin/env bash
# validate-immutable-paths.sh (Claude Code PreToolUse hook — POSIX variant)
# Blocks write tools targeting /standards/ or /exemplars/ (Constitution Principle I).
# Claude Code protocol: stdin JSON {tool_name, tool_input}; exit 2 + stderr = block.
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
ti = data.get('tool_input') or {}
for field in ['file_path', 'path', 'notebook_path']:
    if field in ti:
        print(ti[field]); sys.exit(0)
print('')
" 2>/dev/null || echo "")

[ -n "$FILE_PATH" ] || exit 0

NORMALIZED="${FILE_PATH//\\//}"
case "$NORMALIZED" in
  standards/*|*/standards/*|exemplars/*|*/exemplars/*)
    echo "BLOCKED: '$FILE_PATH' is inside an immutable directory (/standards/ or /exemplars/)." >&2
    echo "Constitution Principle I: these paths are human-curated and READ ONLY to agents." >&2
    echo "Stop and escalate per .github/instructions/escalation-protocol.instructions.md." >&2
    exit 2
    ;;
esac
exit 0
