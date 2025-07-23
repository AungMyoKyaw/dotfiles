# RovoDev Configuration

This directory contains the configuration files for RovoDev, an AI-powered development assistant.

## Files

- `config.yml` - Main RovoDev configuration
- `mcp.json` - Model Context Protocol (MCP) server configurations

## Configuration Features

### Agent Settings

- **Streaming**: Enabled for real-time responses
- **Temperature**: Set to 0.3 for balanced creativity and consistency
- **Shadow Mode**: Disabled (experimental feature for safe workspace testing)

### Session Management

- **Auto-restore**: Disabled - sessions don't automatically restore on startup
- **Persistence Directory**: `~/.rovodev/sessions`

### Console Output

- **Format**: Markdown for rich text display
- **Tool Results**: Visible in console output
- **Max Width**: 120 characters

### Security & Permissions

- **Default Tool Permission**: Allow for most operations
- **Atlassian Tools**: Read operations allowed, write operations require confirmation (`ask`)
- **File Operations**: All file operations allowed (create, delete, find/replace, open, expand, grep)
- **Bash Commands**: Selective permissions with allow list for safe commands (ls, cat, echo, git read operations, pwd)
- **External Path Access**: Limited to `~/workspace` and `/tmp`

### MCP Servers Configured

1. **sequential-thinking** - Dynamic problem-solving through thought sequences
2. **context7** - Enhanced context management and documentation
3. **fetch** - Web content fetching and conversion
4. **puppeteer** - Browser automation and web scraping
5. **memory** - Knowledge graph-based persistent memory

### Current Configuration Paths

The configuration uses the following paths:

- **Sessions Directory**: `/Users/aungmyokyaw/.rovodev/sessions`
- **Log File**: `/Users/aungmyokyaw/.rovodev/rovodev.log`
- **MCP Config**: Full path to this `mcp.json` file in Google Drive sync

### Security Best Practices

- **Atlassian Write Operations**: Require confirmation (Confluence page creation/updates, Jira issue creation/editing)
- **File Operations**: All allowed without confirmation for development efficiency
- **Bash Commands**: Restricted to safe read-only operations (ls, cat, echo, git status/diff/log, pwd)
- **External Access**: Limited to workspace and temp directories only

### Allowed MCP Servers

The configuration explicitly allows these MCP servers:

- `@modelcontextprotocol/server-sequential-thinking`
- `@upstash/context7-mcp`
- `mcp-server-fetch`
- `@modelcontextprotocol/server-puppeteer`
- `@modelcontextprotocol/server-memory`

## Usage

After updating the configuration, restart RovoDev to apply the changes:

```bash
rovodev restart
```

## Troubleshooting

If MCP servers fail to start:

1. Check that Node.js and npm are installed for npx commands
2. Check that uv/uvx is installed for Python-based servers
3. Verify network connectivity for package downloads
4. Check the RovoDev logs at the configured log path
5. Ensure allowed directories exist and are accessible
