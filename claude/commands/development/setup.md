---
description: 'Setup development environment and project dependencies'
argument-hint: '[tech-stack] [environment]'
---

## Context

- Current environment: !`node --version 2>/dev/null || python --version 2>/dev/null || echo "No runtime detected"`
- Available tools: !`which npm 2>/dev/null && echo "npm" || which pip 2>/dev/null && echo "pip" || echo "No package manager"`
- Git status: !`git status --porcelain 2>/dev/null | head -3 || echo "Not a git repo"`
- Existing config: !`ls -la .env* *.json *.toml *.yaml 2>/dev/null | head -5 || echo "No config files found"`

## Tech Stack: $1 (default: auto-detect)

Setup the complete development environment for this project. Generate:

1. **Package Management** - package.json, requirements.txt, Cargo.toml, etc.
2. **Development Scripts** - Build, test, lint, and development server commands
3. **Environment Configuration** - .env templates and config files
4. **IDE Configuration** - VS Code settings, extensions, and workspace config
5. **Linting and Formatting** - ESLint, Prettier, Black, rustfmt configurations
6. **Testing Setup** - Test framework configuration and test scripts
7. **Documentation Setup** - Docs generation and serving configuration
8. **Git Configuration** - .gitignore, hooks, and contribution guidelines

## Environment: $2 (default: development)

$ARGUMENTS

### Usage Examples:

```bash
/setup react development
/setup node production
/setup python testing
/setup typescript staging
/setup "full stack" development
/setup all production
```

### Tech Stack Options:

- `react` - React + JavaScript/TypeScript
- `vue` - Vue.js ecosystem
- `angular` - Angular framework
- `node` - Node.js backend
- `python` - Python (Django/Flask/FastAPI)
- `typescript` - TypeScript projects
- `go` - Go language
- `rust` - Rust programming
- `full stack` - Complete web application
- `all` - Auto-detect and configure

### Environment Types:

- `development` - Local dev environment with hot reload
- `testing` - Test environment setup
- `staging` - Pre-production configuration
- `production` - Production-ready setup

Ensure the setup includes:

- Clear installation instructions
- Development workflow documentation
- Hot reloading for development
- Debugging configurations
- Pre-commit hooks for code quality
- CI/CD preparation
- Environment-specific configurations
- Development container support (Docker)
- Comprehensive README.md with setup guide
