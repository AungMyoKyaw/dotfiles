#!/bin/zsh
# Script to install all VS Code extensions listed in extensions.txt

EXT_FILE="$(dirname "$0")/extensions.txt"

if [ ! -f "$EXT_FILE" ]; then
  echo "Error: extensions.txt not found at $EXT_FILE"
  exit 1
fi

while IFS= read -r extension || [ -n "$extension" ]; do
  if [ -n "$extension" ]; then
    echo "Installing $extension..."
    code --install-extension "$extension"
  fi
done < "$EXT_FILE"

echo "All extensions from $EXT_FILE have been processed."
