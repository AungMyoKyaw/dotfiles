#!/bin/bash
# ----------------------------------------------
# AUTHOR: AUNG MYO KYAW
# URL: https://github.com/AungMyoKyaw/dotfiles
# LICENSE: MIT © Aung Myo Kyaw
# ----------------------------------------------


# PREREQUISITE

# IS MAC OS INSTALLED
if [[ "$OSTYPE" != "darwin"* ]]; then
  echo ""
  echo "☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭"
  echo "☭ MAC OS SHOULD BE INSTALLED ☭"
  echo "☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭"
  echo ""
  exit 1
fi

# IS BREW INSTALLED
if ! hash "brew" &>/dev/null; then
  echo ""
  echo "☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭"
  echo "☭ BREW SHOULD BE INSTALLED ☭"
  echo "☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭"
  echo ""
  open https://brew.sh/
  exit 1
fi

# IS GIT INSTALLED
if ! hash "git" &>/dev/null; then
  echo "☭ GIT SHOULD BE INSTALLED"
  echo "☭ INSTALLING GIT"
  brew install git
fi

# INSTALLING TMUX
if ! hash "tmux" &>/dev/null; then
  echo "☭ INSTALLING TMUX"
  brew install tmux
  exit 1
fi

# INSTALLING TMUX PLUGIN MANAGER
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  echo "☭ INSTALLING TMUX PLUGIN MANAGER"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# IS SPACEVIM INSTALLED
if [[ ! -d "$HOME/.SpaceVim" ]]; then
  echo ""
  echo "☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭"
  echo "☭ SPACEVIM SHOULD BE INSTALLED ☭"
  echo "☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭"
  echo ""
  open https://spacevim.org/quick-start-guide/#install
  exit 1
fi

# IS OH-MY-ZSH INSTALLED
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo ""
  echo "☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭"
  echo "☭ OH-MY-ZSH SHOULD BE INSTALLED ☭"
  echo "☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭"
  echo ""
  open https://ohmyz.sh/
  exit 1
fi

#---------------------------
# MY DOTFILES INSTALLATION
#---------------------------

CURRENT_DIR=$PWD

# BACKUP VIMRC
if [ -f "$HOME/.vim/vimrc" ]; then
  cp "$HOME/.vim/vimrc" "$HOME/.vim/vimrc.bk"
fi

# BACKUP TMUX.CONF
if [ -f "$HOME/.tmux.conf" ]; then
  cp "$HOME/.tmux.conf" "$HOME/.tmux.conf.bk"
fi

# BACKUP ZSHRC
if [ -f "$HOME/.zshrc" ]; then
  cp "$HOME/.zshrc" "$HOME/.zshrc.bk"
fi

# BACKUP ALIASES
if [ -f "$HOME/.aliases" ]; then
  cp "$HOME/.aliases" "$HOME/.aliases.bk"
fi

# MAKE DIR IF NO .VIM FOLDER EXISTS
if [ ! -d "$HOME/.vim/" ]; then
  mkdir $HOME/.vim/
fi

# MAKE DIR IF NO .CONFIG FOLDER EXISTS
if [ ! -d "$HOME/.config/" ]; then
  mkdir $HOME/.config/
fi

# CREATE ALIASES FILE IF NO ALIASES FILE EXISTS
if [ ! -f "$CURRENT_DIR/zsh/aliases" ]; then
  echo "# aliases" > $CURRENT_DIR/zsh/aliases
fi

# LINKING RC
# ln -fs "$CURRENT_DIR/vim/vimrc" "$HOME/.vim/vimrc" # I SWITCH TO SPACEVIM
# ln -fs "$CURRENT_DIR/nvim/nvimrc" "$HOME/.config/nvim/init.vim"
ln -fs "$CURRENT_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
ln -fs "$CURRENT_DIR/zsh/zshrc" "$HOME/.zshrc"
ln -fs "$CURRENT_DIR/zsh/aliases" "$HOME/.aliases"
ln -fs "$CURRENT_DIR/vim/xvimrc" "$HOME/.xvimrc"

# INSTALLING SPACEVIM

# MAKE DIR IF NO AUTOLOAD FOLDER EXISTS
if [ ! -d "$HOME/.SpaceVim.d/autoload/" ]; then
  mkdir $HOME/.SpaceVim.d/autoload/
fi

ln -fs "$CURRENT_DIR/spacevim.d/init.toml" "$HOME/.SpaceVim.d/init.toml"
ln -fs "$CURRENT_DIR/spacevim.d/autoload/myspacevim.vim" "$HOME/.SpaceVim.d/autoload/myspacevim.vim"

# INSTALLING REQUIRED TMUX PLUGIN
tmux source ~/.tmux.conf

echo "☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭"
echo "☭                        ☭"
echo "☭ INSTALLATION COMPLETED ☭"
echo "☭                        ☭"
echo "☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭"

exit 0
