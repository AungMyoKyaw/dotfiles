---
description: 'Generate comprehensive documentation for code'
argument-hint: '[doc-type] [@source-files]'
---

## Context

- Project structure: !`find . -maxdepth 2 -type d | head -10`
- Main entry points: !`find . -name "index.*" -o -name "main.*" -o -name "app.*" | head -5`
- Existing docs: !`find . -name "*.md" -o -name "README*" -o -name "CHANGELOG*" | head -5`
- Test files: !`find . -name "*test*" -o -name "*spec*" | head -5`

## Documentation Type: $1 (default: all)

Generate comprehensive documentation for this code including:

1. **API Documentation** - Function signatures, parameters, return values
2. **README.md** - Project overview, installation, usage examples
3. **Code Comments** - Inline documentation for complex logic
4. **Architecture Overview** - System design and component relationships
5. **Setup Instructions** - Development environment configuration
6. **Contributing Guidelines** - How to contribute to the project
7. **Examples and Tutorials** - Practical usage examples

## Source Files: $2 (optional - use @filename)

$ARGUMENTS

### Usage Examples:

```bash
/docs api @src/components/
/docs readme @package.json
/docs architecture @server.js
/docs "inline comments" @lib/utils.py
/docs all @src/
/docs tutorial @examples/
```

### Documentation Types:

- `api` - API reference documentation
- `readme` - Project README and overview
- `architecture` - System design and architecture docs
- `setup` - Installation and setup guides
- `contributing` - Contribution guidelines
- `tutorial` - Tutorial and example content
- `inline` - Inline code comments
- `all` - Complete documentation suite

Documentation should be:

- Clear and concise
- Targeted at the appropriate audience
- Include code examples
- Cover edge cases and error handling
- Follow documentation best practices for the technology stack

When using @source-files, the documentation will focus specifically on those files and their related components.
