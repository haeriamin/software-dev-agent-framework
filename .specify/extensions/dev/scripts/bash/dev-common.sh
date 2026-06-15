#!/usr/bin/env bash
# dev-common.sh — helpers for /dev.* commands (source this file).
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../../../../scripts/bash/common.sh"

get_target_field() {
  # get_target_field <target-id> <field> — flat-YAML field reader for targets/<id>.yml.
  local root file
  root="$(get_repo_root)"
  file="$root/targets/$1.yml"
  [ -f "$file" ] || { echo "ERROR: target '$1' not registered (missing $file)" >&2; return 1; }
  sed -n "s/^$2:[[:space:]]*\"\{0,1\}\([^\"]*\)\"\{0,1\}[[:space:]]*$/\1/p" "$file" | head -n 1
}

assert_writable_path() {
  # Defense-in-depth mirror of the immutable-paths hook (Principle I).
  local root rel
  root="$(get_repo_root)"
  rel="${1#"$root"/}"
  case "$rel" in
    standards/*|exemplars/*)
      echo "BLOCKED: '$1' is inside an immutable directory (Constitution Principle I)." >&2
      return 1
      ;;
  esac
}

get_slice_branch() {
  echo "sdd/$1"
}

add_log_entry() {
  # add_log_entry <agent> <command> <target> <verdict> <summary> [artifacts]
  local root ts
  root="$(get_repo_root)"
  ts="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  printf '| %s | %s | %s | %s | %s | %s | %s |\n' \
    "$ts" "$1" "$2" "${3:--}" "${4:--}" "$5" "${6:--}" >> "$root/wiki/log.md"
}
