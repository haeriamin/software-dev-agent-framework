#!/usr/bin/env bash
# common.sh — shared helpers for speckit core scripts (source this file).
set -euo pipefail

get_repo_root() {
  local dir
  dir="$(pwd)"
  while [ "$dir" != "/" ]; do
    if [ -f "$dir/.specify/memory/constitution.md" ]; then
      echo "$dir"
      return 0
    fi
    dir="$(dirname "$dir")"
  done
  echo "ERROR: not inside the framework (no .specify/memory/constitution.md found)" >&2
  return 1
}

get_feature_directory() {
  local root feature_json rel latest
  root="$(get_repo_root)"
  feature_json="$root/.specify/feature.json"
  if [ -f "$feature_json" ]; then
    rel="$(sed -n 's/.*"feature_directory"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$feature_json")"
    if [ -n "$rel" ] && [ -d "$root/$rel" ]; then
      echo "$root/$rel"
      return 0
    fi
  fi
  latest="$(ls -1d "$root"/specs/[0-9][0-9][0-9]-* 2>/dev/null | sort | tail -n 1 || true)"
  if [ -z "$latest" ]; then
    echo "ERROR: no feature directory found. Run /speckit.specify first." >&2
    return 1
  fi
  echo "$latest"
}

get_next_feature_number() {
  local root max n
  root="$(get_repo_root)"
  max=0
  for d in "$root"/specs/[0-9][0-9][0-9]-*; do
    [ -d "$d" ] || continue
    n=$((10#$(basename "$d" | cut -c1-3)))
    [ "$n" -gt "$max" ] && max=$n
  done
  printf "%03d" $((max + 1))
}
