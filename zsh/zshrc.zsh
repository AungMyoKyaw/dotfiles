source ~/.aliases.zsh
source ~/.default_aliases.zsh
source ~/.env.zsh
source ~/.secret-env.zsh
source ~/.functions.zsh
source ~/.options.zsh
source ~/.theme.zsh
source ~/.zsh_plugins.sh

eval $(thefuck --alias)
eval "$(fnm env)"
# eval "$(github-copilot-cli alias -- "$0")"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


# bun completions
[ -s "/Users/aungmyokyaw/.bun/_bun" ] && source "/Users/aungmyokyaw/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
