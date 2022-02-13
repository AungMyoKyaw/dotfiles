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
adguardstart(){
  docker start adguardhome
}

# delete ds_store recursive
dsdelete(){
  find . -name '.DS_Store' -type f -delete
}

# shada delete
shadadelete(){
  rm -rf ~/.local/share/nvim/shada
}

# set adguard dns
adguarddns(){
  # set networkname
  NETWORKNAME="iPhone USB"

  # set networkname
  NETWORKNAME2="Wi-Fi"

  # set dns servers
  networksetup -setdnsservers "${NETWORKNAME}" 94.140.14.14 94.140.15.15 1.1.1.1 1.0.0.1

  # get dns servers for verify
  networksetup -getdnsservers "${NETWORKNAME}"

  # set dns servers
  networksetup -setdnsservers "${NETWORKNAME2}" 94.140.14.14 94.140.15.15 1.1.1.1 1.0.0.1

  # get dns servers for verify
  networksetup -getdnsservers "${NETWORKNAME2}"

  echo "dns servers are now successfully updated for $NETWORKNAME2"
}

cloudflare(){
  # set networkname
  NETWORKNAME="iPhone USB"

  # set networkname
  NETWORKNAME2="Wi-Fi"

  # set dns servers
  networksetup -setdnsservers "${NETWORKNAME}" 1.1.1.1 1.0.0.1

  # get dns servers for verify
  networksetup -getdnsservers "${NETWORKNAME}"

  # set dns servers
  networksetup -setdnsservers "${NETWORKNAME2}" 1.1.1.1 1.0.0.1

  # get dns servers for verify
  networksetup -getdnsservers "${NETWORKNAME2}"

  echo "dns servers are now successfully updated for $NETWORKNAME2"
}


cloudflare_amk(){
  # set networkname
  NETWORKNAME="iPhone USB"

  # set networkname
  NETWORKNAME2="Wi-Fi"

  # set dns servers
  networksetup -setdnsservers "${NETWORKNAME}" 172.64.36.1 172.64.36.2

  # get dns servers for verify
  networksetup -getdnsservers "${NETWORKNAME}"

  # set dns servers
  networksetup -setdnsservers "${NETWORKNAME2}" 172.64.36.1 172.64.36.2

  # get dns servers for verify
  networksetup -getdnsservers "${NETWORKNAME2}"

  echo "dns servers are now successfully updated for $NETWORKNAME2"
}



googledns(){
  # set networkname
  NETWORKNAME="iPhone USB"

  # set networkname
  NETWORKNAME2="Wi-Fi"

  # set dns servers
  networksetup -setdnsservers "${NETWORKNAME}" 8.8.8.8 8.8.4.4

  # get dns servers for verify
  networksetup -getdnsservers "${NETWORKNAME}"

  # set dns servers
  networksetup -setdnsservers "${NETWORKNAME2}" 8.8.8.8 8.8.4.4

  # get dns servers for verify
  networksetup -getdnsservers "${NETWORKNAME2}"

  echo "dns servers are now successfully updated for $NETWORKNAME2"
}

# set adguard self hosetd dns
adguarddns_selfhosted(){
  # set networkname
  NETWORKNAME="iPhone USB"

  # set networkname
  NETWORKNAME2="Wi-Fi"

  # set dns servers
  networksetup -setdnsservers "${NETWORKNAME}" 127.0.0.1 172.17.0.3 94.140.14.14 94.140.15.15 1.1.1.1 1.0.0.1

  # get dns servers for verify
  networksetup -getdnsservers "${NETWORKNAME}"

  # set dns servers
  networksetup -setdnsservers "${NETWORKNAME2}" 127.0.0.1 172.17.0.3 94.140.14.14 94.140.15.15 1.1.1.1 1.0.0.1

  # get dns servers for verify
  networksetup -getdnsservers "${NETWORKNAME2}"

  echo "dns servers are now successfully updated for $NETWORKNAME2"
}


# python static
http_server(){
  PORT="$1"
  python -m SimpleHTTPServer
  if [[ -n "${PORT}" ]]; then
    python -m SimpleHTTPServer ${PORT}
  else
    python -m SimpleHTTPServer
  fi
}

# mac update
mac_update(){
  brew_update
  updateplugin
  softwareupdate --all --install --force
}

# brew update
brew_update(){
  brew update
  brew upgrade
}

mxgen(){
for file in *; do
  if [ -d "$file" ]; then
    filenamelowercase=$(echo "$file" | tr '[:upper:]' '[:lower:]')
    cd $file
    mx-yml-gen --name=${filenamelowercase} --cp=true
    cd ..
    echo $filenamelowercase
  fi
done
}

