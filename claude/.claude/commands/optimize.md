---
description: 'Optimize code for performance, security, and maintainability'
argument-hint: '[focus-area] [@target-file]'
---

## Context

- Project type: !`ls package.json 2>/dev/null && echo "Node.js" || ls requirements.txt 2>/dev/null && echo "Python" || ls Cargo.toml 2>/dev/null && echo "Rust" || echo "Unknown"`
- Bundle size (if applicable): !`du -sh node_modules 2>/dev/null || du -sh .venv 2>/dev/null || echo "No bundle found"`
- Performance metrics: !`find . -name "*.js" -o -name "*.py" | wc -l` files found
- Git changes: !`git diff --stat 2>/dev/null || echo "Not a git repo"`

## Optimization Focus: $1 (default: all)

Please analyze this code for performance issues, security vulnerabilities, and maintainability concerns. Provide specific recommendations for improvements with code examples where applicable.

Focus on:

1. **Performance bottlenecks** and optimization opportunities
2. **Security vulnerabilities** and best practices
3. **Code readability** and maintainability
4. **Architecture** and design patterns
5. **Error handling** and edge cases

## Target File: $2 (optional - use @filename)

$ARGUMENTS

### Usage Examples:

```bash
/optimize performance @app.js
/optimize security @api/routes/
/optimize "code quality" @lib/utils.py
/optimize memory @components/
/optimize all @src/
/optimize "bundle size" @client/
```

### Optimization Areas:

- `performance` - Speed, memory usage, algorithm efficiency
- `security` - Vulnerabilities, input validation, authentication
- `maintainability` - Code structure, readability, documentation
- `architecture` - Design patterns, separation of concerns
- `memory` - Memory leaks, allocation efficiency
- `bundle size` - Asset optimization, tree shaking
- `all` - Comprehensive optimization analysis

The optimization will include:

- Performance benchmarks and improvement suggestions
- Security vulnerability assessment and fixes
- Code refactoring recommendations
- Architecture improvements
- Best practices implementation
- Before/after code comparisons
- Measurable improvements with metrics
