#!/bin/bash
# install-hooks.sh — jolarca-identity
#
# Symlinks git hooks from scripts/hooks/ into .git/hooks/.
# Run this once after cloning:
#   bash scripts/install-hooks.sh
#
# This is a compensating control for the absence of server-side secret
# scanning on GitHub Free private repositories.

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
HOOKS_DIR="$REPO_ROOT/scripts/hooks"
GIT_HOOKS_DIR="$REPO_ROOT/.git/hooks"

if [ ! -d "$REPO_ROOT/.git" ]; then
  echo "✗  Not a git repository. Run 'git init' first."
  exit 1
fi

if [ ! -d "$HOOKS_DIR" ]; then
  echo "✗  Hooks directory not found: $HOOKS_DIR"
  exit 1
fi

echo "Installing git hooks from $HOOKS_DIR → $GIT_HOOKS_DIR"

installed=0
for hook in "$HOOKS_DIR"/*; do
  hook_name="$(basename "$hook")"
  target="$GIT_HOOKS_DIR/$hook_name"

  # Remove existing hook (file or symlink)
  if [ -e "$target" ] || [ -L "$target" ]; then
    rm -f "$target"
    echo "  Replaced existing $hook_name"
  fi

  ln -s "$hook" "$target"
  chmod +x "$hook"
  echo "  ✓  $hook_name installed"
  installed=$((installed + 1))
done

if [ "$installed" -eq 0 ]; then
  echo "  No hooks found in $HOOKS_DIR"
else
  echo ""
  echo "✓  $installed hook(s) installed successfully"
  echo "   These hooks run locally before push (not in CI)."
fi
