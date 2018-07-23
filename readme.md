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

_CMAKE is also needed to be installed `brew install cmake`_

```shell
vim +PluginInstall +qall
```

### Need a few more step to activate some plugins

#### YouCompleteMe

```shell
cd ~/.vim/bundle/YouCompleteMe
./install.py --all
```

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
| 3   | [ack](http://github.com/mileszs/ack.vim)                            |
| 4   | [auto-pairs ](http://github.com/jiangmiao/auto-pairs)               |
| 5   | [ctrlp-funky](http://github.com/tacahiroy/ctrlp-funky)              |
| 6   | [ctrlp](http://github.com/ctrlpvim/ctrlp.vim)                       |
| 7   | [ctrlsf](http://github.com/dyng/ctrlsf.vim)                         |
| 8   | [editorconfig-vim](http://github.com/editorconfig/editorconfig-vim) |
| 9   | [emmet-vim](http://github.com/mattn/emmet-vim)                      |
| 10  | [nerdtree](http://github.com/scrooloose/nerdtree)                   |
| 11  | [onedark](https://github.com/joshdick/onedark.vim)                  |
| 12  | [ultisnips](http://github.com/SirVer/ultisnips)                     |
| 13  | [vim-airline](http://github.com/vim-airline/vim-airline)            |
| 14  | [vim-colortuner](http://github.com/zefei/vim-colortuner)            |
| 15  | [vim-commentary](http://github.com/tpope/vim-commentary)            |
| 16  | [vim-devicons](http://github.com/ryanoasis/vim-devicons)            |
| 17  | [vim-easy-align](http://github.com/junegunn/vim-easy-align)         |
| 18  | [vim-fold-cycle](http://github.com/arecarn/vim-fold-cycle)          |
| 19  | [vim-fugitive](http://github.com/tpope/vim-fugitive)                |
| 20  | [vim-gitgutter](http://github.com/airblade/vim-gitgutter)           |
| 21  | [vim-javascript](http://github.com/pangloss/vim-javascript)         |
| 22  | [vim-jsdoc](http://github.com/heavenshell/vim-jsdoc)                |
| 23  | [vim-jsx](http://github.com/mxw/vim-jsx)                            |
| 24  | [vim-polyglot](https://github.com/sheerun/vim-polyglot)             |
| 25  | [vim-snippets](http://github.com/honza/vim-snippets)                |
| 26  | [vim-surround](http://github.com/tpope/vim-surround)                |
| 27  | [vim-tmux](http://github.com/tmux-plugins/vim-tmux)                 |
| 28  | [vim-wakatime](http://github.com/wakatime/vim-wakatime)             |
| 29  | [youcompleteme](http://github.com/valloric/youcompleteme)           |

</details>

## Acknowledgments

Vimrc used in this project use a lot of config from [minimal-vimrc](https://github.com/mhinz/vim-galore/blob/master/static/minimal-vimrc.vim).

## License

[MIT](./LICENSE)
