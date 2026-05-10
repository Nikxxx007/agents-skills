#!/usr/bin/env bash

set -euo pipefail

REPO_OWNER="Nikxxx007"
REPO_NAME="agents-skills"
BRANCH="main"

ARCHIVE_URL="https://github.com/$REPO_OWNER/$REPO_NAME/archive/refs/heads/$BRANCH.tar.gz"
TARGET_DIR="$HOME/.claude/skills"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

echo "Installing SQL optimization skills for Claude Code..."
echo "Repository: $REPO_OWNER/$REPO_NAME"
echo "Target: $TARGET_DIR"
echo ""

mkdir -p "$TARGET_DIR"

echo "Downloading skills..."
curl -fsSL "$ARCHIVE_URL" -o "$TMP_DIR/repo.tar.gz"

echo "Extracting..."
tar -xzf "$TMP_DIR/repo.tar.gz" -C "$TMP_DIR"

EXTRACTED_DIR="$TMP_DIR/$REPO_NAME-$BRANCH"
SOURCE_DIR="$EXTRACTED_DIR/skills"

if [ ! -d "$SOURCE_DIR" ]; then
  echo "Error: skills directory not found in downloaded repository."
  exit 1
fi

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
