# [.]files

> My vim and tmux config

<img src="./assets/vim.gif" alt="dotfiles" align="right" width="400">

- [Prerequisites](#prerequisites)
  - [Install TMUX](#install-tmux)
  - [Install TMUX Plugin Manager](#install-tmux-plugin-manager)
  - [Install Vundle](#install-vundle)
  - [Install Terminal Font](#install-terminal-font)
  - [Install neovim](#install-neovim)
- [Installation](#installation)
  - [Install Config](#install-config)
  - [Install TMUX Plugins](#install-tmux-plugins)
  - [Install Vim Plugins](#install-vim-plugins)
- [Plugins](#plugins)
- [Acknowledgments](#acknowledgments)
- [License](#license)

---

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

### Install [neovim](https://neovim.io/)

```shell
brew install neovim
```

---

_I recommend to use [iterm2](https://www.iterm2.com/) with [oceanicmaterial color scheme](http://iterm2colorschemes.com/)._

_[Z shell](https://github.com/robbyrussell/oh-my-zsh/wiki/Installing-ZSH) and [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) should also be installed._

---

## Installation

### Install Config

```shell
git clone git@github.com:AungMyoKyaw/dotfiles.git
cd dotfiles
sh ./install.sh
```

### Install [TMUX](https://tmux.github.io/) Plugins

Use <kbd>ctrl</kbd>+<kbd>a</kbd>+<kbd>I</kbd> to install [TMUX](https://tmux.github.io/) Plugins

_<kbd>ctrl+a</kbd> is `prefix`._

### Install [Vim](http://www.vim.org/) Plugins

```shell
vim +PluginInstall +qall
```

### Need a few more step to activate some plugins

#### ctrlsf

```shell
brew install ack
```

## Plugins

<details>
<summary>Plugins</summary>

| NO  | NAME                                                                |
| --- | ------------------------------------------------------------------- |
| 1   | [BufOnly](http://github.com/vim-scripts/BufOnly.vim)                |
| 2   | [Vundle](http://github.com/VundleVim/Vundle.vim)                    |
| 3   | [auto-pairs ](http://github.com/jiangmiao/auto-pairs)               |
| 4   | [ctrlp](http://github.com/ctrlpvim/ctrlp.vim)                       |
| 5   | [ctrlsf](http://github.com/dyng/ctrlsf.vim)                         |
| 6   | [editorconfig-vim](http://github.com/editorconfig/editorconfig-vim) |
| 7   | [emmet-vim](http://github.com/mattn/emmet-vim)                      |
| 8   | [nerdtree](http://github.com/scrooloose/nerdtree)                   |
| 9   | [onedark](https://github.com/joshdick/onedark.vim)                  |
| 10  | [vim-airline](http://github.com/vim-airline/vim-airline)            |
| 11  | [vim-colortuner](http://github.com/zefei/vim-colortuner)            |
| 12  | [vim-commentary](http://github.com/tpope/vim-commentary)            |
| 13  | [vim-devicons](http://github.com/ryanoasis/vim-devicons)            |
| 14  | [vim-easy-align](http://github.com/junegunn/vim-easy-align)         |
| 15  | [vim-fold-cycle](http://github.com/arecarn/vim-fold-cycle)          |
| 16  | [vim-fugitive](http://github.com/tpope/vim-fugitive)                |
| 17  | [vim-gitgutter](http://github.com/airblade/vim-gitgutter)           |
| 18  | [vim-jsdoc](http://github.com/heavenshell/vim-jsdoc)                |
| 19  | [vim-surround](http://github.com/tpope/vim-surround)                |
| 20  | [vim-tmux](http://github.com/tmux-plugins/vim-tmux)                 |
| 21  | [vim-wakatime](http://github.com/wakatime/vim-wakatime)             |
| 22  | [youcompleteme](http://github.com/valloric/youcompleteme)           |

</details>

## Acknowledgments

Vimrc used in this project use a lot of config from [minimal-vimrc](https://github.com/mhinz/vim-galore/blob/master/static/minimal-vimrc.vim).

## License

[MIT](./LICENSE)
