---
description: 'Setup comprehensive linting and code quality tools for your project'
argument-hint: '[language] [standard] [@target-directory]'
---

## Context

- Target Language: $1 (auto-detected if not specified)
- Standard/Framework: $2 (default: industry standard)
- Target Directory: $ARGUMENTS
- Current project: !`find . -name "package.json" -o -name "pyproject.toml" -o -name "requirements.txt" -o -name "Cargo.toml" | head -3 || echo "No package manager detected"`

## Linting Setup: $1 (default: auto-detect)

Setup comprehensive linting and code quality system covering:

1. **Linting Configuration** for code quality and consistency
2. **Formatting Rules** for automatic code formatting
3. **Pre-commit Hooks** for automated quality checks
4. **CI/CD Integration** for continuous quality enforcement
5. **IDE Integration** for developer experience
6. **Team Standards** for consistent collaboration

## Standard/Framework: $2 (default: industry standard)

$ARGUMENTS

### Usage Examples:

```bash
/linting javascript airbnb @src/
/linting python black @backend/
/linting typescript vercel @frontend/
/linting go standard @api/
/linting rust clippy @src/
/linting java google @main/
```

### Supported Languages:

**JavaScript/TypeScript:**

- `airbnb` - Airbnb Style Guide (comprehensive, strict)
- `vercel` - Vercel/Next.js standard (optimized for Next.js)
- `google` - Google JavaScript Style Guide
- `standard` - JavaScript Standard Style
- `prettier` - Prettier formatting with minimal linting

**Python:**

- `black` - Black formatter with ruff linting (modern, fast)
- `pep8` - PEP 8 compliance with flake8
- `google` - Google Python Style Guide
- `django` - Django project standards
- `fastapi` - FastAPI project best practices

**Go:**

- `standard` - Go standard formatting and linting
- `uber` - Uber Go Style Guide
- `google` - Google Go Style Guide

**Rust:**

- `clippy` - Rust linter with comprehensive checks
- `standard` - Rust standard formatting

**Java:**

- `google` - Google Java Style Guide
- `oracle` - Oracle Java Style Guide

### Setup Components:

**🔧 Configuration Files:**

- ESLint configuration (`.eslintrc.js/.json`)
- Prettier configuration (`.prettierrc`)
- Ruff configuration (`pyproject.toml`)
- Clippy configuration (`.clippy.toml`)
- Language-specific linting rules

**📦 Package Scripts:**

- `lint` - Run linting checks
- `lint:fix` - Auto-fix linting issues
- `format` - Format code according to rules
- `format:check` - Check code formatting
- `type-check` - Run type checking (if applicable)

**🪝 Pre-commit Hooks:**

- Husky configuration for git hooks
- lint-staged configuration for staged files
- Automatic formatting on commit
- Linting enforcement before commits

**🔄 CI/CD Integration:**

- GitHub Actions workflows
- Quality gate enforcement
- Pull request checks
- Automated reporting

### Implementation Steps:

**1. Project Analysis**

- Detect existing configurations and tools
- Identify language and framework requirements
- Analyze team preferences and standards
- Check for potential conflicts

**2. Tool Selection**

- Choose optimal linting tools for the stack
- Select appropriate rule presets
- Configure custom rules for project needs
- Ensure tool compatibility

**3. Configuration Generation**

- Create comprehensive configuration files
- Add package manager scripts
- Setup pre-commit hooks
- Configure IDE integration

**4. Integration Setup**

- Install required dependencies
- Configure pre-commit hooks
- Setup CI/CD quality gates
- Update project documentation

**5. Team Onboarding**

- Document code quality standards
- Provide setup instructions
- Create troubleshooting guides
- Establish review processes

### Quality Gates:

**🚫 Blocking Issues**

- Linting errors must be fixed
- Type errors prevent commits
- Security vulnerabilities block merges
- Performance issues require attention

**⚠️ Warnings**

- Style inconsistencies should be addressed
- Deprecated patterns need updates
- Optimization opportunities identified
- Documentation gaps highlighted

**💡 Suggestions**

- Code modernization recommendations
- Best practice implementations
- Performance optimizations
- Security improvements

### Advanced Features:

**🔍 Static Analysis:**

- Code complexity analysis
- Security vulnerability scanning
- Performance impact assessment
- Technical debt tracking

**📊 Quality Metrics:**

- Code coverage integration
- Technical debt scoring
- Maintainability index
- Code duplication detection

**🎯 Custom Rules:**

- Project-specific linting rules
- Team coding standards
- Framework best practices
- Business logic validation

### Specialized Setups:

- `/linting typescript react "React component library"` - React/TypeScript project
- `/linting python django "Django web application"` - Django project setup
- `/linting node express "Express API server"` - Node.js backend
- `/linting next vercel "Next.js application"` - Next.js with Vercel standards

The linting setup includes:

- Industry-standard tooling configurations
- Automated quality enforcement
- Team collaboration standards
- Performance and security integration
- Comprehensive documentation and onboarding

Focus on creating a maintainable, scalable code quality system that enhances developer productivity while ensuring consistent, high-quality code across the project.
