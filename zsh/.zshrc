# Public .zshrc configuration
# This file is safe to share in version control

# Public aliases
alias qwen='npx @qwen-code/qwen-code@preview -y'
alias claude='npx @anthropic-ai/claude-code@next'
alias gemini='npx @google/gemini-cli@preview -y'

alias rovodev='acli rovodev'

# git
alias g='git'

# nvim
alias n='nvim'

# neovide
alias nev='neovide'

# tmuxinator
alias mx='tmuxinator'

# COPYTO SYSTEM CLIPBOARD
alias dcp='cat ./dcp.txt | pbcopy'

# nwjs
alias nw='/Applications/nwjs.app/Contents/MacOS/nwjs'

# DEFAULT LOCALE
export LC_ALL=en_US.UTF-8

# OPTING OUT HOMEBREW ANALYTICS
export HOMEBREW_NO_ANALYTICS=1

export DOCKER_DEFAULT_PLATFORM=linux/amd64

# Consolidated PATH exports
export PATH="/usr/local/sbin:/opt/homebrew/bin:$HOME/.nimble/bin:$HOME/.cargo/bin:$PATH"

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
  tmux source-file ~/.tmux.conf
}

# set up adguardHome DNS
adguard_setup(){
  docker run --name adguardhome -v $(pwd)/workdir:/opt/adguardhome/work -v $(pwd)/confdir:/opt/adguardhome/conf -p 53:53/tcp -p 53:53/udp -p 67:67/udp -p 68:68/tcp -p 68:68/udp -p 80:80/tcp -p 443:443/tcp -p 853:853/tcp -p 3000:3000/tcp -d adguard/adguardhome
}

# start adguard DNS
adguardstart(){
  docker start adguardhome
}

# delete ds_store recursive
dsdelete(){
  find . -name '.DS_Store' -type f -delete
}

# shada delete
shadadelete(){
  rm -rf ~/.local/share/nvim/shada
}

# Helper function for setting DNS servers
_set_dns() {
  local servers="$1"
  local network_name="iPhone USB"
  local network_name2="Wi-Fi"

  networksetup -setdnsservers "${network_name}" $servers
  networksetup -getdnsservers "${network_name}"

  networksetup -setdnsservers "${network_name2}" $servers
  networksetup -getdnsservers "${network_name2}"

  echo "DNS servers successfully updated for ${network_name2}"
}

# DNS setting functions using the helper
adguarddns() {
  _set_dns "94.140.14.14 94.140.15.15 1.1.1.1 1.0.0.1"
}

cloudflare() {
  _set_dns "1.1.1.1 1.0.0.1"
}

cloudflare_amk() {
  _set_dns "172.64.36.1 172.64.36.2"
}

googledns() {
  _set_dns "8.8.8.8 8.8.4.4"
}

adguarddns_selfhosted() {
  _set_dns "127.0.0.1 172.17.0.3 94.140.14.14 94.140.15.15 1.1.1.1 1.0.0.1"
}


# python static
http_server(){
  PORT="$1"
  if [[ -n "${PORT}" ]]; then
    # Try Python 3 first, fallback to Python 2
    if command -v python3 &> /dev/null; then
      python3 -m http.server ${PORT}
    else
      python -m SimpleHTTPServer ${PORT}
    fi
  else
    # Try Python 3 first, fallback to Python 2
    if command -v python3 &> /dev/null; then
      python3 -m http.server
    else
      python -m SimpleHTTPServer
    fi
  fi
}

# mac update
mac_update(){
  brew_update
  updateplugin
  nvim --headless "+Lazy! sync" +qa
  nvim --headless "+MasonUpdateAll" +qa
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

# Set environment variables for non-sensitive paths (moved to .zshrc.local)
# Source local environment file for sensitive information
# This file should NOT be committed to version control
if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi

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

copyallfilescontent() {
  # Check if a directory is passed as an argument, default to the current directory
  local DIR=${1:-"."}

  # Check if the directory exists
  if [ -d "$DIR" ]; then
    local CONTENT=""

    # Loop through all files in the directory
    for FILE in "$DIR"/*; do
      # Check if it's a file
      if [ -f "$FILE" ]; then
        # Concatenate the file contents with a line break
        CONTENT="$CONTENT$(cat "$FILE")
"
      fi
    done

    # Copy the concatenated content to clipboard using pbcopy
    echo -e "$CONTENT" | pbcopy
    echo "All file contents concatenated and copied to clipboard."
  else
    echo "Directory does not exist."
  fi
}

# zsh completions - moved to end for better performance
# Only load if we're in an interactive shell
if [[ $- == *i* ]]; then
  autoload -U compinit && compinit
fi


# Source local environment file for sensitive information (if it exists)
# This file should NOT be committed to version control
if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi

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

[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code-insiders --locate-shell-integration-path zsh)"

# Load brew zsh-autosuggestions if available
# Only load if we're in an interactive shell
if [[ $- == *i* ]] && [[ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Docker CLI completions
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
if [[ -d "$HOME/.docker/completions" ]]; then
  fpath=($HOME/.docker/completions $fpath)
  autoload -Uz compinit
  compinit
fi
# End of Docker CLI completions

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

# Network utilities
alias myip='curl ipinfo.io/ip'
