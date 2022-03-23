source ~/.aliases.zsh
source ~/.default_aliases.zsh
source ~/.env.zsh
source ~/.functions.zsh
source ~/.options.zsh
source ~/.theme.zsh
source ~/.zsh_plugins.sh

eval $(thefuck --alias)

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
