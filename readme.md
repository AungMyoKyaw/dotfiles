# [.]files
> My vim and tmux config

<img src="./assets/dotfiles.gif" alt="dotfiles" align="right" width="400">

- [Prerequisites](#prerequisites)
  - [Install TMUX](#install-tmux)
  - [Install TMUX Plugin Manager](#install-tmux-plugin-manager)
  - [Install Vundle](#install-vundle)
  - [Install Terminal Font](#install-terminal-font)
- [Installation](#installation)
  - [Install Config](#install-config)
  - [Install TMUX Plugins](#install-tmux-plugins)
  - [Install Vim Plugins](#install-vim-plugins)
- [Acknowledgments](#acknowledgments)
- [License](#license)

---------------------------------------------------------------------------------------------------

## Prerequisites
### Install [TMUX](https://tmux.github.io/)
```shell
brew install tmux
```

### Install [TMUX Plugin Manager](https://github.com/tmux-plugins/tpm)
```shell
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux source ~/.tmux.conf
```

### Install [Vundle](https://github.com/VundleVim/Vundle.vim) 
```shell
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

### Install Terminal Font
#### Install Knack [Nerd Font](https://github.com/ryanoasis/nerd-fonts)
```shell
brew tap caskroom/fonts
brew cask install font-sourcecodepro-nerd-font
```
Set Terminal Font to `Sauce Code Pro Nerd Font`.

----------------------------------------------------------------------------------------------------

*I recommend to use [iterm2](https://www.iterm2.com/) with [oceanicmaterial color scheme](http://iterm2colorschemes.com/).*

*[Z shell](https://github.com/robbyrussell/oh-my-zsh/wiki/Installing-ZSH) and [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) should also be installed.*

----------------------------------------------------------------------------------------------------


## Installation
### Install Config
```shell
git clone git@github.com:AungMyoKyaw/dotfiles.git
cd dotfiles
sh ./install.sh
```

### Install [TMUX](https://tmux.github.io/) Plugins
Use <kbd>ctrl</kbd>+<kbd>a</kbd>+<kbd>I</kbd> to install [TMUX](https://tmux.github.io/) Plugins

*<kbd>ctrl+a</kbd> is `prefix`.*

### Install [Vim](http://www.vim.org/) Plugins
*CMAKE is also needed to be installed `brew install cmake`*
```shell
vim +PluginInstall +qall
```

----------------------------------------------------------------------------------------------------

You need one more step to install *[YouCompleteMe](https://github.com/valloric/youcompleteme)* plugin.

```shell
cd ~/.vim/bundle/YouCompleteMe
./install.py --all
```

----------------------------------------------------------------------------------------------------

## Acknowledgments
Vimrc used in this project is just a fork of [minimal-vimrc](https://github.com/mhinz/vim-galore/blob/master/static/minimal-vimrc.vim).
My work is just adding some plugins and configs.

## License
[MIT](./LICENSE)

