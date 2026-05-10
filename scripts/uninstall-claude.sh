#!/usr/bin/env bash

set -euo pipefail

TARGET_DIR="$HOME/.claude/skills"

SKILLS=(
  "sql-review-query"
  "sql-optimize-query"
  "sql-review-schema"
  "sql-review-orm-query"
  "sql-optimize-orm-query"
  "sql-test-query-performance"
)

echo "Uninstalling SQL and ORM agent skills for Claude Code..."
echo "Target: $TARGET_DIR"
echo ""

if [ ! -d "$TARGET_DIR" ]; then
  echo "No Claude Code skills directory found: $TARGET_DIR"
  echo "Nothing to uninstall."
  exit 0
fi

removed_count=0
missing_count=0

for skill_name in "${SKILLS[@]}"; do
  skill_path="$TARGET_DIR/$skill_name"

  if [ -d "$skill_path" ]; then
    echo "Removing skill: $skill_name"
    rm -rf "$skill_path"
    removed_count=$((removed_count + 1))
  else
    echo "Skipping missing skill: $skill_name"
    missing_count=$((missing_count + 1))
  fi
done

echo ""
echo "Done."
echo "Removed: $removed_count"
echo "Missing: $missing_count"
echo "Target: $TARGET_DIR"
echo ""
echo "Restart Claude Code or reload your session if removed skills still appear."
