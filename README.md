<p align="center">
  <a href="https://github.com/AungMyoKyaw/dotfiles">
    <img src="https://capsule-render-kappa.vercel.app/api?type=waving&color=2ecc71&height=180&text=My%20Personal%20Dotfiles&fontSize=45&fontColor=ffffff" alt="Modern banner"/>
  </a>
</p>
<p align="center">
  <a href="https://github.com/AungMyoKyaw/dotfiles">
    <img src="https://img.shields.io/github/last-commit/AungMyoKyaw/dotfiles?style=flat-square" alt="Last Commit">
    <img src="https://img.shields.io/github/contributors/AungMyoKyaw/dotfiles?style=flat-square" alt="Contributors">
    <img src="https://img.shields.io/github/stars/AungMyoKyaw/dotfiles?style=flat-square" alt="GitHub Stars">
    <img src="https://img.shields.io/github/stars/AungMyoKyaw/dotfiles?style=social" alt="Star this repo">
  </a>
</p>
<p align="center">
  <a href="https://opensource.org/licenses/AGPL-3.0"><img src="https://img.shields.io/badge/License-AGPL%20v3-blue?style=flat-square" alt="License"></a>
  <a href="https://opensource.org/licenses/AGPL-3.0"><img src="https://img.shields.io/badge/AGPL%20v3-2ecc71?style=flat-square" alt="AGPL v3"></a>
  <img src="https://img.shields.io/badge/Made%20with%20%E2%9D%A4%EF%B8%8F%20in-Myanmar-2ecc71?style=flat-square" alt="Made in Myanmar">
  <img src="https://img.shields.io/badge/macOS%20Optimized-2ecc71?style=flat-square" alt="macOS Optimized">
  <img src="https://img.shields.io/badge/Shell-zsh-blue?style=flat-square" alt="zsh">
  <img src="https://img.shields.io/badge/Primary%20Editor-Neovim-green?style=flat-square" alt="Neovim">
  <img src="https://img.shields.io/badge/Editor-VSCode%20Insiders-blueviolet?style=flat-square" alt="VSCode Insiders">
  <img src="https://img.shields.io/badge/Editor-Zed-00D084?style=flat-square" alt="Zed">
  <img src="https://img.shields.io/badge/Editor-OpenCode-FF6B35?style=flat-square" alt="OpenCode">
  <img src="https://img.shields.io/badge/Prompt-Starship-FF6B35?style=flat-square" alt="Starship">
  <img src="https://img.shields.io/badge/Terminal-Ghostty-orange?style=flat-square" alt="Ghostty">
  <img src="https://img.shields.io/badge/WindowManager-Hammerspoon-yellow?style=flat-square" alt="Hammerspoon">
  <img src="https://img.shields.io/badge/AI%20Agent-RovoDev-red?style=flat-square" alt="RovoDev">
  <img src="https://img.shields.io/badge/AI%20Agent-Claude%20Code%20CLI-FF6B35?style=flat-square" alt="Claude Code CLI">
  <img src="https://img.shields.io/badge/AI%20Agent-Gemini%20CLI-00bfae?style=flat-square" alt="Gemini CLI">
  <img src="https://img.shields.io/badge/AI%20Agent-Qwen%20Code%20CLI-4B0082?style=flat-square" alt="Qwen Code CLI">
  <img src="https://img.shields.io/badge/Primary%20AI%20Agent-VS%20Code%20GitHub%20Copilot-blueviolet?style=flat-square" alt="VS Code GitHub Copilot">
</p>

<p align="center">
  <b>Secure, maintainable, and highly customized dotfiles for macOS.<br>
  Fast setup, consistent dev environments, and productivity across devices.<br>
  All configs managed via symlinks for easy install and rollback.</b>
</p>

---

## Table of Contents

<details>
  <summary><strong>Table of Contents</strong> (click to expand)</summary>
  <ul>
    <li><a href="#quick-start">Quick Start</a></li>
    <li><a href="#features">Features</a></li>
    <li><a href="#prerequisites">Prerequisites</a></li>
    <li><a href="#repository-structure">Repository Structure</a></li>
    <li><a href="#installation">Installation</a></li>
    <li><a href="#configuration-details">Configuration Details</a>
      <ul>
        <li><a href="#rovodev-ai-assistant">RovoDev AI Assistant</a></li>
        <li><a href="#neovim">Neovim</a></li>
        <li><a href="#tmux">Tmux</a></li>
        <li><a href="#vs-code-insiders">VS Code Insiders</a></li>
        <li><a href="#zed">Zed</a></li>
        <li><a href="#starship">Starship</a></li>
        <li><a href="#ghostty">Ghostty</a></li>
        <li><a href="#claude-code-cli">Claude Code CLI</a></li>
        <li><a href="#hammerspoon">Hammerspoon</a></li>
      </ul>
    </li>
    <li><a href="#automation-scripts">Automation Scripts</a></li>
    <li><a href="#updating">Updating</a></li>
    <li><a href="#troubleshooting">Troubleshooting</a></li>
    <li><a href="#security--privacy-notes">Security & Privacy Notes</a></li>
    <li><a href="#faq">FAQ</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
  </ul>
</details>

---

## Quick Start

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

- See [Prerequisites](#prerequisites) below for required tools

4. **(Optional) Install MCP servers for AI tools:**

   ```sh
   ./install-mcp-servers.sh
   ```

5. **(Optional) Format configs:**
   ```sh
   ./lua-format.sh
   ```

---

## Features

### 🚀 Installation & Management

- **Automated Installation**: One script to symlink all configs and back up existing files with sudo support for system directories
- **MCP Server Integration**: Automated installation script for Model Context Protocol servers across all AI tools
- **Code Quality Tools**: Built-in EditorConfig and Prettier configurations for consistent code formatting
- **Comprehensive Gitignore**: Optimized for Node.js, macOS, and sensitive file protection

### 🤖 AI Development Ecosystem

- **Claude Code CLI**: Enhanced transparency protocols with 31+ custom slash commands for specialized workflows
- **RovoDev AI Assistant**: Advanced permissions and session management with persistent memory
- **Gemini CLI**: Comprehensive configuration with context management
- **Qwen Code CLI**: Alternative AI assistant with full MCP server integration
- **Universal MCP Support**: Sequential thinking, context management, web fetching, browser automation, and Chrome DevTools integration

### 📝 Multi-Editor Support

- **Neovim**: Lazy.nvim plugin management with LSP, Treesitter, and Catppuccin theme
- **VS Code Insiders**: Extensive configuration with AI chatmodes, custom prompts, and productivity extensions
- **Zed Editor**: Modern performance with Copilot integration and context server support
- **OpenCode**: Lightweight editor with AI integration capabilities
- **Consistent Vim Mode**: Modal editing across all editors with system clipboard support

### 🎨 Theming & Visual Consistency

- **Catppuccin Mocha**: Unified dark theme across Neovim, Ghostty, tmux, and terminal applications
- **Font Configuration**: SFMono Nerd Font with ligatures and consistent sizing
- **Visual Harmony**: Carefully crafted color schemes and visual consistency

### ⚡ Terminal & Shell Excellence

- **Advanced Zsh Setup**: Comprehensive configuration with sensitive information separation
- **Starship Prompt**: Minimal, fast prompt with git integration and custom symbols
- **Ghostty Terminal**: Modern emulator with performance optimizations and Catppuccin theming
- **Tmux**: Plugin-powered session management with TPM and persistent session support
- **SSH Management**: Secure configuration with proper file handling

### 🖥️ macOS Integration

- **Hammerspoon Window Management**: Vim-style window snapping, resizing, and auto-management
- **Safari Enhancements**: Custom CSS stylesheets and userscripts for improved browsing
- **System-wide Productivity**: Custom keybindings and automation across macOS

### 🔧 Development Workflow

- **Automated Extension Management**: Scripts for installing and managing editor extensions
- **Git Integration**: Advanced git status indicators and streamlined workflows
- **Code Formatting**: Integrated Prettier and lua-format support
- **Security First**: Proper handling of sensitive configurations and API keys

---

## Prerequisites

- macOS with [Homebrew](https://brew.sh/) for package management
- Zsh as default shell (with `.zshrc` and optional `.zshrc.local` for sensitive information)
- **Editors** (choose one or more):
  - Neovim: `brew install neovim`
  - VS Code Insiders: `brew install --cask visual-studio-code-insiders`
  - Zed: `brew install --cask zed`
- **Terminal & Shell**:
  - Tmux: `brew install tmux`
  - Ghostty: `brew install --cask ghostty`
  - Starship: `brew install starship`
- **AI Development Tools** (optional):
  - Claude Code CLI: `npm install -g @anthropic-ai/claude-code`
  - Gemini CLI: Install per official documentation
  - Qwen Code CLI: Install per official documentation
- **System Tools**:
  - Hammerspoon: `brew install --cask hammerspoon`
- **Development Tools**:
  - [lua-format](https://github.com/Koihik/LuaFormatter): `brew install luaformatter`
  - [Node.js](https://nodejs.org/) and npm: `brew install node`
  - Prettier: `npm install -g prettier`
  - uvx (for MCP fetch server): `pip install uvx`
- **Code Quality Tools**:
  - EditorConfig for consistent editor configuration (included)
  - Prettier configuration for code formatting (included)

---

## Repository Structure

### Core Scripts

- **link_dotfiles.sh**: Script to symlink dotfiles to their target locations with backup and sudo support
- **lua-format.sh**: Script to format all Lua files and supported files via Prettier
- **install-mcp-servers.sh**: Script to install MCP servers for Claude CLI and other AI tools

### Configuration Files (Included)

- **.editorconfig**: Consistent editor configuration across all tools
- **.prettierrc**: Prettier code formatting configuration
- **.prettierignore**: Files to exclude from Prettier formatting
- **.gitignore**: Comprehensive gitignore for Node.js, macOS, and sensitive files

### Editor & Tool Configurations

- **nvim/**: Neovim configuration directory (`.config/nvim`) with lazy.nvim and LSP setup
- **zed/**: Zed editor settings with AI features, Copilot, and context servers
- **vscode-insider/**: VS Code Insiders settings, keybindings, extensions, and AI chatmodes
- **opencode/**: OpenCode editor configuration with AI integrations

### AI Development Tools

- **claude/**: Claude Code CLI configuration with enhanced transparency protocols and MCP servers
  - **commands/**: 31+ custom slash commands for specialized workflows
  - **settings.json**: Main Claude CLI configuration with MCP servers
  - **CLAUDE.md**: Enhanced transparency protocols and operational directives
- **rovodev/**: RovoDev AI assistant configuration with MCP servers and permissions
- **gemini/**: Gemini CLI settings and configuration
- **qwen/**: Qwen Code CLI settings and configuration with MCP servers

### Terminal & Shell

- **zsh/**: Zsh configuration with separation of sensitive and non-sensitive information
- **starship/**: Starship prompt configuration with minimal design and git integration
- **tmux/**: Tmux configuration (`.tmux.conf`) with TPM and Catppuccin theme
- **ghostty/**: Ghostty terminal emulator configuration with Catppuccin theme and performance tweaks
- **ssh/**: SSH configuration directory for secure connections

### System & Browser

- **hammerspoon/**: Hammerspoon setup for macOS window management with custom keybindings
  - **Spoons/**: Hammerspoon extensions directory
- **safari/**: Custom CSS stylesheet and userscripts for Safari browser
  - **userscripts/**: Custom JavaScript userscripts for enhanced browsing

---

## Installation

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
    - Supports sudo operations for system-wide configurations
    - Handles sensitive files according to .gitignore rules

3.  **Install dependencies:**

    See [Prerequisites](#prerequisites) below for required tools

4.  **(Optional) Install MCP servers for enhanced AI development:**

    ```sh
    ./install-mcp-servers.sh
    ```

    - Installs sequential-thinking, context7, fetch, playwright, and chrome-devtools servers
    - Configures servers for Claude CLI, Gemini CLI, and Qwen CLI
    - Handles dependency checks for uvx and other requirements

5.  **(Optional) Format configuration files:**

    ```sh
    ./lua-format.sh
    ```

    - Formats all Lua files with 2-space indentation and 80-character line limit
    - Runs Prettier on supported files using included configuration

---

## Automation Scripts

- **`install-mcp-servers.sh`**: Automated MCP server installation for all AI tools

  ```sh
  ./install-mcp-servers.sh
  ```

  - Installs: sequential-thinking, context7, fetch, playwright, chrome-devtools
  - Handles dependency checking for uvx and other requirements
  - Supports both direct Claude CLI and npx installation methods
  - Provides clear feedback and error handling

- **`lua-format.sh`**: Code formatting automation

  ```sh
  ./lua-format.sh
  ```

  - Formats all Lua files with 2-space indentation and 80-character line limit
  - Runs Prettier on supported files using included configuration
  - Ensures consistent code style across the entire repository

- **VS Code Extension Scripts** (in `vscode-insider/`):
  - **`install-extensions.sh`**: Automatically install configured extensions
  - **`export-extensions.sh`**: Export current extensions to extensions.txt
  - **`restore.sh`**: Restore VS Code settings and configuration

---

## Updating

To update to the latest dotfiles:

```sh
cd ~/dotfiles
git pull --rebase
./link_dotfiles.sh
```

---

## Troubleshooting

- **Symlink Issues**: Ensure `link_dotfiles.sh` is executable (`chmod +x link_dotfiles.sh`) and run with proper permissions.
- **MCP Server Issues**: Run `./install-mcp-servers.sh` to reinstall MCP servers; check Claude CLI with `claude mcp list`.
- **Neovim**: After plugin changes, open Neovim and run `:Lazy sync` or `:PackerSync` depending on your setup.
- **Tmux**: Restart tmux server with `tmux kill-server` and reattach; install plugins with `<prefix> I`.
- **Zed**: Reload window (`Cmd+Shift+P` → Reload Window) after updating settings; check extensions panel for MCP server status.
- **Ghostty**: Restart Ghostty after configuration changes; check `ghostty --config-file` to verify config path.
- **Starship**: Restart your terminal or run `starship init` to reload configuration.
- **Claude CLI**: Restart with `claude restart` after configuration changes; check `~/.claude/settings.json`.
- **Hammerspoon**: Reload config via Hammerspoon menu or run `hs.reload()` in console.
- **VS Code Insiders**: Reload window (`Cmd+Shift+P` → Reload Window) after updating settings.
- **Formatting Errors**: Ensure `luaformatter` and `prettier` are installed; verify with `lua-format --version` and `prettier --version`.

## Troubleshooting: codecompanion deprecation warnings

If `:checkhealth` reports deprecation warnings referencing `vim.lsp.set_log_level()` or `vim.validate{}` originating from third-party plugins (for example, `codecompanion.nvim`), try the following:

- Update your plugins (lazy.nvim: `:Lazy update` or whichever plugin manager you use).
- If the warnings persist, open an issue on the offending plugin's repository and link the healthcheck stack trace from Neovim.
- As a temporary local fix, some deprecations can be mitigated by replacing deprecated calls with the newer API in your local plugin copies (not recommended long-term). Example replacement:

```lua
-- deprecated
vim.lsp.set_log_level("off")

-- preferred (Neovim >= 0.13)
vim.lsp.log.set_level("OFF")
```

- Check the plugin log for more details: `/Users/aungmyokyaw/.local/state/nvim/codecompanion.log`

If you're unsure, run `:checkhealth` and paste the output when creating an issue — it will help plugin authors diagnose and fix the deprecated API usage.

---

## Security & Privacy Notes

- **No secrets are stored in this repo.** Never commit API keys, tokens, or sensitive credentials.
- All scripts and configs are designed for local use. Review scripts before running if you fork or modify.
- SSH and other private configs are symlinked but not versioned—add your own as needed.
- Always use secure permissions for SSH keys and sensitive files (`chmod 600`).

---

## Configuration Details

### RovoDev AI Assistant

RovoDev is an AI-powered development assistant that enhances your coding workflow with intelligent tools and automation.

**Key Features:**

- **MCP Server Integration**: Sequential thinking, context management, web fetching, browser automation, and persistent memory
- **Smart Permissions**: Granular control over tool access with confirmation prompts for sensitive operations
- **Session Management**: Persistent sessions with auto-save capabilities
- **Streaming Responses**: Real-time AI interactions with optimized temperature settings

**Configuration Files:**

- `config.yml`: Main RovoDev settings including permissions, paths, and console output
- `mcp.json`: Model Context Protocol server configurations and allowed tools

**Security Features:**

- Atlassian write operations require confirmation
- Bash commands restricted to safe read-only operations
- External file access limited to workspace and temp directories
- Explicit allowlist for MCP servers

**Usage:**

```sh
rovodev restart  # Apply configuration changes
```

For detailed configuration options, see the [rovodev README](rovodev/README.md).

### Qwen Code CLI

Qwen Code CLI is an AI-powered development assistant that enhances your coding workflow with intelligent tools and automation, similar to the Gemini CLI but with Qwen models.

**Key Features:**

- **MCP Server Integration**: Sequential thinking, context management, web fetching, browser automation, and persistent memory
- **Smart Permissions**: Granular control over tool access with confirmation prompts for sensitive operations
- **Session Management**: Persistent sessions with auto-save capabilities
- **Streaming Responses**: Real-time AI interactions with optimized temperature settings

**Configuration Files:**

- `settings.json`: Main Qwen Code CLI settings including MCP server configurations (located in `qwen/` directory)

**MCP Servers:**

- **sequential-thinking**: For structured thinking and planning
- **context7**: For persistent memory and context management
- **fetch**: For web content retrieval
- **playwright**: For browser automation and web interaction

**Usage:**

```sh
qwen  # Start interactive session
qwen mcp list  # List configured MCP servers
```

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

> After symlinking, install tmux plugins by launching tmux and pressing `<prefix> I` (Capital i) to fetch plugins via TPM.

### VS Code Insiders

Comprehensive VS Code Insiders setup with extensive AI integration, custom keybindings, and productivity enhancements.

**Key Features:**

- **AI Integration**: GitHub Copilot, custom chatmodes, and prompt library
- **Tmux-style Navigation**: Intuitive pane navigation and window management
- **Custom Prompts Library**: 22+ specialized prompts for various development tasks
- **Extension Management**: Automated installation and configuration scripts
- **Chat Modes**: Multiple AI chat configurations for different workflows

**Configuration Files:**

- `settings.json`: Main VS Code configuration with AI integrations
- `keybindings.json`: Tmux-style keybindings for productivity
- `extensions.txt`: Curated list of essential extensions
- `mcp.json`: MCP server configuration for AI integration

**Directory Structure:**

- `chatmodes/`: AI chat mode configurations (Beast Mode, Thinking Architect, etc.)
- `prompts/`: 22+ specialized prompts (API design, code review, security audit, etc.)
- `instructions/`: Specialized AI instructions for complex workflows
- `install-extensions.sh`: Automated extension installation
- `export-extensions.sh`: Extension export utility

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

**AI Features:**

- **Custom Chatmodes**: Beast Mode, Thinking Architect, Cognitive Architect, and more
- **Prompt Library**: Specialized prompts for architecture, security, performance, testing
- **MCP Integration**: Context servers and AI tool integration
- **Enhanced Transparency**: Advanced AI interaction protocols

### Zed

Zed editor configuration with AI features, modern performance, and consistent theming.

**Key Features:**

- **AI Integration**: Copilot edit predictions and context server support
- **Vim Mode**: Comprehensive vim configuration with system clipboard support
- **Performance**: Optimized settings for smooth editing experience
- **Theme Support**: Gruvbox Dark theme with consistent font configuration
- **Context Servers**: MCP server integration for enhanced AI capabilities

**Configuration Files:**

- `settings.json`: Main editor settings including AI, theme, and performance configurations
- `keymap.json`: Custom keybindings for enhanced productivity

**Key Settings:**

- Font: SFMono Nerd Font with ligatures enabled
- AI features: Edit predictions via Copilot, context server integration
- Vim mode: Enabled with system clipboard and smartcase find
- Theme: Gruvbox Dark with comfortable line height
- Git: Inline blame disabled, git gutter on tracked files only

### Starship

Minimal, fast, and customizable prompt for any shell with git integration.

**Key Features:**

- **Minimal Design**: Clean prompt with only essential information
- **Git Integration**: Branch status and ahead/behind indicators
- **Performance**: Optimized for instant response
- **Customizable**: Easy to extend with additional modules

**Configuration:**

- Format: Directory and git branch on one line, character on next
- Git status: Visual indicators for modified, staged, and untracked files
- Disabled modules: Most language-specific modules disabled for minimal appearance
- Custom symbols: Custom emoji indicators for git states

**Prompt Structure:**

```
directory/branch 🌱 main
❯
```

### Ghostty

Modern, fast terminal emulator with advanced features and Catppuccin theming.

**Key Features:**

- **Performance**: VSync disabled, 10MB scrollback limit for smooth operation
- **Theme**: Catppuccin Mocha with consistent design
- **Font**: SFMono Nerd Font with custom features
- **Window Management**: Auto-maximize, focus follows mouse
- **UX Enhancements**: Cursor blinking, mouse hiding while typing

**Configuration Highlights:**

- Theme: Catppuccin Mocha
- Font: SFMonoNerdFont, size 16, with custom font features
- Performance: Window vsync disabled, resize overlay never shown
- Window: Native titlebar, auto-maximize, 4px padding
- Mouse: Focus follows mouse, hide while typing

### Claude Code CLI

Claude Code CLI configuration with enhanced transparency protocols and comprehensive MCP server integration.

**Key Features:**

- **MCP Server Integration**: Sequential thinking, context management, web fetching, browser automation, Chrome DevTools
- **Enhanced Protocols**: Transparency mandates and cognitive overclocking for advanced problem-solving
- **31+ Custom Commands**: Comprehensive slash commands for all development workflows
- **Multi-Agent Support**: Specialized agents for different tasks and domains

**Configuration Files:**

- `settings.json`: Main Claude CLI configuration with MCP servers
- `CLAUDE.md`: Enhanced transparency protocols and operational directives
- `commands/`: 31+ custom slash commands for specialized workflows

**Custom Commands Include:**

- **Development**: `/analyze`, `/debug`, `/docs`, `/format`, `/linting`, `/refactor`, `/test`, `/review`
- **Architecture**: `/architecture`, `/api-design`, `/schema`, `/requirements`
- **Workflow**: `/commit`, `/branch-diff`, `/complete-workflow`, `/az-pr`
- **Advanced**: `/engineer`, `/optimize`, `/performance`, `/security-audit`, `/deploy`, `/migrate`
- **Setup**: `/setup`, `/gitignore`, `/editorconfig`

**MCP Servers:**

- **sequential-thinking**: Structured thinking and planning
- **context7**: Authoritative documentation and knowledge retrieval
- **fetch**: Web content retrieval with user agent customization
- **playwright**: Browser automation and web interaction
- **chrome-devtools**: Chrome DevTools integration

**Usage:**

```sh
claude                    # Start interactive session
claude mcp list          # List configured MCP servers
./install-mcp-servers.sh # Install all MCP servers automatically
/help                    # List all available custom commands
```

### Hammerspoon

Comprehensive macOS window management and automation system with extensive configuration modules.

**Key Features:**

- **Window Management**: Vim-style window snapping, resizing, and positioning
- **Automation**: Advanced app management and workflow automation
- **Performance Monitoring**: System resource tracking and optimization
- **Text Replacement**: Intelligent text expansion and replacement system
- **Auto-quit**: Automatic application cleanup and resource management

**Configuration Modules:**

- `init.lua`: Main configuration initialization
- `window_management.lua`: Vim-style window controls and positioning
- `automation.lua`: Application management and workflow automation
- `performance.lua`: System monitoring and optimization
- `text_replacement.lua`: Intelligent text expansion system
- `apps.lua`: Application-specific configurations
- `autoquit.lua`: Automatic application cleanup
- `cleanup.lua`: System maintenance and cleanup routines
- `sensitive_replacements.lua`: Secure text replacements (gitignored)

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

**Advanced Features:**

- **App-specific Layouts**: Different window layouts for different applications
- **Performance Monitoring**: CPU, memory, and battery optimization
- **Text Expansion**: Smart text replacement with sensitive data handling
- **Auto-cleanup**: Automatic resource management and app cleanup
- **Spoons Integration**: Hammerspoon extensions for additional functionality

---

## FAQ

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

## Contributing

Feel free to submit issues or pull requests! Customizations and suggestions are always welcome.

**How to Contribute:**

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

**Guidelines:**

- Test your changes thoroughly
- Update documentation as needed
- Follow existing code style and conventions
- Ensure compatibility with macOS

---

## License

This project is licensed under the GNU Affero General Public License v3.0. See the [LICENSE](LICENSE) file for details.

---

<p align="center">
  <a href=".">
    <img src="https://capsule-render-kappa.vercel.app/api?type=waving&color=2ecc71&height=180&section=footer&text=Developed%20with%20%E2%9D%A4%EF%B8%8F%20by%20Aung%20Myo%20Kyaw.&fontSize=14&fontAlignX=50&fontAlignY=80&fontColor=ffffff" alt="footer-banner"/>
  </a>
</p>
