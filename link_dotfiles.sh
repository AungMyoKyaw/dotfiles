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
