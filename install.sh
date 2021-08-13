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

# BACKUP ssh config
backup_aliases(){
  if [ -f "$HOME/.ssh" ]; then
    cp "$HOME/.ssh/config" "$HOME/.ssh/config.bk"
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

  # MAKE DIR IF NO SSH FOLDER EXISTS
  if [ ! -d "$CURRENT_DIR/ssh/" ]; then
    mkdir $CURRENT_DIR/ssh
  fi

  # CREATE ALIASES FILE IF NO ALIASES FILE EXISTS
  if [ ! -f "$CURRENT_DIR/ssh/config" ]; then
    echo "# sshconfig" > $CURRENT_DIR/ssh/config
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

  # MAKE SURE .CONFIG DIR EXIST
  if [ ! -d "$HOME/.config/" ]; then
    mkdir $HOME/.config/
  fi

  # MAKE SURE NVIM DIR EXIST
  if [ ! -d "$HOME/.config/nvim/" ]; then
    mkdir $HOME/.config/nvim/
  fi

  # MAKE SURE .CONFIG/ALACRITTY DIR EXIST
  if [ ! -d "$HOME/.config/alacritty/" ]; then
    mkdir $HOME/.config/alacritty/
  fi

  # MAKE SURE ALACRITTY.YML FILE EXIST
  if [ ! -f "$HOME/.config/alacritty/alacritty.yml" ]; then
    touch $HOME/.config/alacritty/alacritty.yml
  fi

  # MAKE SURE .CONFIG/KITTY DIR EXIST
  if [ ! -d "$HOME/.config/kitty/" ]; then
    mkdir $HOME/.config/kitty/
  fi

  # MAKE SURE kitty.conf FILE EXIST
  if [ ! -f "$HOME/.config/kitty/kitty.conf" ]; then
    touch $HOME/.config/kitty/kitty.conf
  fi

  # MAKE SURE tmux-recurrect DIR EXIST
  if [ ! -d "$HOME/tmux-resurrect/" ]; then
    mkdir $HOME/tmux-resurrect/
  fi

  # MAKE SURE tmuxinator DIR EXIST
  if [ ! -d "$HOME/.config/tmuxinator/" ]; then
    mkdir $HOME/.config/tmuxinator/
  fi

}

# LINKING RC
linking_rc(){
  ln -fs "$CURRENT_DIR/alacritty/alacritty.yml" "$HOME/.config/alacritty/alacritty.yml"
  ln -fs "$CURRENT_DIR/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"
  ln -fs "$CURRENT_DIR/git/gitconfig" "$HOME/.gitconfig"
  ln -fs "$CURRENT_DIR/hammerspoon" "$HOME/.hammerspoon"
  ln -fs "$CURRENT_DIR/karabiner" "$HOME/.config/karabiner"
  ln -fs "$CURRENT_DIR/nvim/coc-settings.json" "$HOME/.config/nvim/coc-settings.json"
  ln -fs "$CURRENT_DIR/nvim/nvimrc" "$HOME/.config/nvim/init_backup.vim"
  ln -fs "$CURRENT_DIR/nvim-lua/init.lua" "$HOME/.config/nvim/init.lua"
  if [ ! -d "$HOME/.config/nvim/lua" ]; then
    ln -fs "$CURRENT_DIR/nvim-lua/lua" "$HOME/.config/nvim/lua"
  fi
  ln -fs "$CURRENT_DIR/ssh/config" "$HOME/.ssh/config"
  ln -fs "$CURRENT_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
  ln -fs "$CURRENT_DIR/tmux/recurrect" "$HOME/tmux-resurrect"
  ln -fs "$CURRENT_DIR/tmux/tmuxinator" "$HOME/.config/tmuxinator/"
  ln -fs "$CURRENT_DIR/vim/vimrc" "$HOME/.vim/vimrc"
  ln -fs "$CURRENT_DIR/vim/vimrc.bundles" "$HOME/.vim/vimrc.bundles"
  ln -fs "$CURRENT_DIR/vim/vimrc.me" "$HOME/.vim/vimrc.me"
  ln -fs "$CURRENT_DIR/vim/vimrc.pluginsettings" "$HOME/.vim/vimrc.pluginsettings"
  ln -fs "$CURRENT_DIR/vim/vimrc.sensible" "$HOME/.vim/vimrc.sensible"
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
  echo "--------------------------"
  echo "-                        -"
  echo "- INSTALLATION COMPLETED -"
  echo "-                        -"
  echo "--------------------------"
  exit 0
}

main(){
  install_dotfiles
}

main
