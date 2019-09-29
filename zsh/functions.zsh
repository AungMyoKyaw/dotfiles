# hello world
hw(){
  echo "hello world"
}

# Update Zsh plugins
updateplugin(){
  antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh
  antibody update
  reload
}

# reload
reload(){
  source ~/.zshrc
}

# reload tmux
reload_tmux(){
  tmux source-file ~/.tmux.conf
}
