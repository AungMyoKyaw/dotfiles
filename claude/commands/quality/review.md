---
description: 'Comprehensive code review with security, performance, and architectural analysis'
argument-hint: '[language] [review-depth] [@target-file-or-directory]'
---

## Context

- Target: $ARGUMENTS
- Language detected: $1 (auto-detected if not specified)
- Review depth: $2 (default: advanced)
- Files to analyze: !`find . -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.java" -o -name "*.go" -o -name "*.rs" -o -name "*.cpp" -o -name "*.c" | wc -l` files found

## Code Review: $1 (default: auto-detect)

Perform comprehensive code review covering:

1. **Security Analysis** for vulnerabilities and threats
2. **Performance Review** for optimization opportunities
3. **Architecture Assessment** for design patterns and structure
4. **Code Quality** for maintainability and best practices
5. **Bug Detection** for potential runtime errors
6. **Standards Compliance** for language/framework conventions

## Review Depth: $2 (default: advanced)

$ARGUMENTS

### Usage Examples:

```bash
/review python @src/utils.py
/review javascript advanced @frontend/
/review security @api/authentication.js
/review performance expert @algorithms/
/review comprehensive @src/
/review typescript @components/Button.tsx
```

### Review Depths:

- `standard` - Basic functionality and style checks
- `advanced` - Comprehensive security, performance, and architecture review
- `expert` - Deep analysis with adversarial thinking and optimization
- `comprehensive` - Complete review with future-proofing and maintainability focus

### Language Support:

- `python` - Python code review with PEP 8 and security best practices
- `javascript` - Modern JavaScript (ES6+) with Node.js/browser patterns
- `typescript` - TypeScript with type safety and advanced patterns
- `java` - Java with Spring/enterprise patterns and JVM optimizations
- `go` - Go with concurrency patterns and idiomatic code
- `rust` - Rust with memory safety and performance optimizations
- `cpp/c` - C++/C with memory management and modern practices
- `auto` - Automatically detect language from file extension

### Review Categories:

**🔒 Security Analysis:**

- Authentication and authorization flaws
- Input validation and sanitization
- Data encryption and secure storage
- API security vulnerabilities
- Dependency security scanning

**⚡ Performance Review:**

- Algorithm complexity analysis
- Memory usage optimization
- Database query efficiency
- Network request optimization
- Resource management

**🏗️ Architecture Assessment:**

- Design pattern identification
- SOLID principles compliance
- Coupling and cohesion analysis
- Scalability evaluation
- Code organization review

**✨ Code Quality:**

- Readability and clarity
- Documentation completeness
- Error handling robustness
- Testing coverage gaps
- Maintainability scoring

**🐛 Bug Detection:**

- Null pointer exceptions
- Race conditions
- Resource leaks
- Logic errors
- Edge case handling

### Review Output Format:

**🔍 CRITICAL ISSUES**

- Security vulnerabilities
- Runtime errors
- Performance bottlenecks

**⚠️ IMPORTANT ISSUES**

- Code quality concerns
- Architecture improvements
- Maintainability issues

**💡 ENHANCEMENTS**

- Optimization opportunities
- Modernization suggestions
- Best practice implementations

### Specialized Reviews:

- `/review security [language] @target` - Security-focused review
- `/review performance [language] @target` - Performance optimization review
- `/review architecture [language] @target` - Design patterns and structure review
- `/review compliance [language] @target` - Standards and conventions review

The review includes:

- Detailed issue explanations with severity levels
- Actionable improvement recommendations
- Code examples for fixes
- Best practice documentation
- Security vulnerability references
- Performance benchmarking suggestions
- Future-proofing recommendations

Focus on providing constructive, educational feedback that helps developers improve their skills while ensuring code quality, security, and maintainability.
