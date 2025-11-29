---
description: 'Create Azure DevOps pull request from current branch to development using Azure CLI'
---

## Context

- Title: $1 (auto-generated from branch name if not provided)
- Description: $2 (auto-generated from git log if not provided)
- Reviewers: $3+ (optional reviewers to add)
- Current branch: !`git branch --show-current`
- Target branch: development
- Repository: !`git remote get-url origin --push | sed 's/.*:\(.*\)\.git/\1/'`

## Azure DevOps PR: $1 (default: auto-generate)

Execute complete Azure DevOps PR workflow covering:

1. **Repository Analysis** for understanding current git state
2. **Branch Validation** to ensure proper source and target branches
3. **Content Generation** for title and description from git history
4. **PR Creation** using Azure DevOps CLI with proper configuration
5. **Reviewer Assignment** for team collaboration
6. **Validation** for successful PR creation

## Description: $2 (default: auto-generate)

$ARGUMENTS

### Usage Examples:

```bash
/az-pr "Add user authentication" "Implement OAuth2 login with JWT tokens"
/az-pr "Fix login bug" "Resolve authentication timeout issue"
/az-pr "API refactoring" "Optimize database queries and improve response times"
/az-pr "Update dependencies" "Bump all packages to latest stable versions"
/az-pr "Add unit tests" "Comprehensive test coverage for user service"
/az-pr "Hotfix: Critical security patch" "Fix SQL injection vulnerability in user profile"
/az-pr "Feature: Payment gateway" "Integrate Stripe payment processing"
/az-pr "Code review improvements" "Address feedback from PR #123"
```

### PR Types:

**🎯 Feature PRs:**

- `feat` - New features and functionality
- `feat(scope)` - Scoped feature additions
- `feature` - Full feature implementation
- `enhancement` - Feature enhancements

**🐛 Bug Fix PRs:**

- `fix` - Bug corrections and fixes
- `hotfix` - Critical bug fixes
- `bugfix` - General bug resolutions
- `patch` - Small fixes and patches

**🔧 Infrastructure PRs:**

- `refactor` - Code refactoring and cleanup
- `perf` - Performance improvements
- `build` - Build system changes
- `deps` - Dependency updates

**📝 Documentation PRs:**

- `docs` - Documentation updates
- `readme` - README improvements
- `changelog` - Version history updates

**🧪 Testing PRs:**

- `test` - Adding or improving tests
- `ci` - CI/CD improvements
- `coverage` - Test coverage improvements

### Reviewers:

**Development Team:**

- `@team-lead` - Development team lead
- `@senior-dev` - Senior developer review
- `@backend-dev` - Backend specialist
- `@frontend-dev` - Frontend specialist

**Quality Assurance:**

- `@qa-team` - QA team review
- `@test-engineer` - Test engineer review
- `@security-reviewer` - Security specialist

**Infrastructure:**

- `@devops` - DevOps team review
- `@sysadmin` - System administrator
- `@architecture` - Architecture team

**Multiple Reviewers:**

```bash
/az-pr "Feature update" "Description" @team-lead @senior-dev @qa-team
```

### PR Content Generation:

**Auto-Generated Title:**

- Extract from branch name using conventional commit format
- Convert kebab-case to readable title
- Include scope if available
- Default to "Branch merge: [branch-name]" if no format detected

**Auto-Generated Description:**

- Recent commit messages (last 5-10 commits)
- Changed files summary
- Git diff statistics
- Default template if no commits found

**Title Examples:**

```bash
# From branch: feature/user-authentication
Title: "feat(auth): Add user authentication"

# From branch: fix/login-bug
Title: "fix: Resolve login timeout issue"

# From branch: refactor/api-performance
Title: "refactor(perf): Optimize API response times"

# From branch: hotfix/security-patch
Title: "hotfix: Fix critical security vulnerability"
```

### Workflow Execution:

**1. Repository Validation:**

- Check git repository status
- Verify current branch is not development/main
- Validate remote connection to Azure DevOps
- Check for uncommitted changes

**2. Branch Analysis:**

- Extract source branch name
- Validate target branch (development)
- Check if branches exist on remote
- Analyze commit differences

**3. Content Generation:**

- Generate title from branch name or use provided title
- Create description from recent commits or use provided description
- Calculate changed files and statistics
- Format PR description with markdown

**4. Azure DevOps Integration:**

- Execute `az repos pr create` with generated content
- Add specified reviewers
- Set appropriate labels and tags
- Configure PR settings

**5. Post-Creation Actions:**

- Open PR in browser (optional)
- Display PR URL and details
- Show next steps for review process
- Validate successful creation

### Azure DevOps CLI Command:

```bash
az repos pr create \
  --repository "$(basename -s .git $(git remote get-url origin))" \
  --source-branch "$(git branch --show-current)" \
  --target-branch "development" \
  --title "$PR_TITLE" \
  --description "$PR_DESCRIPTION" \
  --reviewers $REVIEWERS \
  --open \
  --detect true
```

### Command Options:

**🔧 Basic Options:**

- `--title` - PR title (auto-generated if not provided)
- `--description` - PR description (auto-generated if not provided)
- `--source-branch` - Source branch (auto-detected)
- `--target-branch` - Target branch (defaults to development)
- `--repository` - Repository name (auto-detected)

**👥 Collaboration Options:**

- `--reviewers` - Required reviewers
- `--optional-reviewers` - Optional reviewers
- `--labels` - PR labels
- `--work-items` - Link work items

**⚙️ Advanced Options:**

- `--draft` - Create as draft PR
- `--delete-source-branch` - Auto-delete source branch after merge
- `--squash` - Squash commits when merging
- `--auto-complete` - Auto-complete when policies pass

### Error Handling:

**🚫 Common Issues:**

- **Authentication failed**: Check Azure CLI login and PAT
- **Branch not found**: Ensure branches are pushed to remote
- **Permission denied**: Verify repository access permissions
- **Invalid reviewers**: Check reviewer email addresses exist

**🔧 Resolution Steps:**

1. Verify Azure CLI authentication: !`az account show`
2. Check remote configuration: !`git remote -v`
3. Validate branch existence: !`git branch -r`
4. Test reviewer access: Azure DevOps user directory

### Advanced Features:

**🔍 Smart Detection:**

- Auto-detect repository from git remote
- Extract project information from Azure DevOps URL
- Generate conventional commit titles
- Create structured descriptions from git history

**📊 PR Analytics:**

- Calculate commit count and diff statistics
- Identify affected files and directories
- Generate change summary by category
- Estimate review complexity

**🔄 Integration Features:**

- Link to Azure DevOps work items
- Add automatic labels based on changes
- Set appropriate reviewers by file types
- Configure branch protection rules

**🎯 Quality Assurance:**

- Validate PR title format
- Check description completeness
- Verify reviewer assignments
- Ensure compliance with team standards

### Best Practices:

**📝 PR Guidelines:**

- Use clear, descriptive titles
- Provide comprehensive descriptions
- Include testing instructions
- Reference related issues/tickets

**🔗 Integration Tips:**

- Link Azure DevOps work items
- Use appropriate labels for categorization
- Set required reviewers for quality gates
- Configure auto-complete settings

**🎯 Review Process:**

- Assign relevant reviewers based on changes
- Provide clear testing instructions
- Include before/after comparisons
- Document breaking changes

The Azure DevOps PR workflow includes:

- Complete repository validation and analysis
- Intelligent content generation from git history
- Proper Azure DevOps CLI integration
- Team collaboration features
- Comprehensive error handling and validation

Focus on creating high-quality pull requests that enable effective code review, team collaboration, and seamless integration with Azure DevOps workflows.
