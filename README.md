# 🚀 Dotfiles

This repository contains my personal configuration files (dotfiles) for various development tools and environments. These files are managed via symlinks and can be installed using the provided scripts.

## 📂 Repository Structure

This repository contains all my personal dotfiles.

- **link_dotfiles.sh**: Script to symlink dotfiles to their target locations in your home directory, with automatic backup of existing files.
- **lua-format.sh**: Script to format all Lua files in the repository using `lua-format`.
- **nvim/**: Neovim configuration (`~/.config/nvim`) with `lazy.nvim` plugin manager and custom settings.
- **hammerspoon/**: Hammerspoon configuration (`~/.hammerspoon`) for window management and automation.
- **tmux/**: Tmux configuration (`~/.tmux.conf`) for terminal multiplexing.
- **gemini/**: Gemini protocol client settings (`~/.gemini/settings.json`).
- **ssh/**: SSH configuration files (`~/.ssh/`). (Currently empty, but reserved for future SSH configurations.)
- **vscode-insider/**: Visual Studio Code Insiders settings and keybindings, including custom tmux-style keybindings and extensive Copilot integration.

## 🛠️ Installation

1. Clone this repository:
   ```sh
   git clone https://github.com/AungMyoKyaw/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```
2. Run the symlink script:

   ```sh
   ./link_dotfiles.sh
   ```

   This will backup existing configuration files to `~/dotfiles_backup_*` and create symlinks.

3. (Optional) Format all Lua files:
   ```sh
   ./lua-format.sh
   ```

## 📝 Usage

- Neovim: Launch `nvim`. Plugins and LSP servers will be managed automatically via `lazy.nvim` and `mason.nvim`.
- Hammerspoon: Ensure Hammerspoon is installed and reload configuration via Hammerspoon menu.
- Gemini: Use your Gemini client; configuration is stored at `~/.gemini/settings.json`.
- Tmux: Start a new session with `tmux`.
- VS Code Insiders: Launch VS Code Insiders; settings and keybindings are loaded from the symlinked files.

## 🤝 Contributing

Feel free to submit issues or pull requests. Customizations are welcome!

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

Developed with ❤️ by [Aung Myo Kyaw](https://github.com/AungMyoKyaw).
