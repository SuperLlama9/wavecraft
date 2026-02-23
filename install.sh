#!/usr/bin/env bash
set -euo pipefail

# Wavecraft Installer for Claude Code
# Installs skills to ~/.claude/skills/wavecraft/ for global availability

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="${HOME}/.claude/skills/wavecraft"

echo "Wavecraft Installer"
echo "==================="
echo ""

# Check if already installed
if [ -d "$INSTALL_DIR" ]; then
    echo "Wavecraft is already installed at $INSTALL_DIR"
    read -p "Overwrite? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 0
    fi
    rm -rf "$INSTALL_DIR"
fi

# Create directory structure
mkdir -p "$INSTALL_DIR"

# Copy skills
echo "Installing skills..."
cp -r "$SCRIPT_DIR/skills/"* "$INSTALL_DIR/"

# Count what was installed
SKILL_COUNT=$(find "$INSTALL_DIR" -maxdepth 1 -type d | tail -n +2 | wc -l | tr -d ' ')
REF_COUNT=$(find "$INSTALL_DIR" -path "*/references/*.md" | wc -l | tr -d ' ')

echo ""
echo "Installed $SKILL_COUNT skills with $REF_COUNT reference files to:"
echo "  $INSTALL_DIR"
echo ""
echo "Skills available:"
for skill_dir in "$INSTALL_DIR"/*/; do
    skill_name=$(basename "$skill_dir")
    echo "  wavecraft:$skill_name"
done
echo ""
echo "Quick start:"
echo "  1. Open Claude Code in your project"
echo "  2. Say: \"setup project\" → triggers wavecraft:setup"
echo "  3. Say: \"write spec for [feature]\" → triggers wavecraft:spec"
echo "  4. Say: \"implement F001\" → triggers wavecraft:implement"
echo ""
echo "Done!"
