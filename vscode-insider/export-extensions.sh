#!/bin/zsh
# export-extensions.sh
# Exports the list of installed VS Code Insiders extensions to extensions.txt in this folder.
# Usage: ./export-extensions.sh

CODE_CMD="code-insiders"
OUTPUT_FILE="$(dirname "$0")/extensions.txt"

$CODE_CMD --list-extensions > "$OUTPUT_FILE"
echo "Exported extensions to $OUTPUT_FILE"
