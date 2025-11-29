---
description: 'Debug and troubleshoot code issues'
---

## Context

- Recent error logs: !`find . -name "*.log" -exec tail -10 {} \; 2>/dev/null | head -20 || echo "No log files found"`
- Test failures: !`find . -name "*.test.*" -o -name "*test*" | head -5`
- Recent changes: !`git log --oneline -5 2>/dev/null || echo "Not a git repository"`

## Error Type Focus: $1 (default: all)

Debug and troubleshoot issues in this code. Analyze:

1. **Error Identification** - Locate syntax, runtime, and logic errors
2. **Root Cause Analysis** - Understand why issues occur
3. **Performance Bottlenecks** - Identify slow operations and memory leaks
4. **Logic Flaws** - Find incorrect reasoning or algorithmic issues
5. **Edge Cases** - Handle unusual inputs or conditions
6. **Concurrency Issues** - Race conditions, deadlocks, synchronization problems
7. **Integration Problems** - Issues with external dependencies or APIs

## Target Files/Pattern: $2 (optional)

$ARGUMENTS

### Usage Examples:

```bash
/debug "runtime error" @src/api.js
/debug "memory leak" @app/models/
/debug syntax @lib/utils.py
/debug "concurrency issue"
/debug performance @server.js
```

### Common Error Types:

- `syntax` - Syntax errors and typos
- `runtime` - Runtime exceptions and crashes
- `logic` - Logical flaws and incorrect algorithms
- `performance` - Slow operations and bottlenecks
- `memory` - Memory leaks and allocation issues
- `concurrency` - Race conditions and deadlocks
- `integration` - API and dependency issues

Provide:

- Clear explanation of each issue found
- Step-by-step debugging process
- Fixed code with corrections
- Prevention strategies for similar issues
- Testing recommendations to verify fixes
