#!/usr/bin/env bash
set -euo pipefail

# Wavecraft Uninstaller
INSTALL_DIR="${HOME}/.claude/skills/wavecraft"

if [ ! -d "$INSTALL_DIR" ]; then
    echo "Wavecraft is not installed at $INSTALL_DIR"
    exit 0
fi

echo "This will remove Wavecraft from $INSTALL_DIR"
read -p "Continue? (y/N) " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

rm -rf "$INSTALL_DIR"
echo "Wavecraft uninstalled."
