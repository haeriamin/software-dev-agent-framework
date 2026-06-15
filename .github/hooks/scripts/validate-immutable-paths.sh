#!/usr/bin/env bash
# validate-immutable-paths.sh
# PreToolUse hook — blocks write operations targeting immutable directories.
# Tool call context arrives as JSON on stdin. Exit 1 with a message to block; exit 0 to allow.
set -euo pipefail

INPUT=$(cat)

FILE_PATH=$(echo "$INPUT" | python3 -c "
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

if [ -z "$FILE_PATH" ]; then
  exit 0  # not a file-write tool or path not detectable — allow
fi

NORMALIZED="${FILE_PATH//\\//}"
NORMALIZED="${NORMALIZED#./}"

for PREFIX in "standards/" "exemplars/"; do
  if [[ "$NORMALIZED" == "$PREFIX"* || "$NORMALIZED" == *"/$PREFIX"* ]]; then
    echo "BLOCKED: Attempted write to immutable path: $FILE_PATH"
    echo "The /standards/ and /exemplars/ directories are READ ONLY (Constitution Principle I)."
    echo "Agents must never modify source material. Add new files via human curation only."
    exit 1
  fi
done

exit 0
