#!/usr/bin/env bash
# create-new-feature.sh — create specs/NNN-<short-name>/ from the spec template.
# Usage: ./create-new-feature.sh <short-name> [template]
# Outputs JSON: { "FEATURE_DIR": ..., "SPEC_FILE": ..., "FEATURE_NUM": ... }
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

SHORT_NAME="${1:?usage: create-new-feature.sh <short-name> [template]}"
TEMPLATE="${2:-spec-template.md}"

if ! [[ "$SHORT_NAME" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
  echo "ERROR: short-name must be kebab-case (got '$SHORT_NAME')" >&2
  exit 1
fi

ROOT="$(get_repo_root)"
NUM="$(get_next_feature_number)"
FEATURE_DIR="specs/$NUM-$SHORT_NAME"
mkdir -p "$ROOT/$FEATURE_DIR/checklists"

TEMPLATE_PATH="$ROOT/.throughline/templates/$TEMPLATE"
[ -f "$TEMPLATE_PATH" ] || { echo "ERROR: template not found: $TEMPLATE_PATH" >&2; exit 1; }
cp "$TEMPLATE_PATH" "$ROOT/$FEATURE_DIR/spec.md"

printf '{\n  "feature_directory": "%s"\n}\n' "$FEATURE_DIR" > "$ROOT/.throughline/feature.json"
printf '{"FEATURE_DIR":"%s","SPEC_FILE":"%s/spec.md","FEATURE_NUM":"%s"}\n' "$FEATURE_DIR" "$FEATURE_DIR" "$NUM"
