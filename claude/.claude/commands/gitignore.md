---
description: 'Generate comprehensive .gitignore files for any project type'
argument-hint: '[project-type] [framework] [additional-tools]'
---

## Context

- Project Type: $1 (auto-detected if not specified)
- Framework: $2 (auto-detected if not specified)
- Additional Tools: $3 (optional)
- Current directory: !`pwd`

## .gitignore Generation: $1 (default: auto-detect)

Generate comprehensive .gitignore covering:

1. **Build Artifacts** for compiled languages and frameworks
2. **Dependencies** for package managers and libraries
3. **IDE Files** for development environments
4. **OS Files** for system-generated files
5. **Environment Variables** for sensitive configuration
6. **Logs and Temp Files** for runtime artifacts
7. **Database Files** for local development data

## Framework: $2 (default: auto-detect)

$ARGUMENTS

### Usage Examples:

```bash
/gitignore node react
/gitignore python django
/gitignore java maven
/gitignore go standard
/gitignore rust standard
/gitignore vue nuxt
/gitignore mobile flutter
/gitignore fullstack "React, Node.js, PostgreSQL"
```

### Project Types & Frameworks:

**Web Development:**

- `node` - Node.js projects (JavaScript/TypeScript)
- `react` - React applications
- `vue` - Vue.js applications
- `angular` - Angular applications
- `next` - Next.js applications
- `nuxt` - Nuxt.js applications
- `svelte` - Svelte applications
- `gatsby` - Gatsby sites

**Backend Development:**

- `python` - Python projects (Django, Flask, FastAPI)
- `django` - Django web framework
- `flask` - Flask web framework
- `fastapi` - FastAPI framework
- `express` - Express.js framework
- `spring` - Spring Boot (Java)
- `rails` - Ruby on Rails
- `laravel` - Laravel PHP framework

**Mobile Development:**

- `flutter` - Flutter mobile apps
- `react-native` - React Native apps
- `ios` - iOS development (Swift/Objective-C)
- `android` - Android development (Java/Kotlin)
- `cordova` - Apache Cordova
- `ionic` - Ionic framework

**Desktop Development:**

- `electron` - Electron desktop apps
- `java` - Java applications
- `csharp` - C#/.NET applications
- `cpp` - C++ applications
- `rust` - Rust applications
- `go` - Go applications

**Data Science & ML:**

- `jupyter` - Jupyter notebooks
- `r` - R projects
- `ml` - Machine learning projects
- `data` - Data science projects

### Generated Sections:

**🚀 Build & Distribution:**

```gitignore
# Build outputs
dist/
build/
out/
target/
bin/
*.exe
*.dll
*.so
*.dylib
```

**📦 Dependencies:**

```gitignore
# Dependencies
node_modules/
__pycache__/
venv/
env/
.venv/
*.egg-info/
target/dependency/
```

**💻 IDE & Editor Files:**

```gitignore
# IDE files
.vscode/
.idea/
*.swp
*.swo
*~
```

**🖥️ Operating System Files:**

```gitignore
# OS files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
```

**🔐 Sensitive Configuration:**

```gitignore
# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Secrets
*.key
*.pem
*.p12
.secrets
```

**📊 Logs & Runtime Files:**

```gitignore
# Logs
logs/
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Runtime data
pids/
*.pid
*.seed
*.pid.lock
```

### Framework-Specific Patterns:

**Node.js/npm:**

```gitignore
# Dependency directories
node_modules/
jspm_packages/

# Optional npm cache directory
.npm

# Optional eslint cache
.eslintcache

# Output of 'npm pack'
*.tgz

# Yarn Integrity file
.yarn-integrity
```

**Python:**

```gitignore
# Byte-compiled / optimized / DLL files
__pycache__/
*.py[cod]
*$py.class

# Virtual environments
venv/
env/
ENV/
env.bak/
venv.bak/

# PyInstaller
*.manifest
*.spec
```

**Java/Maven:**

```gitignore
# Compiled class file
*.class

# Log file
*.log

# BlueJ files
*.ctxt

# Mobile Tools for Java (J2ME)
.mtj.tmp/

# Package Files
*.jar
*.war
*.nar
*.ear
*.zip
*.tar.gz
*.rar
```

### Advanced Features:

**🔍 Template Integration:**

- Sourced from official GitHub gitignore repository
- Community-maintained templates
- Framework-specific best practices
- Tool-specific patterns

**📋 Merge Strategy:**

- Preserve existing custom rules
- Intelligently combine multiple templates
- Remove duplicates automatically
- Maintain clear organization

**🎯 Customization Options:**

- Project-specific ignore patterns
- Team preferences
- Custom tool integration
- Deployment configurations

### Specialized Generators:

**🌐 Full-Stack Applications:**

```bash
/gitignore fullstack "React, Node.js, PostgreSQL"
```

Covers frontend build files, backend dependencies, database files, and deployment artifacts.

**📱 Mobile Applications:**

```bash
/gitignore mobile flutter "Firebase integration"
```

Includes mobile build artifacts, IDE files, and service configuration.

**🤖 Machine Learning Projects:**

```bash
/gitignore ml "Jupyter, TensorFlow, PyTorch"
```

Covers model files, datasets, notebooks, and ML framework artifacts.

### Validation Features:

**✅ Safety Checks:**

- Prevents ignoring important source files
- Validates pattern syntax
- Checks for common mistakes
- Ensures security compliance

**🔍 Conflict Resolution:**

- Handles existing .gitignore files
- Merges conflicting patterns
- Preserves custom rules
- Provides clear explanations

### Usage Guidelines:

**1. Auto-Detection Mode:**

```bash
/gitignore
```

Automatically analyzes project structure and generates appropriate .gitignore.

**2. Specific Framework Mode:**

```bash
/gitignore python django
```

Generates .gitignore specific to Python Django projects.

**3. Multi-Framework Mode:**

```bash
/gitignore fullstack "React, Node.js, MongoDB"
```

Combines multiple frameworks and tools.

**4. Custom Extension Mode:**

```bash
/gitignore node react "additional-tool"
```

Adds extra tools and frameworks to the base template.

The generated .gitignore includes:

- Comprehensive technology coverage
- Security-sensitive file protection
- IDE and tool-specific patterns
- Operating system file exclusion
- Clear documentation and organization
- Best practice compliance

Focus on creating a robust, maintainable .gitignore that protects sensitive data while ensuring smooth development workflows across different environments and team members.
