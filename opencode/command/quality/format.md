---
description: 'Setup automatic code formatting with industry-standard tools'
---

## Context

- Target Language: $1 (auto-detected if not specified)
- Style Preference: $2 (default: standard)
- Target Directory: $ARGUMENTS
- Current files: !`find . -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.go" -o -name "*.rs" | wc -l` files to format

## Code Formatting: $1 (default: auto-detect)

Setup comprehensive code formatting system covering:

1. **Automatic Formatting** for consistent code style
2. **Configuration Files** for team standards
3. **Integration Scripts** for build systems
4. **IDE Integration** for developer experience
5. **Pre-commit Hooks** for automated formatting
6. **CI/CD Validation** for format enforcement

## Style Preference: $2 (default: standard)

$ARGUMENTS

### Usage Examples:

```bash
/format javascript standard @src/
/format python black @backend/
/format typescript prettier @frontend/
/format go standard @api/
/format rust default @src/
/format java google @main/
```

### Supported Languages & Formatters:

**JavaScript/TypeScript:**

- `prettier` - Prettier (industry standard, opinionated)
- `standard` - JavaScript Standard Style
- `airbnb` - Airbnb Style Guide configuration
- `google` - Google JavaScript Style

**Python:**

- `black` - Black code formatter (uncompromising)
- `ruff` - Ruff formatter (fast, all-in-one)
- `blue` - Blue formatter (Black alternative)
- `yapf` - YAPF (Yet Another Python Formatter)

**Go:**

- `standard` - gofmt (Go standard formatter)
- `custom` - Custom formatting rules

**Rust:**

- `default` - rustfmt (Rust standard formatter)
- `custom` - Custom rustfmt configuration

**Java:**

- `google` - Google Java Style
- `oracle` - Oracle Java Style
- `spotless` - Spotless formatting

**Other Languages:**

- `c/cpp` - clang-format for C/C++
- `csharp` - dotnet-format for C#
- `php` - PHP-CS-Fixer for PHP
- `ruby` - Rufo for Ruby

### Standard Configurations:

**🎨 Prettier Configuration (JavaScript/TypeScript):**

```json
{
  "printWidth": 80,
  "tabWidth": 2,
  "useTabs": false,
  "semi": true,
  "singleQuote": true,
  "quoteProps": "as-needed",
  "jsxSingleQuote": false,
  "trailingComma": "none",
  "bracketSpacing": true,
  "bracketSameLine": false,
  "arrowParens": "always",
  "endOfLine": "lf"
}
```

**🐍 Black Configuration (Python):**

```toml
[tool.black]
line-length = 88
target-version = ['py38', 'py39', 'py310', 'py311']
include = '\.pyi?$'
extend-exclude = '''
/(
  # directories
  \.eggs
  | \.git
  | \.hg
  | \.mypy_cache
  | \.tox
  | \.venv
  | build
  | dist
)/
'''
```

**🦀 Rustfmt Configuration (Rust):**

```toml
edition = "2021"
hard_tabs = false
tab_spaces = 2
max_width = 100
use_small_heuristics = "Default"
```

### Implementation Steps:

**1. Project Analysis**

- Detect primary programming languages
- Identify existing formatting configurations
- Analyze team preferences and standards
- Check for potential conflicts

**2. Tool Installation**

- Install appropriate formatter packages
- Add development dependencies
- Verify tool compatibility
- Setup global configurations if needed

**3. Configuration Generation**

- Create formatter-specific config files
- Define project-specific formatting rules
- Setup ignore patterns and exclusions
- Configure team standards

**4. Integration Setup**

- Add formatting scripts to package.json
- Setup pre-commit formatting hooks
- Configure IDE formatting integration
- Create CI/CD validation checks

**5. Initial Formatting**

- Run initial formatting on entire codebase
- Fix any formatting conflicts
- Verify all files are properly formatted
- Update version control with formatted files

### Package Scripts:

**📦 npm/yarn Scripts:**

```json
{
  "scripts": {
    "format": "prettier --write .",
    "format:check": "prettier --check .",
    "format:staged": "prettier --write --staged"
  }
}
```

**🐍 pip/poetry Scripts:**

```toml
[tool.poetry.scripts]
format = "ruff format ."
format-check = "ruff format --check ."
```

### Pre-commit Integration:

**🪝 Husky + lint-staged Setup:**

```json
{
  "lint-staged": {
    "*.{js,jsx,ts,tsx}": ["prettier --write", "git add"],
    "*.py": ["ruff format", "git add"]
  }
}
```

### IDE Integration:

**VS Code Configuration:**

```json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "[python]": {
    "editor.defaultFormatter": "charliermarsh.ruff"
  }
}
```

### Formatting Rules:

**🎯 JavaScript/TypeScript:**

- Consistent indentation (2 spaces)
- Single quotes for strings
- Semicolons required
- Trailing commas (configurable)
- Consistent arrow function parentheses
- Proper bracket spacing

**🐍 Python:**

- 88-character line length
- Double quotes for strings
- Consistent spacing around operators
- Proper import organization
- Consistent function/class definitions

**🦀 Rust:**

- 100-character line width
- 4-space indentation
- Consistent struct/enum formatting
- Proper use spacing and alignment
- Consistent import organization

### Validation & Enforcement:

**✅ Format Validation:**

- Pre-commit format checks
- CI/CD format gates
- Pull request format validation
- Automated format fixing

**🚫 Format Blocking:**

- Reject unformatted commits
- Block PRs with format issues
- Enforce team formatting standards
- Prevent style drift

### Advanced Features:

**🔧 Custom Rules:**

- Project-specific formatting preferences
- Framework-specific conventions
- Team style guide integration
- Legacy code formatting strategies

**📊 Format Metrics:**

- Code formatting consistency scores
- Format compliance tracking
- Style drift detection
- Team adoption metrics

### Specialized Setups:

- `/format typescript prettier "React component library"` - React with Prettier
- `/format python black "Django web application"` - Django with Black
- `/format go standard "Microservices API"` - Go services
- `/format rust default "CLI application"` - Rust CLI tools

The formatting setup includes:

- Industry-standard formatter configurations
- Automated formatting workflows
- Team collaboration standards
- IDE and editor integration
- Comprehensive validation and enforcement

Focus on creating a seamless, automated formatting experience that ensures consistent code style across the entire project while maintaining developer productivity and code quality standards.
