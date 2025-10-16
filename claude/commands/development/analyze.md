---
description: 'Analyze code architecture and provide insights'
argument-hint: '[focus-area] [@file-or-directory]'
---

## Context

- Current project structure: !`find . -type f -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.go" -o -name "*.java" -o -name "*.rb" -o -name "*.php" -o -name "*.cpp" -o -name "*.c" -o -name "*.cs" | head -20`
- Git status: !`git status --porcelain`
- Package manager detected: !`ls package.json 2>/dev/null && echo "npm/yarn" || ls requirements.txt 2>/dev/null && echo "pip" || ls Cargo.toml 2>/dev/null && echo "cargo" || ls go.mod 2>/dev/null && echo "go" || echo "unknown"`
- Branch info: !`git branch --show-current 2>/dev/null || echo "not a git repo"`

## Analysis Focus: $1 (default: comprehensive)

Perform comprehensive code analysis including:

1. **Architecture Assessment** - Overall design patterns and structure
2. **Code Quality Metrics** - Complexity, maintainability, technical debt
3. **Dependency Analysis** - Package relationships and potential issues
4. **Security Assessment** - Vulnerabilities and security best practices
5. **Performance Analysis** - Bottlenecks and optimization opportunities
6. **Scalability Evaluation** - How well the code handles growth
7. **Compliance Check** - Industry standards and best practices adherence

## Target Files/Directory: $2 (optional)

$ARGUMENTS

### Usage Examples:

```bash
/analyze performance @src/components/
/analyze security @app/models/user.rb
/analyze architecture
/analyze "code quality" @lib/
```

Provide:

- Detailed analysis report with specific findings
- Visual representations of code structure (when helpful)
- Priority list of issues to address
- Recommendations for improvements
- Estimated effort for addressing key issues
- Risk assessment for current implementation
