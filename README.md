# Dotfiles

<p align="center">
  <img src="https://img.shields.io/github/stars/AungMyoKyaw/dotfiles?style=flat-square" alt="GitHub Stars">
  <img src="https://img.shields.io/github/last-commit/AungMyoKyaw/dotfiles?style=flat-square" alt="Last Commit">
  <img src="https://img.shields.io/badge/License-AGPL%20v3-blue?style=flat-square" alt="License">
  <img src="https://img.shields.io/badge/macOS%20Optimized-2ecc71?style=flat-square" alt="macOS Optimized">
  <img src="https://img.shields.io/badge/AI%20Agent-Claude%20Code%20CLI-FF6B35?style=flat-square" alt="Claude Code CLI">
  <img src="https://img.shields.io/badge/Primary%20Editor-Neovim-green?style=flat-square" alt="Neovim">
  <img src="https://img.shields.io/badge/Shell-zsh-blue?style=flat-square" alt="zsh">
</p>

Personal macOS dotfiles managed via symlinks. Secure, maintainable configurations for consistent development environments.

---

## 🚀 Quick Start

```bash
git clone https://github.com/AungMyoKyaw/dotfiles.git ~/dotfiles
cd ~/dotfiles
./link_dotfiles.sh
```

## What's Included

### 🤖 AI Development Tools

- **Claude Code CLI**: 31+ custom slash commands, MCP servers, enhanced transparency
- **RovoDev**: Advanced AI assistant with session management
- **Gemini CLI**: Configuration with context management
- **Qwen Code CLI**: AI assistant with MCP integration

### 📝 Editors

- **Neovim**: Lazy.nvim, LSP, Treesitter, Catppuccin theme
- **VS Code Insiders**: AI integration, tmux navigation, custom prompts
- **Zed**: Modern editor with Copilot, vim mode, performance tweaks
- **OpenCode**: Lightweight editor with AI features

### 🖥️ Terminal & Shell

- **Zsh**: Clean configuration with sensitive data separation
- **Starship**: Minimal prompt with git integration
- **Ghostty**: Modern terminal with Catppuccin theme
- **Tmux**: Session management with TPM plugins

### 🪟 macOS Integration

- **Hammerspoon**: Window management, automation, performance monitoring
- **Safari**: Custom CSS and userscripts

## 💿 Installation

1. **🔄 Clone and install:**

   ```bash
   git clone https://github.com/AungMyoKyaw/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ./link_dotfiles.sh
   ```

2. **🤖 Install MCP servers** (optional, for AI tools):

   ```bash
   ./install-mcp-servers.sh
   ```

3. **📦 Install dependencies** (see tools below)

## ⚡ Scripts

- `link_dotfiles.sh`: Symlink configs with backup and sudo support
- `install-mcp-servers.sh`: Install MCP servers for AI tools
- `lua-format.sh`: Format Lua files and code via Prettier
- `performance-boost.sh`: macOS performance optimization

## 📦 Dependencies

### Required

- macOS with Homebrew
- Zsh (default shell)

### Editors (choose)

- Neovim: `brew install neovim`
- VS Code Insiders: `brew install --cask visual-studio-code-insiders`
- Zed: `brew install --cask zed`

### Terminal

- Tmux: `brew install tmux`
- Ghostty: `brew install --cask ghostty`
- Starship: `brew install starship`

### AI Tools (optional)

- Claude Code CLI: `npm install -g @anthropic-ai/claude-code`
- Hammerspoon: `brew install --cask hammerspoon`

### Development

- Node.js, lua-format, Prettier, uvx (for MCP fetch server)

## ⚙️ Configuration

- **Claude CLI**: `~/.claude/` - Custom commands, MCP servers, transparency protocols
- **Neovim**: `~/.config/nvim/` - Lazy.nvim, LSP, custom keybindings
- **VS Code**: Tmux-style navigation, AI chatmodes, extension management
- **Hammerspoon**: Window management, automation, performance monitoring
- **Zsh**: Sensitive data in `.zshrc.local` (gitignored)

## 🔒 Security

- No secrets stored in this repository
- Sensitive configs use `.local` files (gitignored)
- Review scripts before running

## 📄 License

AGPL-3.0 - see [LICENSE](LICENSE) file

---

<div align="center">

Made with ❤️ by [Aung Myo Kyaw](https://github.com/AungMyoKyaw)

</div>
