---
description: 'Refactor code for better structure and maintainability'
---

## Context

- Code complexity indicators: !`find . -name "*.js" -o -name "*.py" -o -name "*.ts" | xargs wc -l 2>/dev/null | tail -1 || echo "No code files found"`
- Duplicate patterns: !`find . -name "*.js" -o -name "*.py" | head -5 | xargs grep -n "function\|def\|class" 2>/dev/null | head -10 || echo "No functions found"`
- Current git status: !`git status --porcelain 2>/dev/null | head -5 || echo "Not a git repo"`

## Refactoring Pattern: $1 (default: comprehensive)

Refactor this code to improve:

- **Code organization** and structure
- **Readability** and clarity
- **Maintainability** and extensibility
- **Performance** where applicable
- **Design patterns** implementation
- **Naming conventions** and consistency

## Target File: $2 (optional - use @filename)

$ARGUMENTS

### Usage Examples:

```bash
/refactor "extract function" @utils.js
/refactor "reduce duplication" @components/Button.jsx
/refactor "improve naming" @models/user.py
/refactor "solid principles" @services/api.js
/refactor all @src/
/refactor "design patterns" @controllers/
```

### Refactoring Patterns:

- `extract function` - Extract reusable functions from complex code
- `reduce duplication` - Eliminate repeated code patterns
- `improve naming` - Better variable and function names
- `solid principles` - Apply SOLID design principles
- `design patterns` - Implement appropriate design patterns
- `structure` - Improve overall code organization
- `performance` - Optimize algorithms and data structures
- `documentation` - Add comments and documentation
- `all` - Comprehensive refactoring analysis

Focus on:

1. Extracting reusable functions/components
2. Reducing code duplication
3. Improving variable and function naming
4. Adding proper documentation/comments
5. Applying SOLID principles
6. Optimizing algorithms and data structures
7. Ensuring consistent code style

Provide the refactored code with explanations of key changes made, including:

- Before/after code comparisons
- Reasoning behind each refactoring decision
- Impact on code quality metrics
- Performance improvements (if applicable)
- Maintainability enhancements
