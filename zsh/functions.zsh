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

# set up adguardHome DNS
adguard_setup(){
  docker run --name adguardhome -v $(pwd)/workdir:/opt/adguardhome/work -v $(pwd)/confdir:/opt/adguardhome/conf -p 53:53/tcp -p 53:53/udp -p 67:67/udp -p 68:68/tcp -p 68:68/udp -p 80:80/tcp -p 443:443/tcp -p 853:853/tcp -p 3000:3000/tcp -d adguard/adguardhome
}

# start adguard DNS
adguardhome_start(){
  docker start adguardhome
}
