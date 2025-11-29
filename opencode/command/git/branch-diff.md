---
description: 'Create new Git-flow branch based on git diff or git diff --cached changes with intelligent naming'
---

## Context

- Branch Type: $1 (feature/release/hotfix, auto-detected if not specified)
- Branch Name: $2 (auto-generated if not specified)
- Changes Source: $3 (unstaged by default, --staged for cached changes)
- Current branch: !`git branch --show-current`
- Modified files: !`git status --porcelain | wc -l` files

## Git-flow Branch Types:

- **feature/\***: New features (branch from develop → merge to develop)
- **release/\***: Prepare releases (branch from develop → merge to master + develop)
- **hotfix/\***: Fix production issues (branch from master → merge to master + develop)

## Git-flow Branch Creation: $1/$2 (default: auto-generate)

Execute intelligent Git-flow branch creation workflow covering:

1. **Branch Type Detection** (feature/release/hotfix based on context)
2. **Source Branch Selection** (develop/master based on branch type)
3. **Diff Analysis** for understanding current changes
4. **Change Classification** for intelligent naming
5. **Branch Name Generation** following Git-flow conventions
6. **Git-flow Branch Creation** with proper source branch
7. **Change Application** for smooth transition
8. **Validation** for successful Git-flow setup

## Changes Source: $3 (default: unstaged)

$ARGUMENTS

### Usage Examples:

```bash
# Auto-detect branch type and generate branch name from unstaged changes
/branch-diff

# Create feature branch (from develop → develop)
/branch-diff feature user-auth

# Create release branch (from develop → master + develop)
/branch-diff release v1.2.0

# Create hotfix branch (from master → master + develop)
/branch-diff hotfix security-patch

# With specific branch name and staged changes
/branch-diff feature api-endpoints --staged

# Auto-detect branch type from current branch context
/branch-diff "" user-profile      # Auto-detects as feature if on develop
/branch-diff "" critical-fix     # Auto-detects as hotfix if on master
```

### Git-flow Branch Naming Patterns:

**🚀 Feature Branches (feature/\*):**

- **Source**: develop
- **Target**: develop
- **Purpose**: New features for upcoming releases

```bash
feature/user-authentication
feature/api-endpoints
feature/ui-components
feature/database-schema
```

**🔧 Release Branches (release/\*):**

- **Source**: develop
- **Target**: master + develop
- **Purpose**: Prepare new production releases

```bash
release/v1.2.0
release/v2.0.0
release/v1.1.5-patch
```

**🚨 Hotfix Branches (hotfix/\*):**

- **Source**: master
- **Target**: master + develop
- **Purpose**: Fix critical production issues

```bash
hotfix/security-patch
hotfix/critical-bug-fix
hotfix/emergency-fix
hotfix/production-issue
```

**📝 Specialized Feature Branches:**

- **Documentation**: `feature/docs-update`
- **Refactoring**: `feature/performance-optimization`
- **Testing**: `feature/test-enhancement`
- **CI/CD**: `feature/cd-pipeline-update`

### Smart Branch Name Generation:

**🧠 Git-flow Intelligent Analysis:**

- Analyze current branch context to determine branch type
- Analyze modified files to determine appropriate Git-flow branch type
- Extract key context from diff content for descriptive naming
- Generate Git-flow compliant branch names automatically
- Follow Git-flow naming conventions and source/target rules

**📂 Git-flow File Pattern Recognition:**

```
Current branch: develop + new feature files → feature/{feature-name}
Current branch: master + critical fix files → hotfix/{fix-name}
Current branch: develop + version bump files → release/{version}
src/components/*    → feature/ui-{component}
src/api/*          → feature/api-{endpoint}
tests/*            → feature/test-{enhancement}
docs/*             → feature/docs-{topic}
config/*           → feature/{config-type}
*.md               → feature/docs-{topic}
*.json             → feature/{config-type}
Dockerfile*        → feature/{config-type}
.github/*          → feature/{ci-update}
```

**🔍 Content Analysis:**

- Function additions/deletions
- Import/export changes
- Configuration modifications
- Test additions/updates
- Documentation enhancements

### Workflow Execution:

**1. Change Detection:**

```bash
# Check for unstaged changes
git status --porcelain
git diff --name-only

# Check for staged changes (if --staged flag)
git diff --cached --name-only
git diff --cached --stat
```

**2. Change Analysis:**

- Identify file types and patterns
- Determine change scope and impact
- Classify changes by type (feature, fix, docs, etc.)
- Extract meaningful keywords from changes

**3. Git-flow Branch Name Generation:**

```bash
# Examples of Git-flow compliant names:
git checkout -b feature/user-authentication
git checkout -b feature/api-endpoints
git checkout -b release/v1.2.0
git checkout -b release/v2.0.0
git checkout -b hotfix/security-patch
git checkout -b hotfix/critical-bug-fix
```

**4. Git-flow Branch Creation Process:**

```bash
# Determine source branch based on branch type
if [[ "$BRANCH_TYPE" == "feature" ]]; then
    SOURCE_BRANCH="develop"
elif [[ "$BRANCH_TYPE" == "release" ]]; then
    SOURCE_BRANCH="develop"
elif [[ "$BRANCH_TYPE" == "hotfix" ]]; then
    SOURCE_BRANCH="master"
fi

# Switch to source branch and create new branch
git checkout $SOURCE_BRANCH
git pull origin $SOURCE_BRANCH
git checkout -b {generated-branch-name}
```

**5. Change Management:**

- Stage changes if using unstaged diff
- Verify changes are properly captured
- Commit changes if needed
- Ensure clean working state

### Advanced Features:

**🎯 Git-flow Smart Detection:**

- Auto-detect Git-flow branch type from context and file changes
- Analyze current branch to determine appropriate branch type
- Infer scope from directory structure and change patterns
- Generate Git-flow compliant names from diff analysis
- Identify feature, release, or hotfix patterns automatically

**📊 Git-flow Change Categorization:**

- Categorize by file type patterns and current branch context
- Assess impact levels and appropriate branch type
- Track change relationships for Git-flow compliance
- Validate branch boundaries and Git-flow rules

**🔄 Git-flow Interactive Mode:**

- Suggest multiple Git-flow compliant branch name options
- Allow manual branch name editing with validation
- Preview changes and Git-flow compliance before branch creation
- Confirm source branch and Git-flow workflow before execution
- Show target branch information for each branch type

**🎯 Git-flow Integration Features:**

- Integration with issue tracking systems
- Automatic issue number inclusion in branch names
- Team prefix/suffix support with Git-flow compliance
- Repository-specific naming conventions
- Git-flow structure validation and setup assistance

### Git-flow Branch Name Examples:

**📁 Git-flow Directory-Based:**

```bash
# From develop branch
src/auth/login.js     → feature/auth-login-component
api/users/endpoints.js → feature/user-api-endpoints
tests/unit/utils.js   → feature/test-enhancement
docs/api/guide.md     → feature/docs-api-documentation

# From master branch (hotfix)
src/auth/login.js     → hotfix/auth-security-fix
api/users/endpoints.js → hotfix/api-production-bug
```

**🔧 Git-flow Change-Type-Based:**

```bash
# On develop branch
Adding new function   → feature/{functionality}
Fixing bug           → feature/{bug-fix-description}
Refactoring code     → feature/{refactoring-description}
Updating tests       → feature/test-{enhancement}

# On master branch
Critical production fix → hotfix/{critical-issue-description}
Security vulnerability → hotfix/security-{vulnerability}
Emergency patch        → hotfix/emergency-{fix-description}
```

**📝 Git-flow Context-Based:**

```bash
# Feature development (from develop)
Database schema update      → feature/database-schema-update
Authentication flow        → feature/user-authentication-flow
Error handling improvement → feature/error-handling-enhancement
Performance optimization  → feature/performance-optimization

# Release preparation (from develop)
Version bump preparation   → release/v{version-number}
Release stabilization     → release/{version}-stabilization
Documentation updates     → release/{version}-documentation

# Hotfix for production (from master)
Production bug fix         → hotfix/{production-bug-description}
Security patch            → hotfix/security-{patch-description}
Emergency fix             → hotfix/emergency-{fix-description}
```

### Git-flow Integration:

**🔀 Standard Git-flow Workflow:**

```bash
# Feature branches (from develop → develop)
git checkout develop
git pull origin develop
git checkout -b feature/{feature-name}

# Release branches (from develop → master + develop)
git checkout develop
git pull origin develop
git checkout -b release/{version}

# Hotfix branches (from master → master + develop)
git checkout master
git pull origin master
git checkout -b hotfix/{fix-name}
```

**🎯 Git-flow Merging Strategy:**

```bash
# Feature branch merge (no fast-forward)
git checkout develop
git merge --no-ff feature/{feature-name}
git branch -d feature/{feature-name}

# Release branch merge (to master and develop)
git checkout master
git merge --no-ff release/{version}
git tag -a {version}

git checkout develop
git merge --no-ff release/{version}
git branch -d release/{version}

# Hotfix branch merge (to master and develop)
git checkout master
git merge --no-ff hotfix/{fix-name}
git tag -a {version}

git checkout develop
git merge --no-ff hotfix/{fix-name}
git branch -d hotfix/{fix-name}
```

**🌿 Alternative Workflows (Optional):**

```bash
# GitHub Flow (simplified for web apps)
git checkout main
git checkout -b feature/{feature-name}

# GitLab Flow (environment-based)
git checkout main
git checkout -b feature/{feature-name}
```

### Validation Rules:

**✅ Git-flow Required Elements:**

- Valid git branch name format
- Git-flow compliant prefix (feature/_, release/_, hotfix/\*)
- Descriptive and meaningful name
- Follow Git-flow conventions
- No invalid characters

**⚠️ Git-flow Quality Checks:**

- Branch name clarity and specificity
- Git-flow compliance validation
- Correct source branch selection
- Appropriate target branch for branch type
- Consistent with Git-flow patterns
- Logical change representation

**🚫 Git-flow Blocking Issues:**

- Invalid branch name characters
- Empty or non-descriptive names
- Conflicts with existing branches
- Non-Git-flow naming conventions
- Incorrect source/target branch selection
- Git-flow structure violations
- Invalid branch type specified

### Specialized Operations:

**🔀 Git-flow Multi-Change Branches:**

- Handle multiple logical changes within Git-flow context
- Group related modifications by branch type
- Maintain branch focus and Git-flow compliance
- Separate unrelated changes into appropriate branch types

**🏷️ Git-flow Issue Integration:**

- Include issue numbers in branch names (feature/ISSUE-123-description)
- Link to tracking systems with Git-flow context
- Follow Git-flow team workflows
- Maintain traceability across branch types

**🔧 Git-flow Setup and Validation:**

- Git-flow structure validation and setup
- Source/target branch availability checks
- Branch protection rule validation
- Multi-target merge strategy guidance

### Git-flow Best Practices:

**📝 Git-flow Naming Guidelines:**

- Use Git-flow compliant prefixes (feature/_, release/_, hotfix/\*)
- Use kebab-case for descriptive branch names
- Keep names descriptive but concise
- Include relevant context and scope
- Follow Git-flow conventions strictly

**🎯 Git-flow Scope Recommendations:**

- Keep branches focused and small within their type
- Use appropriate branch type for the work context
- Include relevant keywords for identification
- Maintain team consistency across Git-flow
- Respect source/target branch relationships

**🔗 Git-flow Integration Features:**

- Issue tracker integration with branch type context
- PR template linking for different branch types
- Release automation for release branches
- Deployment pipeline integration for all branch types
- Automated testing strategy per branch type

### Git-flow Example Workflows:

**🚀 Quick Feature Branch:**

```bash
# On develop branch, make changes to files
git add src/components/NewFeature.js
git add tests/NewFeature.test.js

# Create feature branch automatically
/branch-diff feature new-component

# Result: Creates branch "feature/new-component" from develop with changes
```

**🔧 Bug Fix Feature Branch:**

```bash
# On develop branch, fix bug in existing code
# Edit src/utils/parser.js

# Create feature branch for bug fix
/branch-diff feature parser-validation

# Result: Creates branch "feature/parser-validation" from develop
```

**🚨 Hotfix Branch:**

```bash
# On master branch, fix critical production issue
# Edit src/auth/security.js

# Create hotfix branch automatically
/branch-diff hotfix security-patch

# Result: Creates branch "hotfix/security-patch" from master
```

**🔧 Release Branch:**

```bash
# On develop branch, prepare for release
# Edit package.json (version bump), CHANGELOG.md

# Create release branch
/branch-diff release v1.2.0

# Result: Creates branch "release/v1.2.0" from develop
```

**📝 Documentation Feature Branch:**

```bash
# On develop branch, update documentation
# Edit docs/api/endpoints.md

# Create feature docs branch
/branch-diff feature docs-api-update

# Result: Creates branch "feature/docs-api-update" from develop
```

The Git-flow branch creation workflow includes:

- Git-flow compliance validation
- Intelligent branch type detection and naming
- Proper source branch selection and creation
- Change management and staging
- Successful Git-flow branch validation
- Target branch information and guidance

Focus on creating Git-flow compliant, semantic, maintainable branch names that support automated workflows, team collaboration, and effective project management following the established Git-flow branching model.
