---
description: 'Migrate code to new frameworks or versions'
---

## Context

- Current framework version: !`cat package.json 2>/dev/null | grep -E '"(react|vue|angular|express)"' || cat requirements.txt 2>/dev/null | head -3 || echo "Framework detection failed"`
- Node.js version: !`node --version 2>/dev/null || echo "Node.js not found"`
- Python version: !`python --version 2>/dev/null || python3 --version 2>/dev/null || echo "Python not found"`
- Package manager: !`which npm 2>/dev/null && echo "npm" || which yarn 2>/dev/null && echo "yarn" || which pip 2>/dev/null && echo "pip" || echo "No package manager found"`

## Target Framework: $1 (required)

Migrate this code to a new framework, library, or version. Provide:

1. **Migration Strategy** - Step-by-step approach for the transition
2. **Compatibility Analysis** - What changes need to be made
3. **Code Transformation** - Updated code using new syntax/patterns
4. **Dependency Updates** - New package.json, requirements.txt, etc.
5. **Configuration Changes** - Updated config files for new version
6. **Breaking Changes** - Handle API changes and deprecated features
7. **Testing Strategy** - How to validate the migration

## Target Version: $2 (required)

$ARGUMENTS

### Usage Examples:

```bash
/migrate react 18
/migrate "node.js" 20
/migrate python 3.12
/migrate vue 3
/migrate "next.js" 14
/migrate express 4
/migrate typescript 5
```

### Common Migration Targets:

- `react` - React framework versions
- `vue` - Vue.js framework versions
- `angular` - Angular framework versions
- `node.js` - Node.js runtime versions
- `python` - Python language versions
- `typescript` - TypeScript compiler versions
- `express` - Express.js framework versions
- `next.js` - Next.js framework versions
- `django` - Django framework versions
- `rails` - Ruby on Rails versions

Consider:

- Backward compatibility requirements
- Performance implications
- Learning curve for new patterns
- Documentation updates needed
- Rollback plan if issues arise
- Gradual vs big-bang migration approach

The migration will include detailed steps, code changes, and validation procedures for moving from your current setup to the specified target.
