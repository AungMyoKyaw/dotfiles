# Zsh Configuration

This directory contains the public zsh configuration that can be safely shared in version control.

## Files

- `.zshrc` - Main zsh configuration file (public, safe to share)
- `.zshrc.local.example` - Template for local environment variables (sensitive information)

## Setup

1. The `.zshrc` file will automatically source `~/.zshrc.local` if it exists
2. Create your own `~/.zshrc.local` file with your sensitive environment variables
3. Never commit `~/.zshrc.local` to version control

## Sensitive Information

All sensitive information (API keys, passwords, etc.) should be stored in `~/.zshrc.local` which is not tracked by git.

Example of what to put in `~/.zshrc.local`:

```bash
# API Keys
export OPENAI_API_KEY="sk-your-openai-api-key"
export ANTHROPIC_API_KEY="sk-ant-your-anthropic-api-key"

# AWS Credentials
export AWS_ACCESS_KEY_ID="your-aws-access-key"
export AWS_SECRET_ACCESS_KEY="your-aws-secret-key"
```

## Process Management Functions

### Development Processes

- `killall_node` - Kills all Node.js processes
- `killall_nvim` - Kills all Neovim processes
- `killall_dev` - Kills both Node.js and Neovim processes

### Application-Specific Kill Functions

- `killall_browsers` - Kills Chrome, Safari, Firefox, Arc browsers
- `killall_adobe` - Kills all Adobe processes (Photoshop, Illustrator, etc.)
- `killall_office` - Kills Microsoft Office applications
- `killall_docker` - Kills Docker processes and cleans up containers
- `killall_devtools` - Kills development tools (Postman, Insomnia, TablePlus, etc.)
- `killall_communication` - Kills communication apps (Slack, Discord, Zoom, Teams)
- `killall_design` - Kills design tools (Figma, Sketch, Canva)
- `killall_stats` - Kills system monitoring tools (iStat Menus, Activity Monitor)

### Mega Functions

- `killall_performance` - 🔥 **NUKES EVERYTHING** - Kills all non-essential processes for maximum performance
- `show_resource_hogs` - Shows top 10 CPU and memory consuming processes

### Usage Examples

```bash
# Kill development processes
killall_dev

# Check what's consuming resources
show_resource_hogs

# Emergency performance boost (⚠️ closes all apps, save work first!)
killall_performance

# Kill specific categories
killall_browsers    # Free up browser resources
killall_adobe       # Adobe apps are notorious resource hogs
killall_communication  # Kill Slack, Discord, etc.
```

### Important Notes

- All functions check if processes exist before attempting to kill them
- Functions provide feedback on what was killed or if nothing was found
- `killall_performance` will close all applications and make you lose unsaved work
- Use `show_resource_hogs` to identify what's actually consuming resources
- Reload zsh configuration with `reload` or `source ~/.zshrc` after making changes
