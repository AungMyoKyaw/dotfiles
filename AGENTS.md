# AGENTS.md

AI-focused instructions for working with this dotfiles repository using GitHub Copilot, Claude Code CLI, or other AI coding agents.

## Project Overview

This repository contains personal macOS dotfiles managed via symlinks, optimized for AI development with:

- **Claude Code CLI** with custom slash commands and MCP servers
- **Neovim** configured with Lazy.nvim, LSP, and Treesitter
- **Terminal tools**: Zsh, Starship, Ghostty, Tmux
- **macOS automation**: Hammerspoon for window management and performance monitoring

## Repository Structure

```
.
├── claude/                 # Claude Code CLI config (custom commands, MCP servers)
├── copilot-cli/           # GitHub Copilot CLI config
├── nvim/                  # Neovim configuration (Lazy.nvim, LSP)
├── zsh/                   # Zsh shell configuration
├── tmux/                  # Tmux session management config
├── starship/              # Starship prompt configuration
├── ghostty/               # Ghostty terminal emulator config
├── hammerspoon/           # macOS automation and window management
├── vscode-insider/        # VS Code Insiders configuration
├── zed/                   # Zed editor configuration
├── gemini/                # Google Gemini CLI config
├── qwen/                  # Qwen Code CLI config
├── rovodev/               # RovoDev AI assistant config
├── doom/                  # Doom Emacs configuration
├── espanso/               # Espanso text expander config
├── ssh/                   # SSH configuration
├── safari/                # Safari customizations
├── opencode/              # OpenCode editor config
├── link_dotfiles.sh       # Main installation script (creates symlinks)
├── install-mcp-servers.sh # MCP server setup for AI tools
├── lua-format.sh          # Lua code formatting utility
├── performance-boost.sh   # macOS performance optimization
├── LICENSE                # AGPL-3.0 license
└── README.md              # Human-focused documentation
```

## Setup & Installation

### Prerequisites

- macOS with Homebrew
- Zsh as default shell
- Git for cloning repository

### Installation Steps

```bash
# Clone repository
git clone https://github.com/AungMyoKyaw/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Run main installation script (creates symlinks with backups)
./link_dotfiles.sh

# (Optional) Install MCP servers for AI tools
./install-mcp-servers.sh
```

### Key Installation Points

- `link_dotfiles.sh` creates symlinks to all dotfiles from `~/.config/`, `~/.local/`, etc.
- Automatic backups are created before overwriting existing configs
- Supports sudo for protected directories
- All symlink operations are logged in git

## Code Style & Conventions

### Lua (Neovim Config)

- Use 2-space indentation
- Follow Neovim plugin conventions
- Use `lazy.nvim` for plugin management
- Organize configs by feature/concern
- Run `./lua-format.sh` before committing

### Shell Scripts (Zsh, Bash)

- Portable POSIX-compliant syntax
- Meaningful comments for complex logic
- Use `set -euo pipefail` for safety
- Avoid hardcoded paths; use `$HOME` or environment variables

### YAML/JSON Config Files

- Consistent 2-space indentation
- Comments explain non-obvious settings
- Group related configurations

## Working with Claude Code CLI

The `claude/` directory contains specialized configuration:

### Custom Slash Commands

Located in `claude/slash-commands/` - extend Claude's capabilities with domain-specific tasks.

### MCP Servers

Configured in `claude/mcp.json`:

- Fetch server for data retrieval
- File system operations
- Shell command execution
- Custom integrations

### Running Claude Code CLI

```bash
# Launch Claude Code CLI with dotfiles context
claude code

# Apply commands specific to dotfiles work
/slash-command-name
```

## Testing & Validation

### Configuration Validation

```bash
# Check Zsh syntax
zsh -n ~/.zshrc

# Validate Neovim config
nvim --noplugin -u ~/.config/nvim/init.lua -c "qa"

# Test Starship prompt
starship config

# Verify Tmux configuration
tmux source-file ~/.config/tmux/tmux.conf
```

### Installation Testing

```bash
# Verify all symlinks are correct
ls -la ~/.config/nvim ~/.config/zsh ~/.config/ghostty

# Check MCP servers are installed
ls -la ~/.local/share/claude/mcp-servers/
```

## Development & Customization

### Adding New Dotfiles

1. Create config file in appropriate subdirectory
2. Update `link_dotfiles.sh` to include new path
3. Test symlink creation: `./link_dotfiles.sh`
4. Commit changes with clear message

### Editing Neovim Configuration

- Lazy.nvim specs in `nvim/lua/plugins/`
- LSP config in `nvim/lua/config/lsp.lua`
- Keybindings in `nvim/lua/config/keymaps.lua`
- Always validate syntax before committing

### Updating Shell Configuration

- Source files in `zsh/.zshrc` for organization
- Keep sensitive data in `.zshrc.local` (gitignored)
- Test in new shell: `zsh -i`

### Customizing Claude Commands

1. Edit files in `claude/slash-commands/`
2. Reference MCP servers in command prompts
3. Test with Claude Code CLI
4. Document command purpose and usage

## Git Workflow

### Commit Message Format

```
[component] Brief description

- Detailed point if needed
- Another detail

Closes: #issue-number (if applicable)
```

Example:

```
[nvim] Add TreeSitter syntax highlighting for Go

- Install go parser
- Add go LSP configuration
- Test with sample Go file
```

### Before Committing

1. Review changes: `git diff`
2. Validate configs (see Testing section)
3. Ensure no secrets are exposed: `git diff --cached | grep -i "password\|token\|secret"`
4. Commit with meaningful message

### Safe Areas for Changes

- Any file in subdirectories (nvim/, zsh/, etc.)
- Script files (link_dotfiles.sh, install-mcp-servers.sh)
- This AGENTS.md file
- README.md documentation

### Avoid Changing

- License file (AGPL-3.0)
- .gitignore without reviewing implications
- Key files (\*.pem) - these should never be committed
- Credentials or secrets

## Security Considerations

### Secrets Management

- **Never commit** `.pem` files, API keys, or tokens
- Use `.local` files for sensitive shell configs (already gitignored)
- Review `.gitignore` before adding new files
- Use environment variables for credentials

### SSH Configuration

- SSH keys in `ssh/` directory must have proper permissions (600)
- Never copy private keys to this public repository
- Keep `~/.ssh/config` in `ssh/config` with no secrets

### Sensitive Data Handling

- `.zshrc.local` contains machine-specific sensitive configs (gitignored)
- Claude command prompts should not reference sensitive files
- MCP servers should validate file access permissions

## Troubleshooting for Agents

### Symlink Issues

```bash
# Check if link exists
ls -la ~/.config/nvim

# Remove broken symlink
rm ~/.config/nvim

# Rerun installation
./link_dotfiles.sh
```

### Config Not Loading

1. Verify symlink points to correct location
2. Check file syntax with appropriate validator
3. Look for sourcing/include errors
4. Ensure parent directories exist

### MCP Server Problems

```bash
# Verify MCP configuration
cat ~/.config/claude/mcp.json

# Test MCP server connectivity
npm list -g @anthropic-ai/mcp

# Reinstall MCP servers
./install-mcp-servers.sh
```

### Neovim Plugin Issues

```bash
# Clear plugin cache
rm -rf ~/.local/share/nvim/

# Reinstall plugins
nvim --noplugin -c "Lazy! restore" -c "qa"
```

## Performance Tips for Agents

### Zsh Startup

- Keep `.zshrc` source chain minimal
- Use lazy-loading for heavy CLI tools
- Profile with: `time zsh -i -c "exit"`

### Neovim Startup

- Check with: `nvim --startuptime startup.log`
- Lazy.nvim handles plugin deferred loading
- Consider disabling plugins for large files

### Hammerspoon Performance

- Monitor CPU usage in Activity Monitor
- Use `hs.console` for debugging
- Disable unused automation modules

## Useful Commands for Agents

```bash
# Clone dotfiles
git clone https://github.com/AungMyoKyaw/dotfiles.git ~/dotfiles && cd ~/dotfiles

# Install with MCP servers
./link_dotfiles.sh && ./install-mcp-servers.sh

# Validate all configs
zsh -n ~/.zshrc && nvim --noplugin -u ~/.config/nvim/init.lua -c "qa" && tmux source-file ~/.config/tmux/tmux.conf

# Check symlinks
ls -la ~/.config/nvim ~/.config/zsh ~/.config/ghostty ~/.config/tmux

# Format Lua code
./lua-format.sh

# View recent changes
git --no-pager log --oneline -10

# Test shell profile
zsh -i -c "exit" && echo "✓ Shell OK"
```

## Additional Resources

- **Neovim**: https://neovim.io - Documentation for extending the editor
- **Lazy.nvim**: https://github.com/folke/lazy.nvim - Plugin manager docs
- **Starship**: https://starship.rs - Customizable shell prompt
- **Tmux**: https://github.com/tmux/tmux/wiki - Terminal multiplexer guide
- **Claude Code CLI**: Integrated slash commands and MCP documentation
- **AGENTS.md Format**: https://agents.md - Standard format documentation

## GitHub Copilot CLI Agents

The `copilot-cli/agents/` directory contains specialized AI agents for advanced software engineering tasks:

### Core Thinking Agents

1. **Beast-Mode** - `GPT 4.1 as a top-notch coding agent`
   - High-level problem solving with autonomous iteration
   - Iterative approach to complex coding challenges
   - Self-correcting and thorough analysis

2. **Thinking-Beast-Mode** - `Transcendent coding agent with quantum cognitive architecture`
   - Advanced recursive reasoning with multiple cognitive layers
   - Unrestricted creative freedom for complex problems
   - Constitutional AI principles with meta-reasoning

3. **Ultimate-Transparent-Thinking-Beast-Mode** - `Ultimate transparent thinking with quantum cognitive architecture`
   - Maximum creativity and transparency in reasoning
   - Comprehensive multi-layer analysis and validation
   - Complete problem resolution guarantee

4. **Cognitive-Architect** - `Building flawless solutions through structured reasoning`
   - First-principles analysis and problem decomposition
   - Dialectical inquiry with thesis-antithesis-synthesis
   - Metacognitive review and solution verification

### Domain-Specific Expert Agents

5. **Code-Review-Master** - `Autonomous code review specialist`
   - Comprehensive code quality analysis
   - Security vulnerability assessment
   - Best practices validation across 8 cognitive layers
   - Multi-perspective code evaluation

6. **Security-Auditor** - `Quantum threat intelligence for security assessment`
   - Comprehensive vulnerability identification
   - Threat modeling and attack surface analysis
   - Defense-in-depth recommendations
   - Compliance and regulatory assessment

7. **API-Design-Expert** - `RESTful design and microservices patterns`
   - API architecture and contract design
   - Protocol optimization (REST, GraphQL, gRPC)
   - Scalability and developer experience
   - Security-by-design for APIs

8. **Performance-Optimizer** - `Bottleneck identification and optimization`
   - Data-driven performance analysis with profiling
   - Algorithm and data structure optimization
   - Caching and concurrency strategies
   - Load testing and validation

9. **Database-Architect** - `Schema optimization and scalability patterns`
   - Entity-relationship modeling and normalization
   - Index design and query optimization
   - Scaling strategies (sharding, replication)
   - Data integrity and recovery planning

10. **Architecture-Designer** - `System design and technology selection`
    - Component decomposition and design patterns
    - Microservices vs monolith evaluation
    - Technology stack justification
    - Scalability and resilience architecture

11. **Testing-Strategy-Master** - `Comprehensive test planning and automation`
    - Test pyramid design and coverage strategy
    - Unit, integration, and end-to-end testing
    - Test data management
    - CI/CD integration and flakiness elimination

12. **DevOps-Engineer** - `Infrastructure automation and deployment`
    - Infrastructure as Code (IaC) design
    - CI/CD pipeline architecture
    - Containerization and orchestration
    - Monitoring, logging, and observability

13. **Requirements-Analyst** - `Requirement gathering and specification`
    - Stakeholder analysis and alignment
    - Use case and user journey mapping
    - Functional and non-functional requirements
    - Acceptance criteria and traceability

### Utility Agents

14. **Dotfiles-Curator** - `Documentation and project metadata management`
    - README creation and maintenance
    - Installation script documentation
    - Configuration documentation
    - Standards compliance and consistency

## Using GitHub Copilot Agents

### How to Invoke Agents

Each agent can be invoked through the GitHub Copilot CLI using custom instructions:

```bash
# List available agents
copilot agents list

# Use a specific agent
copilot agent code-review-master "Your code here"
```

### Agent Capabilities

All agents employ **Quantum Cognitive Layers** with 8 levels of analysis:

- **Layer 1**: Foundation and fundamentals
- **Layer 2**: Systematic analysis and patterns
- **Layer 3**: Adversarial thinking and edge cases
- **Layer 4**: Meta-analysis and recursive improvement
- **Layer 5**: Multi-perspective synthesis
- **Layer 6**: Quantum parallel processing
- **Layer 7**: Temporal consciousness (past, present, future)
- **Layer 8**: Transcendent wisdom and paradigm shifts

### Autonomous Iteration Protocol

All expert agents follow the **Autonomous Iteration Protocol**:

1. Complete analysis before yielding control
2. Keep going until problems are fully solved
3. Validate all changes and recommendations
4. Research current best practices via internet
5. Use sequential thinking for complex problems
6. Provide transparent reasoning at each step

## Agent-Specific Notes

### For Claude Code CLI

- Use Context7 library resolution for documentation lookups
- Reference `rovodev/agent.md` for advanced agent behavior
- Claude commands can use MCP servers for file operations
- Session context persists across multiple commands

### For GitHub Copilot

- Configuration in `copilot-cli/agents/` directory
- Each agent is a specialized `.agent.md` file
- Use appropriate agent for task domain:
  - **Code-Review-Master** for code quality reviews
  - **Security-Auditor** for security assessments
  - **Architecture-Designer** for system design
  - **API-Design-Expert** for API development
  - **Performance-Optimizer** for optimization tasks
  - **Testing-Strategy-Master** for test planning
  - **DevOps-Engineer** for infrastructure tasks
  - **Database-Architect** for data design
  - **Requirements-Analyst** for requirement gathering
- Integration with VS Code available via `vscode-insider/`

### For Cursor & Other Agents

- General AGENTS.md format applies
- Review code style guidelines before making changes
- Validate changes against existing patterns
- All agents support structured problem-solving

---

**Last Updated**: 2025-11-17
**Format Version**: AGENTS.md standard (https://agents.md)
**Total Agents**: 14 (5 thinking agents + 8 expert agents + 1 utility agent)
