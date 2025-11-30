# Public .zshrc configuration
# This file is safe to share in version control

# Ghostty shell integration - Must be at the top of .zshrc!
if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
  source "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
fi

# Public aliases - Using pre-release versions for latest features
# alias qwen='npx @qwen-code/qwen-code@preview -y'
# alias claude='npx @anthropic-ai/claude-code@next --dangerously-skip-permissions'
# alias codex='npx @openai/codex@latest'
# alias gemini='npx @google/gemini-cli@preview -y'
# alias copilot='npx @github/copilot@prerelease --allow-all-tools --allow-all-paths --banner'
# alias openspec='npx @fission-ai/openspec@latest'
# alias opencode='npx opencode-ai@dev'
# alias crush='npx @charmland/crush@latest'
# alias rovodev='acli rovodev'

alias copilot='copilot --allow-all-tools --allow-all-paths'
alias claude='claude --dangerously-skip-permissions'

alias specify='uvx --from git+https://github.com/github/spec-kit.git specify'
alias vercel='npx vercel'

# Github Copilot CLI settings
# export COPILOT_MODEL='claude-haiku-4.5'
# export COPILOT_ALLOW_ALL=true

# git
alias g='git'

# nvim
alias n='nvim'

# tmuxinator
alias mx='tmuxinator'

# Chrome with remote debugging
alias chrome-debug='"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --remote-debugging-port=9222 --user-data-dir=/tmp/chrome-debug'

# DEFAULT LOCALE
export LC_ALL=en_US.UTF-8

# OPTING OUT HOMEBREW ANALYTICS
export HOMEBREW_NO_ANALYTICS=1

export DOCKER_DEFAULT_PLATFORM=linux/arm64

# Vagrant default provider
export VAGRANT_DEFAULT_PROVIDER=docker

# Consolidated PATH exports
export PATH="/usr/local/sbin:/opt/homebrew/bin:$HOME/.nimble/bin:$HOME/.cargo/bin:$HOME/.local/bin:$HOME/.config/emacs/bin:$PATH"

# Update Zsh plugins
updateplugin(){
  reload
}

# reload
reload(){
  if source ~/.zshrc; then
    echo "ZSH config reloaded successfully"
  else
    echo "Error reloading ZSH config"
    return 1
  fi
}

# reload tmux
reload_tmux(){
  tmux source-file ~/.tmux.conf && echo "✓ tmux config reloaded"
}

# delete ds_store recursive
dsdelete(){
  find . -name '.DS_Store' -type f -delete
}

# shada delete
shadadelete(){
  rm -rf ~/.local/share/nvim/shada
}

# mac update
mac_update(){
  brew_update
  updateplugin
  nvim --headless "+Lazy! sync" +qa
  softwareupdate --all --install --force
}

# brew update
brew_update(){
  brew update
  brew upgrade
  brew cleanup
}

mxgen(){
for file in *; do
  if [ -d "$file" ]; then
    filenamelowercase=$(echo "$file" | tr '[:upper:]' '[:lower:]')
    cd $file
    mx-yml-gen --name=${filenamelowercase} --cp=true --mode=amk --editor=none
    cd ..
    echo $filenamelowercase
  fi
done
}

ip(){
  curl https://ipinfo.io/json | jq
}

# fzf list with preview and sorted with mru
fzfp(){
  fzf --preview 'bat --style=numbers --color=always --line-range :500 {}' --bind 'ctrl-r:toggle-sort'
}

# EDITOR OPTION
export EDITOR='nvim'
export VISUAL='nvim'

# Set environment variables for non-sensitive paths (moved to .zshrc.local)
# Local environment file will be sourced at the end of this file

# Obsidian function using the path from .zshrc.local
obsidian(){
  cd "$obsidian_personal"
}

eval "$(starship init zsh)"
eval "$(fnm env --use-on-cd --shell zsh)"
source <(fzf --zsh)

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# Reset development branch
reset_development_branch() {
    # Exit immediately if a command exits with a non-zero status
    set -e

    # Function to display informational messages
    echo_info() {
        echo -e "\033[1;34m[INFO]\033[0m $1"
    }

    # Function to display error messages
    echo_error() {
        echo -e "\033[1;31m[ERROR]\033[0m $1" >&2
    }

    # Ensure the current directory is a Git repository
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo_error "This function must be run inside a Git repository."
        return 1
    fi

    # Define the target branch
    TARGET_BRANCH="development"

    # Fetch the latest updates from the remote
    echo_info "Fetching the latest updates from the remote..."
    git fetch origin

    # Check if the target branch exists locally
    if git show-ref --verify --quiet "refs/heads/$TARGET_BRANCH"; then
        echo_info "Checking out to the '$TARGET_BRANCH' branch..."
        git checkout "$TARGET_BRANCH"
    else
        echo_error "Branch '$TARGET_BRANCH' does not exist locally."
        return 1
    fi

    # Find the first commit in the branch
    echo_info "Finding the first commit in the '$TARGET_BRANCH' branch..."
    FIRST_COMMIT=$(git rev-list --max-parents=0 "$TARGET_BRANCH")

    if [ -z "$FIRST_COMMIT" ]; then
        echo_error "Unable to find the first commit in '$TARGET_BRANCH'."
        return 1
    fi

    echo_info "First commit found: $FIRST_COMMIT"

    # Perform a hard reset to the first commit
    echo_info "Performing a hard reset to the first commit..."
    git reset --hard "$FIRST_COMMIT"

    # Pull the latest changes from the remote development branch
    echo_info "Pulling the latest changes from 'origin/$TARGET_BRANCH'..."
    git pull origin "$TARGET_BRANCH"

    echo_info "Reset and pull operation on '$TARGET_BRANCH' completed successfully."
}

# zsh completions - moved to end for better performance
# Only load if we're in an interactive shell
if [[ $- == *i* ]]; then
  autoload -U compinit && compinit
fi

# Added by Windsurf - Next
export PATH="$HOME/.codeium/windsurf/bin:$PATH"

# GPG Configuration
export GPG_TTY=$(tty)
# Start gpg-agent if not running
if ! pgrep -x "gpg-agent" > /dev/null; then
    gpg-agent --daemon --enable-ssh-support > /dev/null 2>&1
fi
gpgconf --kill gpg-agent
gpgconf --launch gpg-agent

export PYTHONWARNINGS="ignore::UserWarning:azext_devops"

# Disable Azure Developer CLI telemetry
export AZURE_DEV_COLLECT_TELEMETRY=no

[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code-insiders --locate-shell-integration-path zsh)"

# Luaver - Lua Version Manager (uses system binary, no init script needed)
# Luaver completions are available at ~/.luaver/completions/luaver.bash

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# ===================================
# ADDITIONAL ALIASES AND UTILITIES
# ===================================

# Useful navigation aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Git status alias
alias gs='git status'

# Better ls with colors
alias ls='ls -G'
alias ll='ls -la'
alias la='ls -la'

# Quick edit config files
alias ez='nvim ~/.zshrc'
alias et='nvim ~/.tmux.conf'

# Quick directory size check
alias ds='du -sh'

# Process search
alias psa='ps aux | grep'

# Kill all processes functions
killall_node() {
  if pgrep -f "node" > /dev/null; then
    echo "Killing all Node.js processes..."
    pkill -f "node"
    echo "✓ All Node.js processes killed"
  else
    echo "No Node.js processes found"
  fi
}

killall_nvim() {
  if pgrep -f "nvim" > /dev/null; then
    echo "Killing all Neovim processes..."
    pkill -f "nvim"
    echo "✓ All Neovim processes killed"
  else
    echo "No Neovim processes found"
  fi
}

# Combined function to kill development processes
killall_dev() {
  echo "Killing development processes..."
  killall_node
  killall_nvim
  pkill -f "claude" && echo "✓ Claude Code CLI processes killed" || echo "No Claude Code CLI processes found"
}

# Kill browser processes (resource intensive)
killall_browsers() {
  echo "Killing browser processes..."
  pkill -f "Chrome" && echo "✓ Chrome processes killed" || echo "No Chrome processes found"
  pkill -f "Safari" && echo "✓ Safari processes killed" || echo "No Safari processes found"
  pkill -f "Firefox" && echo "✓ Firefox processes killed" || echo "No Firefox processes found"
  pkill -f "Arc" && echo "✓ Arc processes killed" || echo "No Arc processes found"
}

# Kill Adobe processes (notorious resource hogs)
killall_adobe() {
  echo "Killing Adobe processes..."
  pkill -f "Adobe" && echo "✓ Adobe processes killed" || echo "No Adobe processes found"
}

# Kill Microsoft Office processes
killall_office() {
  echo "Killing Microsoft Office processes..."
  pkill -f "Microsoft" && echo "✓ Microsoft Office processes killed" || echo "No Microsoft processes found"
}

# Kill Docker and container processes
killall_docker() {
  echo "Killing Docker processes..."
  pkill -f "Docker" && echo "✓ Docker processes killed" || echo "No Docker processes found"
  docker system prune -f 2>/dev/null && echo "✓ Docker cleanup completed" || true
}

# Kill development tools
killall_devtools() {
  echo "Killing development tools..."
  pkill -f "Postman" && echo "✓ Postman killed" || echo "No Postman processes found"
  pkill -f "Insomnia" && echo "✓ Insomnia killed" || echo "No Insomnia processes found"
  pkill -f "TablePlus" && echo "✓ TablePlus killed" || echo "No TablePlus processes found"
  pkill -f "Sequel Ace" && echo "✓ Sequel Ace killed" || echo "No Sequel Ace processes found"
}

# Kill communication apps
killall_communication() {
  echo "Killing communication apps..."
  pkill -f "Slack" && echo "✓ Slack killed" || echo "No Slack processes found"
  pkill -f "Discord" && echo "✓ Discord killed" || echo "No Discord processes found"
  pkill -f "Zoom" && echo "✓ Zoom killed" || echo "No Zoom processes found"
  pkill -f "Teams" && echo "✓ Teams killed" || echo "No Teams processes found"
}

# Kill design and creative tools
killall_design() {
  echo "Killing design tools..."
  pkill -f "Figma" && echo "✓ Figma killed" || echo "No Figma processes found"
  pkill -f "Sketch" && echo "✓ Sketch killed" || echo "No Sketch processes found"
  pkill -f "Canva" && echo "✓ Canva killed" || echo "No Canva processes found"
}

# Kill system monitoring/stats tools
killall_stats() {
  echo "Killing system monitoring tools..."
  pkill -f "iStat" && echo "✓ iStat Menus killed" || echo "No iStat processes found"
  pkill -f "Activity Monitor" && echo "✓ Activity Monitor killed" || echo "No Activity Monitor processes found"
  pkill -f "Stats" && echo "✓ Stats killed" || echo "No Stats processes found"
}

# Nuke everything - kill all non-essential processes
killall_performance() {
  echo "🔥 KILLING ALL PERFORMANCE-KILLING PROCESSES 🔥"
  echo ""

  killall_browsers
  echo ""

  killall_adobe
  echo ""

  killall_office
  echo ""

  killall_devtools
  echo ""

  killall_communication
  echo ""

  killall_design
  echo ""

  killall_stats
  echo ""

  killall_docker
  echo ""

  killall_dev
  echo ""

  echo "✅ PERFORMANCE NUKING COMPLETE!"
  echo "💡 Run 'top' or 'htop' to see remaining processes"
}

# Show top resource-consuming processes
show_resource_hogs() {
  echo "🔍 Top 10 CPU-consuming processes:"
  ps aux | sort -rn -k 3 | head -11 | tail -10
  echo ""
  echo "💾 Top 10 Memory-consuming processes:"
  ps aux | sort -rn -k 4 | head -11 | tail -10
}

# Update AI CLI tools to latest versions
update_ai_tools() {
  echo "🤖 Updating AI CLI tools to latest versions..."
  echo ""

  # Update npm global packages
  echo "📦 Updating npm global packages..."

  tools=(
    "@qwen-code/qwen-code@preview"
    "@anthropic-ai/claude-code@next"
    "@openai/codex@latest"
    "@google/gemini-cli@preview"
    "@github/copilot@prerelease"
    "@fission-ai/openspec@latest"
    "opencode-ai@dev"
    "@charmland/crush@latest"
  )

  for package in "${tools[@]}"; do
    echo "Updating $package..."
    if npm i -g "$package" > /dev/null 2>&1; then
      echo "✓ $package installed globally"
    else
      echo "⚠ Failed to install $package globally"
    fi
  done
  echo ""

  # Update uvx-based tools
  echo "⚡ Updating uvx-based tools..."
  if command -v uvx > /dev/null 2>&1; then
    if uvx --from git+https://github.com/github/spec-kit.git specify --version > /dev/null 2>&1; then
      echo "✓ specify updated successfully"
    else
      echo "⚠ Failed to update specify"
    fi
  else
    echo "⚠ uvx not found, skipping specify"
  fi
  echo ""

  # Update bun-based tools if bun is available
  echo "🥟 Updating bun-based tools..."
  if command -v bun > /dev/null 2>&1; then
    if bun update > /dev/null 2>&1; then
      echo "✓ bun packages updated"
    else
      echo "⚠ Failed to update bun packages"
    fi
  else
    echo "⚠ bun not found, skipping bun updates"
  fi
  echo ""

  # Update Vercel CLI
  echo "▲ Updating Vercel CLI..."
  if npm i -g vercel@latest > /dev/null 2>&1; then
    echo "✓ Vercel CLI installed globally"
  else
    echo "⚠ Failed to install Vercel CLI globally"
  fi
  echo ""

  echo "🎉 AI CLI tools update complete!"
  echo "💡 Run 'reload' to refresh your shell environment"
}

# Network utilities
alias myip='curl ipinfo.io/ip'

# Goose desktop alias
alias goose-desktop='open -a Goose .'

export PATH="$HOME/bin:$PATH"

# ===================================
# ZSH PLUGINS AND COMPLETIONS
# ===================================

# Source zsh plugins using paths from .zshrc.local
# Note: Update these paths if needed to match your local setup
if [[ -f "$ZSH_AUTOSUGGESTIONS_PATH" ]]; then
  source "$ZSH_AUTOSUGGESTIONS_PATH"
fi

if [[ -f "$ZSH_SYNTAX_HIGHLIGHTING_PATH" ]]; then
  source "$ZSH_SYNTAX_HIGHLIGHTING_PATH"
fi

if [[ -f "$ZSH_GIT_PLUGIN_PATH" ]]; then
  source "$ZSH_GIT_PLUGIN_PATH"
fi

if [[ -f "$ZSH_DOCKER_RUN_PATH" ]]; then
  source "$ZSH_DOCKER_RUN_PATH"
fi

# Load brew zsh-autosuggestions if available
# Only load if we're in an interactive shell
if [[ $- == *i* ]] && [[ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Docker CLI completions
# Check multiple possible locations for Docker completions
DOCKER_COMPLETION_DIRS=(
  "$HOME/.docker/completions"
  "$(brew --prefix)/share/zsh/site-functions"
  "$(brew --prefix)/share/zsh-completions"
  "/usr/local/share/zsh/site-functions"
  "/opt/homebrew/share/zsh/site-functions"
  "/opt/homebrew/share/zsh-completions"
)

for docker_comp_dir in "${DOCKER_COMPLETION_DIRS[@]}"; do
  if [[ -d "$docker_comp_dir" ]] && [[ -f "$docker_comp_dir/_docker" ]]; then
    fpath=($docker_comp_dir $fpath)
      break
  fi
done

# If no Docker completions found, try to generate them
if ! type _docker > /dev/null 2>&1; then
  if command -v docker > /dev/null 2>&1; then
    # Try to create completions directory and generate completion
    mkdir -p "$HOME/.docker/completions" 2>/dev/null
    if docker completion zsh > "$HOME/.docker/completions/_docker" 2>/dev/null; then
      fpath=($HOME/.docker/completions $fpath)
      else
      echo "⚠ Unable to generate Docker completions - Docker CLI may not support completion generation"
    fi
  else
    echo "⚠ Docker not found - completions unavailable"
  fi
fi

# Ensure completions are loaded
autoload -Uz compinit
compinit
# End of Docker CLI completions

# Kubectl completion and aliases
if command -v kubectl &> /dev/null; then
  # Load kubectl completion using runtime approach for better compatibility
  if source <(kubectl completion zsh) 2>/dev/null; then
    true  # Silent completion
  else
    echo "⚠ Kubectl completion failed to load"
  fi

  # Kubectl aliases for enhanced productivity
  alias k='kubectl'
  alias kg='kubectl get'
  alias kd='kubectl describe'
  alias kdel='kubectl delete'
  alias klogs='kubectl logs'
  alias kex='kubectl exec -it'
  alias kapply='kubectl apply -f'
  alias kcreate='kubectl create -f'
  alias kedit='kubectl edit'
  alias kscale='kubectl scale'
  alias ktop='kubectl top'

  # Context and namespace management
  alias kctx='kubectl config current-context'
  alias kctxs='kubectl config get-contexts'
  alias kuse='kubectl config use-context'
  alias kns='kubectl config set-context --current --namespace'
  alias knsg='kubectl config view --minify | grep namespace'

  # Resource shortcuts
  alias kgpo='kubectl get pods'
  alias kgs='kubectl get services'
  alias kgd='kubectl get deployments'
  alias kgi='kubectl get ingress'
  alias kgcm='kubectl get configmaps'
  alias kgsec='kubectl get secrets'
  alias kgpv='kubectl get pv'
  alias kgpvc='kubectl get pvc'

  # Describe shortcuts
  alias kdpo='kubectl describe pods'
  alias kdds='kubectl describe services'
  alias kdd='kubectl describe deployments'

  # Port forwarding and exec shortcuts
  alias kpf='kubectl port-forward'
  alias kexec='kubectl exec -it'

  # Dry-run and export aliases
  export do="--dry-run=client -o yaml"

  # Quick status commands
  alias khealth='kubectl get componentstatuses'
  alias knodes='kubectl get nodes -o wide'
  alias kversion='kubectl version --client && kubectl version --short'
else
  echo "⚠ Kubectl not found - completion and aliases disabled"
fi

# bun completions
[ -s ~/.bun/_bun ] && source ~/.bun/_bun

# ===================================
# LOCAL CONFIGURATION
# ===================================

# Source local environment file for sensitive information
# This file should NOT be committed to version control
if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi

# Added by Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
