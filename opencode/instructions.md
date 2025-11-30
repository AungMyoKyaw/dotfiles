# Global Instructions for OpenCode

## Image Processing Workflow

When you receive a pasted image, follow this workflow:

1. **Convert image to location**: First save/convert the pasted image to a file location
2. **Use Z AI MCP Server**: Use the `zai-mcp-server_analyze_image` tool to describe and analyze the image

### Example Usage:

```bash
# Save pasted image to file
# Then use:
zai-mcp-server_analyze_image with the image path and appropriate prompt
```

## Priority

This instruction takes precedence over other instructions when dealing with images. Always use the Z AI MCP server for image analysis after converting pasted images to file locations.
