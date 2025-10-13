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
  "$DOTFILES_DIR/gemini/settings.json:/Library/Application Support/GeminiCli/settings.json"
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
  "$DOTFILES_DIR/gemini/GEMINI.md:/Library/Application Support/GeminiCli/GEMINI.md"
  "$DOTFILES_DIR/zed/settings.json:$HOME/.config/zed/settings.json"
  "$DOTFILES_DIR/zed/keymap.json:$HOME/.config/zed/keymap.json"
  "$DOTFILES_DIR/rovodev/config.yml:$HOME/.rovodev/config.yml"
  # "$DOTFILES_DIR/rovodev/mcp.json:$HOME/.rovodev/mcp.json"
  "$DOTFILES_DIR/qwen/settings.json:$HOME/.qwen/settings.json"
  "$DOTFILES_DIR/qwen/QWEN.md:$HOME/.qwen/QWEN.md"
  "$DOTFILES_DIR/opencode/settings.json:$HOME/.config/opencode/settings.json"
  "$DOTFILES_DIR/claude/.claude/settings.json:$HOME/.claude/settings.json"
  "$DOTFILES_DIR/claude/.claude/CLAUDE.md:$HOME/.claude/CLAUDE.md"
  "$DOTFILES_DIR/claude/.claude/commands:$HOME/.claude/commands"
  "$DOTFILES_DIR/zsh/.zshrc:$HOME/.zshrc"
  "$DOTFILES_DIR/zsh/.zshrc.local:$HOME/.zshrc.local"
)

# Backup directory
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Helper: try command, and if it fails due to permissions, retry with sudo
run_with_sudo_if_needed() {
  if "$@"; then
    return 0
  fi
  echo "⚠️ Command failed, retrying with sudo: $*"
  if sudo "$@"; then
    return 0
  fi
  return 1
}

# Ensure parent directory exists (tries normal mkdir, then sudo)
ensure_parent_dir() {
  parent="$1"
  if mkdir -p "$parent" 2>/dev/null; then
    return 0
  fi
  echo "⚠️ Unable to create directory '$parent' without elevated privileges, trying with sudo..."
  if sudo mkdir -p "$parent"; then
    return 0
  fi
  echo "❌ Failed to create directory: $parent (even with sudo)"
  return 1
}

# Move (backup) handling that retries with sudo when required
safe_move_to_backup() {
  src="$1"
  dest_dir="$2"
  if mv "$src" "$dest_dir/" 2>/dev/null; then
    return 0
  fi
  echo "⚠️ mv failed for '$src' (permission?), retrying with sudo..."
  if sudo mv "$src" "$dest_dir/"; then
    return 0
  fi
  echo "❌ Failed to move '$src' to backup at '$dest_dir'"
  return 1
}

# Create symlink, retrying with sudo if necessary
create_symlink() {
  src="$1"
  dest="$2"
  # Try normal ln and capture error
  err=$(ln -s "$src" "$dest" 2>&1) || true
  if [[ -z "$err" ]]; then
    return 0
  fi

  echo "⚠️ Failed to create symlink (normal): $err"
  echo "⚠️ Retrying with sudo: ln -s '$src' '$dest'"

  # Try sudo ln directly and capture error
  sudo_err=$(sudo ln -s "$src" "$dest" 2>&1) || true
  if [[ -z "$sudo_err" ]]; then
    return 0
  fi

  echo "⚠️ sudo ln also failed: $sudo_err"

  # Try a sudo bash -c fallback (helps when sudo can't interpret args with spaces)
  echo "⚠️ Trying fallback: sudo bash -c 'ln -s "${src}" "${dest}"'"
  fallback_err=$(sudo bash -c "ln -s '$src' '$dest'" 2>&1) || true
  if [[ -z "$fallback_err" ]]; then
    return 0
  fi

  echo "❌ All attempts to create symlink failed. Last error: $fallback_err"
  return 1
}

# Symlink everything
for file in "${FILES_TO_LINK[@]}"; do
  src="${file%%:*}"
  dest="${file##*:}"
  echo "Processing $src -> $dest"

  if [[ ! -e "$src" ]]; then
    echo "❌ Error: Source '$src' does not exist!"
    continue
  fi

  # Ensure parent directory exists (handles system dirs and will retry with sudo)
  parent_dir="$(dirname "$dest")"
  if ! ensure_parent_dir "$parent_dir"; then
    echo "❌ Skipping $dest because its parent directory could not be created: $parent_dir"
    continue
  fi

  # If destination is a symlink that already points to the same (real) source, skip it
  if [[ -L "$dest" ]]; then
    # Try to resolve real paths (use perl's Cwd::realpath which is commonly available on macOS)
    real_src=$(perl -MCwd -le 'print Cwd::realpath(shift)' "$src" 2>/dev/null || echo "")
    real_dest=$(perl -MCwd -le 'print Cwd::realpath(shift)' "$dest" 2>/dev/null || echo "")

    if [[ -n "$real_src" && -n "$real_dest" && "$real_src" == "$real_dest" ]]; then
      echo "🔗 Already linked: $dest -> $src (skipping)"
      continue
    else
      echo "🔄 Backing up existing symlink (points elsewhere): $dest -> $BACKUP_DIR"
      if ! safe_move_to_backup "$dest" "$BACKUP_DIR"; then
        echo "❌ Could not back up existing symlink: $dest. Skipping this entry."
        continue
      fi
    fi

  # If destination exists (and is not the same symlink), back it up
  elif [[ -e "$dest" ]]; then
    echo "🔄 Backing up existing file/directory: $dest -> $BACKUP_DIR"
    if ! safe_move_to_backup "$dest" "$BACKUP_DIR"; then
      echo "❌ Could not back up existing file/directory: $dest. Skipping this entry."
      continue
    fi
  fi

  # Create the symlink
  if create_symlink "$src" "$dest"; then
    echo "✅ Symlink created: $dest -> $src"
  else
    echo "❌ Failed to create symlink: $dest -> $src"
    echo "   Tip: This path may require elevated privileges. Try running the script with 'sudo' or make sure you have write permission to '$(dirname "$dest")'"
  fi
done

echo "✅ All dotfiles linked!"
echo "📁 Backup stored at: $BACKUP_DIR"
