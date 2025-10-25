#!/bin/bash

# MCP Server Installation Script for Claude CLI
# This script installs all the specified MCP servers

set -euo pipefail

echo "Installing MCP servers for Claude CLI..."

# Function to run claude command, handling both direct and alias usage
run_claude() {
    if command -v claude &> /dev/null; then
        claude "$@"
    else
        npx @anthropic-ai/claude-code@next --dangerously-skip-permissions "$@"
    fi
}

# Function to install MCP server, skipping if already installed
install_mcp_server() {
    local server_name="$1"
    shift
    echo "Checking $server_name server..."

  # Check if server exists by trying to list it
  local mcp_list_output
  mcp_list_output=$(run_claude mcp list 2>/dev/null || echo "")
  if echo "$mcp_list_output" | grep -q "^$server_name:"; then
      echo "$server_name server already installed, skipping..."
      return 0
  fi

  echo "Installing $server_name server..."
  # Install the server
  run_claude mcp add "$server_name" -s user "$@"
  echo "Successfully installed $server_name server"
}

# Sequential Thinking Server
install_mcp_server sequential-thinking \
  -- npx -y @modelcontextprotocol/server-sequential-thinking@latest

# Context7 Server
install_mcp_server context7 \
  -- npx -y @upstash/context7-mcp@latest

# Fetch Server (requires uvx)
if ! command -v uvx &> /dev/null; then
    echo "Warning: uvx not found. Please install uvx first: pip install uvx"
    echo "Then run this script again or install fetch server manually:"
    echo "run_claude mcp add fetch -s user -- uvx mcp-server-fetch --user-agent='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.5112.79 Safari/537.36' --ignore-robots-txt"
else
    install_mcp_server fetch \
      -- uvx mcp-server-fetch \
        --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.5112.79 Safari/537.36" \
        --ignore-robots-txt
fi

# Playwright Server
install_mcp_server playwright \
  -- npx @playwright/mcp@latest \
    --no-sandbox \
    --isolated \
    --image-responses omit \
    --block-service-workers \
    --ignore-https-errors \
    --save-session \
    --save-trace

echo ""
echo "All MCP servers installed successfully!"
echo ""
echo "To verify the installation, run:"
echo "run_claude mcp list"
echo ""
echo "To restart Claude CLI and pick up the new servers, run:"
echo "run_claude restart"
