#!/bin/bash
# ----------------------------------------------
# AUTHOR: AUNG MYO KYAW
# URL: https://github.com/AungMyoKyaw/dotfiles
# LICENSE: MIT © Aung Myo Kyaw
# ----------------------------------------------

CURRENT_DIR=$PWD

prerequisite(){
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
}

# todo
# prerequisite check

install_dotfiles(){
  backup_vim_rc
  backup_tmux_conf
  backup_zsh_rc
  backup_aliases
  makesure_file_exist
  linking_rc
  install_tmux_plugin
  showSuccessMessage
}

# BACKUP VIMRC
backup_vim_rc(){
  if [ -f "$HOME/.vim/vimrc" ]; then
    cp "$HOME/.vim/vimrc" "$HOME/.vim/vimrc.bk"
  fi
}

# BACKUP TMUX.CONF
backup_tmux_conf(){
  if [ -f "$HOME/.tmux.conf" ]; then
    cp "$HOME/.tmux.conf" "$HOME/.tmux.conf.bk"
  fi
}

# BACKUP ZSHRC
backup_zsh_rc(){
  if [ -f "$HOME/.zshrc" ]; then
    cp "$HOME/.zshrc" "$HOME/.zshrc.bk"
  fi
}

# BACKUP ALIASES
backup_aliases(){
  if [ -f "$HOME/.aliases" ]; then
    cp "$HOME/.aliases" "$HOME/.aliases.bk"
  fi
}

# MAKE SURE REQUIRED FILE EXISTS
makesure_file_exist(){
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

  # MAKE DIR IF NO .SPACEVIM.D FOLDER EXISTS
  if [ ! -d "$HOME/.SpaceVim.d/" ]; then
    mkdir $HOME/.SpaceVim.d/
  fi

  # MAKE DIR IF NO AUTOLOAD FOLDER EXISTS
  if [ ! -d "$HOME/.SpaceVim.d/autoload/" ]; then
    mkdir $HOME/.SpaceVim.d/autoload/
  fi

  # MAKE FILE IF NO INIT.TOML EXISTS
  if [ ! -f "$HOME/.SpaceVim.d/init.toml" ]; then
    touch $HOME/.SpaceVim.d/init.toml
  fi

  # MAKE FILE IF NO MYSPACEVIM.VIM EXISTS
  if [ ! -f "$HOME/.SpaceVim.d/autoload/myspacevim.vim" ]; then
    touch $HOME/.SpaceVim.d/autoload/myspacevim.vim
  fi
}

# LINKING RC
linking_rc(){
  # ln -fs "$CURRENT_DIR/vim/vimrc" "$HOME/.vim/vimrc" # I SWITCH TO SPACEVIM
  # ln -fs "$CURRENT_DIR/nvim/nvimrc" "$HOME/.config/nvim/init.vim"
  ln -fs "$CURRENT_DIR/spacevim.d/autoload/myspacevim.vim" "$HOME/.SpaceVim.d/autoload/myspacevim.vim"
  ln -fs "$CURRENT_DIR/spacevim.d/init.toml" "$HOME/.SpaceVim.d/init.toml"
  ln -fs "$CURRENT_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
  ln -fs "$CURRENT_DIR/vim/xvimrc" "$HOME/.xvimrc"
  ln -fs "$CURRENT_DIR/zsh/aliases" "$HOME/.aliases.zsh"
  ln -fs "$CURRENT_DIR/zsh/default_aliases.zsh" "$HOME/.default_aliases.zsh"
  ln -fs "$CURRENT_DIR/zsh/env.zsh" "$HOME/.env.zsh"
  ln -fs "$CURRENT_DIR/zsh/functions.zsh" "$HOME/.functions.zsh"
  ln -fs "$CURRENT_DIR/zsh/options.zsh" "$HOME/.options.zsh"
  ln -fs "$CURRENT_DIR/zsh/plugins.txt" "$HOME/.zsh_plugins.txt"
  ln -fs "$CURRENT_DIR/zsh/theme.zsh" "$HOME/.theme.zsh"
  ln -fs "$CURRENT_DIR/zsh/zshrc.zsh" "$HOME/.zshrc"
}

# INSTALLING REQUIRED TMUX PLUGIN
install_tmux_plugin(){
  tmux source-file ~/.tmux.conf
}

# reload zsh config
reload_zshrc(){
  source ~/.zshrc
}

showSuccessMessage(){
  echo "☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭"
  echo "☭                        ☭"
  echo "☭ INSTALLATION COMPLETED ☭"
  echo "☭                        ☭"
  echo "☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭☭"
  exit 0
}

main(){
  install_dotfiles
}

main
