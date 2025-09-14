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
