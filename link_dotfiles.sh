#!/usr/bin/env bash

# Get the script's directory (dotfiles location)
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Debug output
echo "DOTFILES_DIR is set to: $DOTFILES_DIR"
ls -l "$DOTFILES_DIR"  # Check contents of dotfiles directory

# List of dotfiles to symlink (now includes .zshenv and .zshenv.local)
FILES_TO_LINK=(
  "$DOTFILES_DIR/nvim/.config/nvim:$HOME/.config/nvim"
  "$DOTFILES_DIR/tmux/.tmux.conf:$HOME/.tmux.conf"
  "$DOTFILES_DIR/hammerspoon:$HOME/.hammerspoon"
  "$DOTFILES_DIR/gemini/settings.json:$HOME/.gemini/settings.json"
  "$DOTFILES_DIR/vscode-insider/keybindings.json:$HOME/Library/Application Support/Code - Insiders/User/keybindings.json"
  "$DOTFILES_DIR/vscode-insider/settings.json:$HOME/Library/Application Support/Code - Insiders/User/settings.json"
  "$DOTFILES_DIR/vscode-insider/mcp.json:$HOME/Library/Application Support/Code - Insiders/User/mcp.json"
  "$DOTFILES_DIR/vscode-insider/chatmodes:$HOME/Library/Application Support/Code - Insiders/User/chatmodes"
  "$DOTFILES_DIR/vscode-insider/instructions:$HOME/Library/Application Support/Code - Insiders/User/instructions"
  "$DOTFILES_DIR/vscode-insider/prompts:$HOME/Library/Application Support/Code - Insiders/User/prompts"
  "$DOTFILES_DIR/vscode-insider/keybindings.json:$HOME/Library/Application Support/Code/User/keybindings.json"
  "$DOTFILES_DIR/vscode-insider/settings.json:$HOME/Library/Application Support/Code/User/settings.json"
  "$DOTFILES_DIR/vscode-insider/mcp.json:$HOME/Library/Application Support/Code/User/mcp.json"
  "$DOTFILES_DIR/vscode-insider/chatmodes:$HOME/Library/Application Support/Code/User/chatmodes"
  "$DOTFILES_DIR/vscode-insider/instructions:$HOME/Library/Application Support/Code/User/instructions"
  "$DOTFILES_DIR/vscode-insider/prompts:$HOME/Library/Application Support/Code/User/prompts"
  "$DOTFILES_DIR/ghostty/config.toml:$HOME/.config/ghostty/config"
  "$DOTFILES_DIR/gemini/GEMINI.md:$HOME/.gemini/GEMINI.md"
  "$DOTFILES_DIR/rovodev/config.yml:$HOME/.rovodev/config.yml"
  "$DOTFILES_DIR/rovodev/mcp.json:$HOME/.rovodev/mcp.json"
)

# Backup directory
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Symlink everything
for file in "${FILES_TO_LINK[@]}"; do
  src="${file%%:*}"
  dest="${file##*:}"

  echo "Linking $src -> $dest"

  if [[ ! -e "$src" ]]; then
    echo "❌ Error: Source '$src' does not exist!"
    continue
  fi

  # If destination exists, back it up before removing
  if [[ -e "$dest" || -L "$dest" ]]; then
    echo "🔄 Backing up existing file/directory: $dest -> $BACKUP_DIR"
    mv "$dest" "$BACKUP_DIR/"
  fi

  # Ensure parent directory exists
  mkdir -p "$(dirname "$dest")"

  # Create the symlink
  ln -s "$src" "$dest"
  echo "✅ Symlink created: $dest -> $src"
done

echo "✅ All dotfiles linked!"
echo "📁 Backup stored at: $BACKUP_DIR"
