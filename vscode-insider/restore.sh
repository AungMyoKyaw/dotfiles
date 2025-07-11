#!/bin/zsh
# Restore VS Code Insiders extensions and settings from dotfiles

# Install extensions
if [ -f "$(dirname "$0")/extensions.txt" ]; then
  cat "$(dirname "$0")/extensions.txt" | xargs -L 1 code-insiders --install-extension
else
  echo "extensions.txt not found!"
fi

# Symlink settings and keybindings (edit paths as needed)
USER_DIR="$HOME/Library/Application Support/Code - Insiders/User"
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

ln -sf "$DOTFILES_DIR/settings.json" "$USER_DIR/settings.json"
ln -sf "$DOTFILES_DIR/keybindings.json" "$USER_DIR/keybindings.json"

echo "VS Code Insiders extensions and settings restored."
