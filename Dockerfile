FROM spacevim/spacevim
COPY ./spacevim.d $HOME/.SpaceVim.d

RUN nvim --headless +UpdateRemotePlugins +qall

USER root

RUN curl -sLf https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs
RUN apt-get install -y ripgrep fzf
RUN npm i -g prettier eslint typescript

USER spacevim
