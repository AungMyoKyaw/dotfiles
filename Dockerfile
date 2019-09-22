FROM spacevim/spacevim
COPY ./spacevim.d $HOME/.SpaceVim.d

USER root

RUN pip3 install pynvim

RUN curl -sLf https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs
RUN npm i -g prettier eslint typescript neovim

RUN apt-get install -y ripgrep fzf
ENV FZF_DEFAULT_COMMAND='rg --files'

RUN apt-get install -y wamerican

RUN apt-get clean

RUN nvim --headless +UpdateRemotePlugins +qall

WORKDIR $HOME/src
