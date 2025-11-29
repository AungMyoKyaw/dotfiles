---
description: 'Generate deployment configurations and scripts'
---

## Context

- Detected runtime: !`ls package.json 2>/dev/null && echo "Node.js" || ls requirements.txt 2>/dev/null && echo "Python" || ls Cargo.toml 2>/dev/null && echo "Rust" || ls go.mod 2>/dev/null && echo "Go" || echo "Unknown"`
- Docker available: !`docker --version 2>/dev/null || echo "Docker not found"`
- Current git branch: !`git branch --show-current 2>/dev/null || echo "Not a git repo"`
- Package scripts: !`cat package.json 2>/dev/null | grep -A 10 '"scripts"' || echo "No package.json found"`

## Target Environment: $1 (default: production)

Generate deployment configurations and scripts for this project. Include:

1. **Docker Configuration** - Dockerfile, docker-compose.yml
2. **CI/CD Pipeline** - GitHub Actions, GitLab CI, or similar
3. **Environment Configuration** - .env templates, config files
4. **Deployment Scripts** - Automated deployment bash scripts
5. **Infrastructure as Code** - Terraform, CloudFormation, or similar
6. **Monitoring and Logging** - Setup for observability
7. **Security Hardening** - Production security configurations

## Target Platform: $2 (default: auto-detect)

$ARGUMENTS

### Usage Examples:

```bash
/deploy production aws
/deploy staging docker
/deploy development vercel
/deploy production gcp
/deploy testing netlify
```

### Supported Environments:

- `development` - Local development setup
- `staging` - Pre-production testing
- `production` - Live production deployment
- `testing` - CI/CD testing environment

### Supported Platforms:

- `docker` - Docker containerization
- `aws` - Amazon Web Services
- `gcp` - Google Cloud Platform
- `azure` - Microsoft Azure
- `vercel` - Vercel platform
- `netlify` - Netlify platform
- `heroku` - Heroku platform

Consider:

- Multi-environment support (dev/staging/prod)
- Scalability and performance requirements
- Backup and disaster recovery
- Security best practices
- Cost optimization
- Monitoring and alerting

Provide production-ready deployment setup with clear instructions.
