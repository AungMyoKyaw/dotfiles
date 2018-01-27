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

# Linking rc
ln -fs "$CURRENT_DIR/vim/vimrc" "$HOME/.vim/vimrc"
ln -fs "$CURRENT_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
ln -fs "$CURRENT_DIR/nvim/nvimrc" "$HOME/.config/nvim/init.vim"

echo "**************************"
echo "*                        *"
echo "* Installation Completed *"
echo "*                        *"
echo "**************************"
