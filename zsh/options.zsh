# SIGN COMMIT
export GPG_TTY=$(tty)

# USE RG FOR FZF COMMAND
export ENV FZF_DEFAULT_COMMAND='rg --files'

# EDITOR OPTION
export EDITOR='nvim'

# zsh ompletions
autoload -U compinit && compinit
