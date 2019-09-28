# [.]files

> My vim and tmux config

[![dotfiles][dotfiles]][dotfiles-url]
[![License: MIT][license]][license-url]
[![Docker Cloud Build Status][docker-build-status]][docker-build-url]

```shell
    _   __  __ _  __  ___      _    __ _ _
   /_\ |  \/  | |/ / |   \ ___| |_ / _(_) |___ ___
  / _ \| |\/| | ' <  | |) / _ \  _|  _| | / -_|_-<
 /_/ \_\_|  |_|_|\_\ |___/\___/\__|_| |_|_\___/__/
```

<img src="./assets/screenshot.png" alt="dotfiles" align="right" width="400">

---

- [PREREQUISITES](#PREREQUISITES)
  - [Install TMUX](#install-tmux)
  - [Install TMUX Plugin Manager](#install-tmux-plugin-manager)
  - [Install spacevim](#install-spacevim)
- [INSTALLATION](#INSTALLATION)
  - [Install Config](#install-config)
  - [Install TMUX Plugins](#install-tmux-plugins)
- [LICENSE](#LICENSE)

---

## PREREQUISITES

### Install [TMUX](https://tmux.github.io/)

```shell
brew install tmux
```

### Install [TMUX Plugin Manager](https://github.com/tmux-plugins/tpm)

```shell
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### Install [spacevim](https://spacevim.org/)

#### Linux and macOS

```shell
curl -sLf https://spacevim.org/install.sh | bash
```

---

_[iterm2](https://www.iterm2.com/), [Z shell](https://github.com/robbyrussell/oh-my-zsh/wiki/Installing-ZSH) and [antibody](https://github.com/getantibody/antibody) should also need to be installed._

---

## INSTALLATION

### Install Config

```shell
git clone git@github.com:AungMyoKyaw/dotfiles.git
cd dotfiles
sh ./install.sh
```

### Install [TMUX](https://tmux.github.io/) Plugins

Use <kbd>ctrl</kbd>+<kbd>a</kbd>+<kbd>I</kbd> to install [TMUX](https://tmux.github.io/) Plugins

_<kbd>ctrl+a</kbd> is `prefix`._

### Install [ZSH](https://www.zsh.org/) Plugins

#### reload zshrc

```shell
source ~/.zshrc
```

#### updateplugin

```shell
updateplugin
```

## Dockerized Vim [docker hub]

```shell
docker run -it --rm \
  -v $(pwd):/home/spacevim/src:cached \
  -v ~/dockerized-nvim/.cache:/home/spacevim/.cache:cached \
  -v ~/dockerized-nvim/.local:/home/spacevim/.local:cached \
  aungmyokyaw/dnvim
```

## Dockerized Vim [local]

### Build Dockerfile

```shell
docker build -t dnvim .
```

### Develop with dnvim

##### set alias

```shell
alias dnvim='docker run -it --rm \
  -v $(pwd):/home/spacevim/src:cached \
  -v ~/dockerized-nvim/.cache:/home/spacevim/.cache:cached \
  -v ~/dockerized-nvim/.local:/home/spacevim/.local:cached \
  dnvim'
```

##### and run

```shell
dnvim
```

##### or run manually

```shell
docker run -it --rm \
  -v $(pwd):/home/spacevim/src:cached \
  -v ~/dockerized-nvim/.cache:/home/spacevim/.cache:cached \
  -v ~/dockerized-nvim/.local:/home/spacevim/.local:cached \
  dnvim
```

## LICENSE

MIT © [Aung Myo Kyaw](https://github.com/AungMyoKyaw)

[screenshot]: ./assets/screenshot.png
[license]: https://img.shields.io/badge/License-MIT-brightgreen.svg?style=flat-square
[license-url]: https://opensource.org/licenses/MIT
[dotfiles]: https://img.shields.io/badge/Dotfiles-AMK-brightgreen.svg?style=flat-square
[dotfiles-url]: #
[asciicast-screenshot]: https://asciinema.org/a/LrBeUcO83YmxixOFCTBi8sQIT.svg
[asciicast-screenshot-url]: https://asciinema.org/a/LrBeUcO83YmxixOFCTBi8sQIT
[docker-build-status]: https://img.shields.io/docker/cloud/build/aungmyokyaw/dnvim?style=flat-square
[docker-build-url]: https://hub.docker.com/r/aungmyokyaw/dnvim
