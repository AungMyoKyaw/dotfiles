<p align="center">
  <img src="https://capsule-render.vercel.app/api?type=waving&color=2ecc71&height=180&section=header&text=My%20Personal%20Dotfiles&fontSize=40&fontAlign=50&fontColor=ffffff" alt="banner"/>
</p>

<p align="center">
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-2ecc71?style=flat-square" alt="License"></a>
  <img src="https://img.shields.io/badge/Made%20with%20%E2%9D%A4%EF%B8%8F%20in-Myanmar-2ecc71?style=flat-square" alt="Made in Myanmar">
  <img src="https://img.shields.io/badge/macOS%20Optimized-2ecc71?style=flat-square" alt="macOS Optimized">
</p>

<p align="center">
  <b>Secure, maintainable, and highly customized dotfiles for macOS.<br>
  Fast setup, consistent dev environments, and productivity across devices.<br>
  All configs managed via symlinks for easy install and rollback.</b>
</p>

---

## 📑 Table of Contents

- [🚀 Quick Start](#-quick-start)
- [✨ Features](#-features)
- [⚡ Prerequisites](#-prerequisites)
- [📂 Repository Structure](#-repository-structure)
- [🛠️ Installation (Advanced)](#️-installation-advanced)
- [🧰 Formatting Scripts](#-formatting-scripts)
- [🔄 Updating](#-updating)
- [🐞 Troubleshooting](#-troubleshooting)
- [🔒 Security & Privacy Notes](#-security--privacy-notes)
- [⚙️ Configuration Details](#️-configuration-details)
  - [Neovim](#neovim)
  - [Tmux](#tmux)
  - [VS Code Insiders](#vs-code-insiders)
  - [Hammerspoon](#hammerspoon)
  - [Ghostty](#ghostty)
  - [Safari](#safari)
  - [Gemini](#gemini)
  - [SSH](#ssh)
- [❓ FAQ](#-faq)
- [🤝 Contributing](#-contributing)
- [📜 License](#-license)
- [👨‍💻 Author](#-author)

---

## 🚀 Quick Start

1. **Clone and enter the repo:**
   ```sh
   git clone https://github.com/AungMyoKyaw/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```
2. **Run the installer:**
   ```sh
   ./link_dotfiles.sh
   ```

   - Existing dotfiles are backed up to `~/dotfiles_backup_<timestamp>`
   - Symlinks are created for all managed configs
3. **Install dependencies:**
   - See [⚡ Prerequisites](#-prerequisites) below for required tools
4. **(Optional) Format configs:**
   ```sh
   ./lua-format.sh
   ```

---

## ✨ Features

- **Automated Installation**: One script to symlink all configs and back up existing files
- **Consistent Theming**: Catppuccin Mocha theme across Neovim, Ghostty, and tmux
- **Modal Editing**: Vim-style keybindings in Neovim, tmux, and VS Code Insiders
- **Extensive Keybindings**: Custom shortcuts for window management, navigation, and more
- **Plugin-Managed**: `lazy.nvim` for Neovim, TPM for tmux
- **AI-Powered**: GitHub Copilot in Neovim and VS Code Insiders
- **AI-Powered**: Integrated with GitHub Copilot in both Neovim and VS Code Insiders.

---

## ⚡ Prerequisites

- macOS with [Homebrew](https://brew.sh/) for package management
- Zsh as default shell (with optional `.zshenv` / `.zshenv.local`)
- Neovim: `brew install neovim`
- Tmux: `brew install tmux`
- Hammerspoon: `brew install --cask hammerspoon`
- [lua-format](https://github.com/Koihik/LuaFormatter): `brew install luaformatter`
- [Node.js](https://nodejs.org/) and npm for formatting scripts: `brew install node`
- Prettier: `npm install -g prettier`

---

## 📂 Repository Structure

- **link_dotfiles.sh**: Script to symlink dotfiles to their target locations.
- **lua-format.sh**: Script to format all Lua files and supported files via Prettier.
- **nvim/**: Neovim configuration directory (`.config/nvim`).
- **hammerspoon/**: Hammerspoon setup for macOS window management.
- **tmux/**: Tmux configuration (`.tmux.conf`) with TPM and Catppuccin theme.
- **ghostty/**: Ghostty terminal emulator configuration file.
- **vscode-insider/**: VS Code Insiders user settings, keybindings, and chatmodes.
- **safari/**: Custom CSS stylesheet for Safari.
- **gemini/**: Gemini CLI settings (`settings.json`).
- **ssh/**: SSH configuration directory.

---

## 🛠️ Installation (Advanced)

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/AungMyoKyaw/dotfiles.git ~/dotfiles
    cd ~/dotfiles
    ```
2.  **Run the installation script:**

    ```sh
    ./link_dotfiles.sh
    ```

    - Backs up existing dotfiles to `~/dotfiles_backup_<timestamp>`
    - Creates symlinks for all configured dotfiles and directories

---

## 🧰 Formatting Scripts

- **`lua-format.sh`**: Formats all Lua files (indent width 2, 80-col limit) and runs Prettier on supported files.
  ```sh
  ./lua-format.sh
  ```

---

## 🔄 Updating

To update to the latest dotfiles:

```sh
cd ~/dotfiles
git pull --rebase
./link_dotfiles.sh
```

---

## 🐞 Troubleshooting

- **Symlink Issues**: Ensure `link_dotfiles.sh` is executable (`chmod +x link_dotfiles.sh`) and run with proper permissions.
- **Neovim**: After plugin changes, open Neovim and run `:Lazy sync` or `:PackerSync` depending on your setup.
- **Tmux**: Restart tmux server with `tmux kill-server` and reattach; install plugins with `<prefix> I`.
- **Hammerspoon**: Reload config via Hammerspoon menu or run `hs.reload()` in console.
- **VS Code Insiders**: Reload window (`Cmd+Shift+P` → Reload Window) after updating settings.
- **Formatting Errors**: Ensure `luaformatter` and `prettier` are installed; verify with `lua-format --version` and `prettier --version`.

---

## 🔒 Security & Privacy Notes

- **No secrets are stored in this repo.** Never commit API keys, tokens, or sensitive credentials.
- All scripts and configs are designed for local use. Review scripts before running if you fork or modify.
- SSH and other private configs are symlinked but not versioned—add your own as needed.
- Always use secure permissions for SSH keys and sensitive files (`chmod 600`).

---

---

## ⚙️ Configuration Details

### 📝 Neovim

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

### 🪟 Tmux

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

> After symlinking, install tmux plugins by launching tmux and pressing `<prefix> I` (Capital i) to fetch plugins via TPM.

### 🖥️ VS Code Insiders

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

### 🍎 Hammerspoon

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

---

## ❓ FAQ

**Q: Can I use these dotfiles on Linux or Windows?**
A: They are optimized for macOS. Some configs may work on Linux, but paths and dependencies may differ. Windows is not supported.

**Q: How do I add my own custom configs?**
A: Place your overrides in the appropriate folder, or use `.local` files (e.g., `.zshenv.local`). These are ignored by git and not overwritten.

**Q: How do I safely update my dotfiles?**
A: Pull the latest changes and re-run `./link_dotfiles.sh`. Your previous configs are backed up automatically.

**Q: What if something breaks after updating?**
A: Restore from the backup in `~/dotfiles_backup_<timestamp>`, or review the troubleshooting section above.

**Q: How do I keep my secrets safe?**
A: Never store secrets in this repo. Use environment variables or `.local` files for sensitive data.

---

Feel free to submit issues or pull requests. Customizations and suggestions are always welcome!

---

## 🤝 Contributing

Contributions, suggestions, and issues are welcome! Please open a pull request or issue on GitHub.

---

---

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

<p align="center">
  <img src="https://capsule-render.vercel.app/api?type=waving&color=2ecc71&height=120&section=footer" alt="footer-banner"/>
</p>

Developed with ❤️ by [Aung Myo Kyaw](https://github.com/AungMyoKyaw).
