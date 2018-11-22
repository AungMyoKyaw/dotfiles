#!/bin/bash
# ----------------------------------------------
# AUTHOR: AUNG MYO KYAW
# URL: https://github.com/AungMyoKyaw/dotfiles
# LICENSE: MIT
# ----------------------------------------------

CURRENT_DIR=$PWD

# Backup vimrc
if [ -f "$HOME/.vim/vimrc" ]; then
  cp "$HOME/.vim/vimrc" "$HOME/.vim/vimrc.bk"
fi

# Backup tmux.conf
if [ -f "$HOME/.tmux.conf" ]; then
  cp "$HOME/.tmux.conf" "$HOME/.tmux.conf.bk"
fi

# Backup neo init.vim
if [ -f "$HOME/.config/nvim/init.vim" ]; then
  cp "$HOME/.config/nvim/init.vim" "$HOME/.config/nvim/init.vim.bk"
fi

# Backup zshrc 
if [ -f "$HOME/.zshrc" ]; then
  cp "$HOME/.zshrc" "$HOME/.zshrc.bk"
fi

# Backup aliases 
if [ -f "$HOME/.aliases" ]; then
  cp "$HOME/.aliases" "$HOME/.aliases.bk"
fi

# Make dir if no .vim folder exists
if [ ! -d "$HOME/.vim/" ]; then
  mkdir $HOME/.vim/
fi

# Make dir if no .config folder exists
if [ ! -d "$HOME/.config/" ]; then
  mkdir $HOME/.config/
fi

# Make dir if no neovim folder exists
if [ ! -d "$HOME/.config/nvim/" ]; then
  mkdir $HOME/.config/nvim/
fi

# create aliases file if aliases exists
if [ ! -f "$CURRENT_DIR/zsh/aliases" ]; then
  echo "# aliases" > $CURRENT_DIR/zsh/aliases
fi

# Linking rc
# ln -fs "$CURRENT_DIR/vim/vimrc" "$HOME/.vim/vimrc" # I switch to spacevim
# ln -fs "$CURRENT_DIR/nvim/nvimrc" "$HOME/.config/nvim/init.vim"
ln -fs "$CURRENT_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
ln -fs "$CURRENT_DIR/zsh/zshrc" "$HOME/.zshrc"
ln -fs "$CURRENT_DIR/zsh/aliases" "$HOME/.aliases"

# Installing SPACEVIM
# curl -sLf https://spacevim.org/install.sh | bash
rm $HOME/.SpaceVim.d/init.toml

# Make dir if no autoload folder exists
if [ ! -d "$HOME/.SpaceVim.d/autoload/" ]; then
  mkdir $HOME/.SpaceVim.d/autoload/
fi

ln -fs "$CURRENT_DIR/spacevim.d/init.toml" "$HOME/.SpaceVim.d/init.toml"
ln -fs "$CURRENT_DIR/spacevim.d/autoload/myspacevim.vim" "$HOME/.SpaceVim.d/autoload/myspacevim.vim"

echo "**************************"
echo "*                        *"
echo "* Installation Completed *"
echo "*                        *"
echo "**************************"
