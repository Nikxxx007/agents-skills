#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_DIR="$REPO_ROOT/skills"
TARGET_DIR="$HOME/.claude/skills"

echo "Installing SQL optimization skills for Claude Code..."
echo "Source: $SOURCE_DIR"
echo "Target: $TARGET_DIR"
echo ""

if [ ! -d "$SOURCE_DIR" ]; then
  echo "Error: skills directory not found: $SOURCE_DIR"
  exit 1
fi

mkdir -p "$TARGET_DIR"

installed_count=0
skipped_count=0

for skill_dir in "$SOURCE_DIR"/*; do
  if [ ! -d "$skill_dir" ]; then
    continue
  fi

  skill_name="$(basename "$skill_dir")"

  if [ ! -f "$skill_dir/SKILL.md" ]; then
    echo "Skipping $skill_name: missing SKILL.md"
    skipped_count=$((skipped_count + 1))
    continue
  fi

  if [ -d "$TARGET_DIR/$skill_name" ]; then
    backup_dir="$TARGET_DIR/$skill_name.backup.$(date +%Y%m%d%H%M%S)"
    echo "Backing up existing skill: $skill_name"
    mv "$TARGET_DIR/$skill_name" "$backup_dir"
  fi

  echo "Installing skill: $skill_name"
  cp -R "$skill_dir" "$TARGET_DIR/$skill_name"
  installed_count=$((installed_count + 1))
done

echo ""
echo "Done."
echo "Installed: $installed_count"
echo "Skipped: $skipped_count"
echo "Target: $TARGET_DIR"
echo ""
echo "Restart Claude Code or reload your session if the skills do not appear immediately."