# 🚀 My Personal Dotfiles

![Made with Love in Myanmar](https://img.shields.io/badge/Made%20with%20%E2%9D%A4%EF%B8%8F%20in-Myanmar-red)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Welcome to my personal collection of dotfiles! This repository contains my configurations for various development tools, all managed via symlinks for easy installation and maintenance.

## ✨ Features

- **Automated Installation**: A simple script to symlink all configurations and back up existing files.
- **Consistent Theming**: Catppuccin Mocha theme across Neovim, Ghostty, and tmux for a unified look.
- **Modal Editing**: Vim-style keybindings and modal editing in Neovim, tmux, and VS Code Insiders.
- **Extensive Keybindings**: Custom keybindings for efficient window management, pane navigation, and more.
- **Plugin-Managed**: Configurations managed with `lazy.nvim` for Neovim and TPM for tmux.
- **AI-Powered**: Integrated with GitHub Copilot in both Neovim and VS Code Insiders.

## 📂 Repository Structure

- **`link_dotfiles.sh`**: Script to symlink dotfiles to their target locations.
- **`lua-format.sh`**: Script to format all Lua files in the repository.
- **`nvim/`**: Neovim configuration with `lazy.nvim`, LSP, and custom plugins.
- **`hammerspoon/`**: Hammerspoon configuration for macOS window management.
- **`tmux/`**: Tmux configuration with TPM, Catppuccin theme, and custom keybindings.
- **`ghostty/`**: Ghostty terminal emulator configuration.
- **`vscode-insider/`**: VS Code Insiders settings and keybindings with tmux-style navigation.
- **`safari/`**: Custom stylesheet for Safari.
- **`gemini/`**: Gemini CLI settings.
- **`ssh/`**: SSH configuration (currently empty).

## 🛠️ Installation

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/AungMyoKyaw/dotfiles.git ~/dotfiles
    cd ~/dotfiles
    ```
2.  **Run the installation script:**
    ```sh
    ./link_dotfiles.sh
    ```
    This will back up your existing dotfiles to `~/dotfiles_backup_*` and create the necessary symlinks.

## ⚙️ Configuration Details

### Neovim

My Neovim setup is built around `lazy.nvim` for plugin management and LSP for intelligent code completion.

**Key Plugins:**

- **[catppuccin/nvim](https://github.com/catppuccin/nvim)**: For the Catppuccin Mocha theme.
- **[nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)**: For advanced syntax highlighting.
- **[VonHeikemen/lsp-zero.nvim](https://github.com/VonHeikemen/lsp-zero.nvim)**: For easy LSP configuration.
- **[github/copilot.vim](https://github.com/github/copilot.vim)**: For AI-powered code completion.
- **[lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)**: For Git integration in the sign column.
- **[kyazdani42/nvim-tree.lua](https://github.com/kyazdani42/nvim-tree.lua)**: For a file explorer.

**Keybindings:**

| Keybinding    | Action                    |
| ------------- | ------------------------- |
| `jj`          | Exit Insert mode          |
| `<leader> wl` | Move to the right window  |
| `<leader> wj` | Move to the window below  |
| `<leader> wk` | Move to the window above  |
| `<leader> wh` | Move to the left window   |
| `<leader> q`  | Quit the current buffer   |
| `<leader> w`  | Save the current buffer   |
| `<leader> bn` | Go to the next buffer     |
| `<leader> bp` | Go to the previous buffer |
| `<leader> bd` | Close the current buffer  |

### Tmux

My tmux setup is designed for efficient session management and navigation, with a Catppuccin theme and custom keybindings.

**Key Plugins:**

- **[tmux-plugins/tpm](https://github.com/tmux-plugins/tpm)**: Tmux Plugin Manager.
- **[catppuccin/tmux](https://github.com/catppuccin/tmux)**: Catppuccin Mocha theme.
- **[tmux-plugins/tmux-resurrect](https://github.com/catppuccin/tmux)**: Persist tmux sessions across reboots.
- **[tmux-plugins/tmux-continuum](https://github.com/catppuccin/tmux)**: Automatically save and restore tmux sessions.

**Keybindings:**

| Keybinding | Action                     |
| ---------- | -------------------------- |
| `C-a`      | Prefix key                 |
| `C-a C-a`  | Send `C-a` to the terminal |
| `C-a R`    | Reload the tmux config     |
| `C-a y`    | Copy to system clipboard   |

### VS Code Insiders

My VS Code Insiders setup is customized with tmux-style keybindings for pane navigation and a Catppuccin theme.

**Keybindings:**

| Keybinding       | Action                        |
| ---------------- | ----------------------------- |
| `ctrl+n`         | Toggle the file explorer      |
| `ctrl+a h/j/k/l` | Navigate between panes        |
| `ctrl+a \`       | Split the editor vertically   |
| `ctrl+a -`       | Split the editor horizontally |
| `ctrl+a p/n`     | Navigate between tabs         |
| `ctrl+a c`       | Create a new file             |
| `ctrl+a x`       | Close the active editor       |
| `ctrl+a g`       | Open Copilot Chat             |
| `ctrl+a i`       | Start an inline chat          |

### Hammerspoon

I use Hammerspoon for window management on macOS, with vim-style keybindings for snapping and resizing windows.

**Keybindings:**

| Keybinding | Action                         |
| ---------- | ------------------------------ |
| `Hyper+m`  | Enter Window Management mode   |
| `h/j/k/l`  | Snap window left/down/up/right |
| `f`        | Maximize the window            |
| `c`        | Center the window              |
| `-`        | Decrease window size           |
| `+`        | Increase window size           |
| `=`        | Reset window size              |
| `q`/`Esc`  | Exit Window Management mode    |

## 🤝 Contributing

Feel free to submit issues or pull requests. Customizations and suggestions are always welcome!

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

Developed with ❤️ by [Aung Myo Kyaw](https://github.com/AungMyoKyaw).
