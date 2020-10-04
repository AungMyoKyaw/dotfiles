FROM alpine:latest
COPY ./vim /root/.vim

RUN apk add vim
RUN apk add git
RUN git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

WORKDIR $HOME/src
