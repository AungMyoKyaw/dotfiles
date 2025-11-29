---
description: 'Execute git commit with conventional commit message analysis and staging'
---

## Context

- Commit Type: $1 (auto-detected if not specified)
- Scope: $2 (auto-detected from files)
- Description: $3 (auto-generated from changes)
- Current status: !`git status --porcelain | wc -l` files modified

## Conventional Commit: $1 (default: auto-detect)

Execute complete git workflow covering:

1. **Change Analysis** for understanding repository state
2. **File Staging** for organizing logical commits
3. **Commit Type Detection** for conventional compliance
4. **Message Generation** for clear documentation
5. **Git Commit Execution** for version control
6. **Validation** for successful completion

## Scope: $2 (default: auto-detect)

$ARGUMENTS

### Usage Examples:

```bash
/commit feat "add user authentication"
/commit fix "resolve login bug"
/commit refactor "optimize database queries"
/commit docs "update API documentation"
/commit test "add unit tests for utils"
/commit feat auth "implement OAuth2 login"
/commit fix parser "handle edge case parsing"
```

### Commit Types:

**🎯 Feature Commits:**

- `feat` - New features and functionality
- `feat(scope)` - Scoped feature additions
- `feat!` - Breaking feature changes

**🐛 Bug Fixes:**

- `fix` - Bug corrections and fixes
- `fix(scope)` - Scoped bug fixes
- `fix!` - Breaking bug fixes

**📝 Documentation:**

- `docs` - Documentation updates only
- `docs(scope)` - Scoped documentation changes
- `docs(readme)` - README updates

**🎨 Style Changes:**

- `style` - Formatting, whitespace, style changes
- `style(linting)` - Linting fixes
- `style(formatting)` - Code formatting

**🔧 Refactoring:**

- `refactor` - Code refactoring (no feature/bug)
- `refactor(scope)` - Scoped refactoring
- `refactor(performance)` - Performance refactoring

**⚡ Performance:**

- `perf` - Performance improvements
- `perf(scope)` - Scoped performance changes
- `perf(database)` - Database optimizations

**🧪 Testing:**

- `test` - Adding missing tests
- `test(scope)` - Scoped test additions
- `test(unit)` - Unit test additions

**🏗️ Build & Dependencies:**

- `build` - Build system changes
- `deps` - Dependency updates
- `build(tools)` - Build tool changes

**🔄 CI/CD:**

- `ci` - CI configuration changes
- `cd` - Deployment pipeline changes
- `ci(github)` - GitHub Actions changes

**🧹 Maintenance:**

- `chore` - Maintenance tasks
- `chore(deps)` - Dependency updates
- `chore(config)` - Configuration changes

**🔙 Reverts:**

- `revert` - Reverting previous commits
- `revert(scope)` - Scoped reverts

### Scopes:

**Frontend:**

- `ui`, `components`, `views`, `hooks`, `styles`, `assets`

**Backend:**

- `api`, `services`, `models`, `controllers`, `middleware`

**Infrastructure:**

- `db`, `cache`, `queue`, `storage`, `network`

**Development:**

- `build`, `test`, `docs`, `config`, `tools`

### Commit Message Structure:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Examples:**

```bash
# Simple feature
feat(auth): add user login functionality

# Bug fix with scope
fix(parser): handle malformed JSON input

# Feature with breaking change
feat(api)!: remove deprecated endpoints

BREAKING CHANGE: The /v1/users endpoint has been removed

# Complex commit with body
feat(auth): implement OAuth2 authentication

Add Google and GitHub OAuth providers
with token refresh mechanism and
secure session management

Closes #123
```

### Workflow Execution:

**1. Repository Analysis:**

- Check git status and working directory state
- Analyze modified, added, and deleted files
- Review staged and unstaged changes
- Identify change patterns and relationships

**2. Change Classification:**

- Determine commit type from code changes
- Identify affected scope from file paths
- Detect breaking changes and API modifications
- Assess change impact and significance

**3. Intelligent Staging:**

- Group related files logically
- Separate distinct features/fixes
- Handle merge conflicts if needed
- Validate staged changes

**4. Message Generation:**

- Craft conventional commit message
- Include relevant context and details
- Add breaking change notices
- Reference related issues/PRs

**5. Commit Execution:**

- Execute git commit with message
- Verify successful commit
- Update repository state
- Clean working directory

### Advanced Features:

**🔍 Smart Detection:**

- Auto-detect commit type from changes
- Infer scope from file structure
- Generate descriptions from diff analysis
- Identify breaking changes automatically

**📊 Change Analysis:**

- Categorize code modifications
- Assess impact levels
- Track feature relationships
- Validate commit boundaries

**🔄 Batch Operations:**

- Handle multiple logical commits
- Separate unrelated changes
- Maintain commit history quality
- Optimize workflow efficiency

**🎯 Quality Assurance:**

- Conventional compliance validation
- Message clarity assessment
- Historical consistency checks
- Team workflow integration

### Specialized Commits:

**🔀 Merge Commits:**

- Handle merge conflict resolution
- Document merge rationale
- Maintain branch history
- Coordinate team integration

**🏷️ Release Commits:**

- Version bump commits
- Release note generation
- changelog integration
- Tag management

**🔧 Configuration Commits:**

- Environment setup changes
- Tool configuration updates
- Dependency management
- Build system modifications

### Validation Rules:

**✅ Required Elements:**

- Valid commit type
- Descriptive commit message
- Proper scope formatting
- Accurate change representation

**⚠️ Quality Checks:**

- Message clarity and conciseness
- Consistent formatting
- Appropriate commit scope
- Logical file grouping

**🚫 Blocking Issues:**

- Empty commit messages
- Invalid commit types
- Malformed conventional commits
- Uncommitted changes

### Best Practices:

**📝 Message Guidelines:**

- Use present tense ("add" not "added")
- Keep descriptions under 72 characters
- Use imperative mood ("fix bug" not "fixes bug")
- Be specific and descriptive

**🎯 Scope Recommendations:**

- Keep scopes simple and consistent
- Use existing project terminology
- Avoid overly specific scopes
- Maintain team agreement

**🔗 Integration Features:**

- Issue/PR reference linking
- Breaking change documentation
- Co-author attribution
- Commit signature support

The commit workflow includes:

- Complete git status analysis
- Intelligent file staging
- Conventional compliance
- Clear message generation
- Successful commit execution
- Comprehensive validation

Focus on creating clean, maintainable commit history that supports automated tooling, team collaboration, and effective project management.
