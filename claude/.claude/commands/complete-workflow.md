---
description: 'Complete Git-flow workflow: branch creation, git commit, and Azure DevOps PR in one command'
argument-hint: '[branch-type] [branch-name] [commit-type] [commit-scope] [commit-description] [pr-title] [pr-description] [reviewers...]'
---

## Context

- Branch Type: $1 (feature/release/hotfix, auto-detected if not specified)
- Branch Name: $2 (auto-generated if not specified)
- Commit Type: $3 (auto-detected if not specified)
- Commit Scope: $4 (auto-detected from files if not specified)
- Commit Description: $5 (auto-generated from changes if not specified)
- PR Title: $6 (auto-generated from commit if not specified)
- PR Description: $7 (auto-generated from git history if not specified)
- Reviewers: $8+ (optional reviewers to add)
- Current branch: !`git branch --show-current`
- Modified files: !`git status --porcelain | wc -l` files

## Git-flow Branch Types:

- **main/master**: Production-ready state (never commit directly)
- **develop**: Integration branch for next release
- **feature/\***: New features for upcoming releases (branch from develop)
- **release/\***: Prepare new production release (branch from develop)
- **hotfix/\***: Fix critical production issues (branch from master)

## Complete Git-flow Workflow: Intelligent Analysis → $BRANCH_TYPE/$BRANCH_NAME → $COMMIT_TYPE($COMMIT_SCOPE): $commit_description

Execute complete Git-flow development lifecycle covering:

1. **Intelligent Change Analysis** (git diff/staged changes → branch type, scope, and commit details)
2. **Git-flow Branch Creation** using descriptive names derived from actual changes
3. **Conventional Commit Generation** based on file patterns and diff analysis
4. **Target Branch Selection** (develop for features, master+develop for releases/hotfixes)
5. **Azure DevOps PR** with comprehensive content generation
6. **Team Collaboration** through automatic reviewer assignment
7. **Workflow Validation** ensuring successful completion at each step

### 🧠 Intelligent Analysis Features:

**Automatic Detection from Git Changes:**

- **Branch Type**: Security files → hotfix, Tests → feature, Docs → feature, Code → feature
- **Branch Names**: `<scope>-<file-name>` format from actual changed files
- **Commit Type**: feat/fix/docs/test/chore based on file patterns
- **Commit Scope**: Primary directory affected by changes
- **Commit Description**: Generated from diff analysis (additions, deletions, patterns)
- **Breaking Changes**: Detected from diff content (break/remove/delete keywords)

## PR Details: $6 / $7 (default: auto-generate)

$ARGUMENTS

### Usage Examples:

```bash
# Complete workflow with intelligent auto-generation from git changes
/complete-workflow
# Result: Analyzes changed files → creates feature/auth-service-login → commits "feat(auth): add authentication functionality"

# Feature branch workflow with custom details
/complete-workflow feat api "add user authentication endpoints"
# Result: Creates feature/api-auth → commits "feat(api): add user authentication endpoints"

# Security hotfix (auto-detected from security-related files)
# If you changed: src/auth/security.js, config/tokens.json
/complete-workflow
# Result: Creates hotfix/security-tokens → commits "fix(security): resolve authentication vulnerability!"

# Documentation updates (auto-detected from .md files)
# If you changed: README.md, docs/api.md
/complete-workflow
# Result: Creates feature/docs-readme → commits "docs(readme): update documentation"

# Test improvements (auto-detected from .spec/.test files)
# If you changed: tests/user.test.js, src/auth.js
/complete-workflow
# Result: Creates feature/auth-user → commits "test(auth): add authentication tests"

# Configuration changes (auto-detected from .json/.yaml files)
# If you changed: package.json, docker-compose.yml
/complete-workflow
# Result: Creates feature/config-package → commits "chore(config): update configuration"

# Release branch workflow
/complete-workflow release v1.2.0 chore "bump version to 1.2.0"
# Result: Creates release/v1.2.0 → commits "chore(): bump version to 1.2.0"

# Full specification with custom commit details
/complete-workflow feature user-profile feat profile "implement user profile management" "User Profile Feature" "Add CRUD operations for user profiles with avatar upload" @team-lead @frontend-dev @backend-dev

# Multi-directory changes (auto-detects primary scope)
# If you changed: src/components/Header.jsx, src/styles/header.css, src/utils/helpers.js
/complete-workflow
# Result: Creates feature/src-header → commits "feat(src): add header component functionality"
```

### 📊 Intelligent Analysis Examples:

**Scenario 1 - Security Fix:**

```
Changed files:
- src/auth/security.js
- config/auth-tokens.json
- tests/security.test.js

Auto-generated result:
- Branch Type: hotfix (security files detected)
- Branch Name: hotfix/security-auth
- Commit Message: fix(security)!: resolve authentication vulnerability
- Target: master + develop
```

**Scenario 2 - New Feature:**

```
Changed files:
- src/api/payment.js
- src/utils/stripe-helper.js
- docs/payment-api.md

Auto-generated result:
- Branch Type: feature
- Branch Name: feature/src-payment
- Commit Message: feat(src): implement payment functionality
- Target: develop
```

**Scenario 3 - Documentation:**

```
Changed files:
- README.md
- docs/getting-started.md
- CONTRIBUTING.md

Auto-generated result:
- Branch Type: feature
- Branch Name: feature/docs-readme
- Commit Message: docs(readme): comprehensive documentation update
- Target: develop
```

### Workflow Integration:

**🔄 Git-flow Sequential Execution:**

The workflow intelligently follows Git-flow principles:

1. **Branch Type Detection & Source Selection**
   - Analyze current context and base branch
   - Determine branch type: feature (from develop), release (from develop), hotfix (from master)
   - Select appropriate source branch automatically
   - Validate repository state for Git-flow compliance

2. **Branch Creation** (`/branch-diff`)
   - Generate Git-flow compliant branch name (feature/_, release/_, hotfix/\*)
   - Create and switch to new branch from correct source
   - Apply changes to new branch
   - Verify branch creation success

3. **Git Commit** (`/commit`)
   - Stage changes logically
   - Generate conventional commit message
   - Execute commit with proper formatting
   - Validate successful commit

4. **Target Branch PR Creation** (`/az-pr`)
   - Push branch to remote
   - Determine correct target branch (develop for features, master for releases/hotfixes)
   - Generate PR title and description with Git-flow context
   - Create pull request with reviewers
   - For releases/hotfixes: handle merging to multiple targets

**🎯 Git-flow Context Sharing:**

- Branch type determines source and target branches
- Branch name follows Git-flow conventions
- Commit message influences PR title/description
- File analysis informs both commit and PR content
- Reviewers assigned based on branch type and file changes
- Automatic handling of multi-target merges for releases/hotfixes

### Intelligent Parameter Handling:

**🔧 Git-flow Auto-Detection Features:**

```bash
# Auto-detect branch type and everything from current changes
/complete-workflow

# Auto-detect commit details, specify branch type and name
/complete-workflow feature user-profile

# Auto-detect PR details, specify commit
/complete-workflow feature api feat "add user endpoints"

# Create release branch with version
/complete-workflow release v1.2.0

# Create hotfix branch for production issue
/complete-workflow hotfix security-patch
```

**📊 Git-flow Smart Defaults:**

- **Branch Type**: Auto-detected from file patterns (security→hotfix, tests→feature, docs→feature, code→feature)
- **Branch Name**: `<branch-type>/<scope>-<file-name>` derived from actual changed files
- **Source Branch**: develop for features/releases, master for hotfixes
- **Target Branch**: develop for features, master for releases/hotfixes
- **Commit Type**: Analyzed from file extensions and patterns (feat/fix/docs/test/chore)
- **Commit Scope**: Primary directory affected by changes
- **Commit Description**: Generated from diff analysis (additions, deletions, content patterns)
- **Breaking Changes**: Detected from diff keywords (break, remove, delete, breaking)
- **PR Title**: Derived from generated commit message
- **PR Description**: Built from git history and change analysis
- **Reviewers**: Suggested based on branch type and file changes

### 🔍 Intelligent Analysis Algorithm:

The workflow uses a sophisticated analysis engine that examines your actual git changes:

**File Pattern Detection:**

```bash
# Security files → hotfix
grep -E '(auth|security|password|token|key|cert)' → hotfix

# Test files → test commits
grep -E '\.(spec|test)\.' → test commits

# Documentation files → docs commits
grep -E '\.(md|txt|doc|pdf)' → docs commits

# Configuration files → chore commits
grep -E '\.(json|yaml|yml|toml|ini|conf)' → chore commits

# Code files → feature commits
grep -E '\.(js|ts|py|java|cpp|c|go|rs|php|rb)' → feat commits
```

**Branch Name Generation:**

```bash
# Format: <type>/<scope>-<descriptor>
# Examples:
#   - src/auth/login.js → feature/auth-login
#   - docs/api.md → feature/docs-api
#   - config/package.json → feature/config-package
#   - tests/user.test.js → feature/test-user
```

**Commit Message Logic:**

```bash
# Analyze diff content:
additions=$(git diff | grep "^+" | wc -l)
deletions=$(git diff | grep "^-" | wc -l)
total_changes=$((additions + deletions))

# Generate description based on patterns:
if [[ $total_changes -lt 50 ]]; then
    description="add $scope functionality"
elif [[ breaking_change_detected ]]; then
    description="!: breaking change to $scope"
else
    description="implement $scope feature"
fi
```

**Breaking Change Detection:**

```bash
# Scan diff for breaking indicators:
git diff | grep -qi "break\|remove\|delete.*function\|breaking"
```

### Workflow Patterns:

**🚀 Feature Branch Workflow:**

```bash
# Quick feature branch (from develop → develop)
/complete-workflow feature new-feature

# Detailed feature development
/complete-workflow feature user-auth feat auth "implement OAuth2" "User Authentication" "Add OAuth2 login with Google and GitHub providers" @team-lead @security-reviewer
```

**🐛 Bug Fix Workflow:**

```bash
# Quick bug fix on feature branch
/complete-workflow feature fix-auth-timeout fix auth "resolve authentication timeout" "Fix: Login timeout issue" "Increase authentication timeout from 15 to 30 seconds" @backend-dev @qa-team
```

**🔧 Release Branch Workflow:**

```bash
# Create release branch (from develop → master + develop)
/complete-workflow release v1.2.0

# Detailed release preparation
/complete-workflow release v2.0.0 chore release "prepare major release" "Release: Version 2.0.0" "Major release with new features and breaking changes" @release-manager @qa-team
```

**🚨 Hotfix Branch Workflow:**

```bash
# Quick hotfix (from master → master + develop)
/complete-workflow hotfix security-patch

# Detailed hotfix for production issue
/complete-workflow hotfix critical-fix fix security "resolve authentication bypass" "Fix: Security vulnerability" "Patch critical authentication bypass vulnerability in production" @security-team @devops
```

**📝 Documentation Workflow:**

```bash
# Documentation updates on feature branch
/complete-workflow feature docs-update docs api "update endpoint documentation" "Docs: API documentation refresh" "Update all API endpoint docs with new parameters and examples" @technical-writer @team-lead
```

### Advanced Workflow Features:

**🔍 Context-Aware Processing:**

- **File Type Analysis**: Determine commit type from modified files
- **Directory Structure**: Infer scope from affected directories
- **Change Patterns**: Classify changes (addition, modification, deletion)
- **Impact Assessment**: Estimate review complexity and required expertise

**🎯 Git-flow Smart Reviewer Assignment:**

```bash
# Automatic reviewer suggestions based on branch type and changes:

Feature branches:
- Frontend changes → @frontend-dev, @ui-designer
- Backend API changes → @backend-dev, @api-specialist
- Database changes → @backend-dev, @database-admin
- Security changes → @security-reviewer, @team-lead
- Test changes → @qa-team, @test-engineer

Release branches:
- Version bumps → @release-manager, @team-lead
- Release preparation → @devops, @qa-team
- Documentation updates → @technical-writer, @release-manager

Hotfix branches:
- Production fixes → @oncall-engineer, @devops, @security-team
- Critical security issues → @security-team, @team-lead
- Database hotfixes → @database-admin, @backend-dev

All branches:
- Documentation → @technical-writer, @team-lead
```

**🔄 Git-flow Error Recovery:**

- **Branch Conflicts**: Automatic conflict resolution strategies with Git-flow awareness
- **Source Branch Validation**: Ensure correct source branch (develop/master) before branching
- **Target Branch Validation**: Verify correct target branch for PR creation
- **Commit Failures**: Intelligent staging retry mechanisms
- **Multi-target Merge Failures**: Handle releases/hotfixes merging to multiple targets
- **PR Creation Failures**: Alternative approaches and troubleshooting
- **Network Issues**: Automatic retry with exponential backoff
- **Git-flow Violations**: Detect and prevent incorrect branch workflows

**⚡ Performance Optimizations:**

- **Parallel Processing**: Non‑parallel operations where possible
- **Caching**: Store analysis results between workflow steps
- **Incremental Updates**: Only re‑analyze changed components
- **Batch Operations**: Group related operations for efficiency

### Workflow Execution Steps:

**Step 1: Repository Analysis**

```bash
# Analyze current state
git status --porcelain
git diff --name-only
git diff --stat

# Classify changes and determine approach
```

**Step 2: Git-flow Branch Creation**

```bash
# Generate intelligent branch name from diff content analysis
generate_intelligent_branch_name() {
    local branch_name=""
    local content_themes=()
    local primary_theme=""
    local secondary_themes=()

    # Get diff content for analysis
    if [[ -n "$(git diff --cached --name-only)" ]]; then
        DIFF_CONTENT=$(git diff --cached)
    else
        DIFF_CONTENT=$(git diff)
    fi

    # Extract and analyze diff content themes
    # Look for repeated keywords, patterns, and concepts in the changes

    # 1. Analyze added lines for key themes
    local added_lines=$(echo "$DIFF_CONTENT" | grep "^+" | grep -v "^+++" | head -50)

    # 2. Look for command/tool references
    if echo "$added_lines" | grep -qi "azure\|az pr\|devops\|pull request"; then
        content_themes+=("azure-devops")
    fi

    if echo "$added_lines" | grep -qi "git-flow\|workflow\|branch.*creation\|complete.*workflow"; then
        content_themes+=("gitflow-workflows")
    fi

    if echo "$added_lines" | grep -qi "claude.*command\|slash.*command\|@claude"; then
        content_themes+=("claude-commands")
    fi

    if echo "$added_lines" | grep -qi "branch.*diff\|git.*diff\|changes.*analysis"; then
        content_themes+=("branch-analysis")
    fi

    # 3. Look for file type patterns in diff
    local new_files=$(echo "$DIFF_CONTENT" | grep "^index 0000000" -A 1 | grep "^+++" | sed 's|^+++ b/||')

    # 4. Analyze directory structure from new files
    if echo "$new_files" | grep -q "claude.*commands"; then
        content_themes+=("claude-commands")
    fi

    if echo "$new_files" | grep -q "\.md$"; then
        if [[ ${#content_themes[@]} -eq 0 ]]; then
            content_themes+=("documentation")
        fi
    fi

    # 5. Look for configuration changes
    if echo "$added_lines" | grep -qi "config\|settings\|\.json\|\.toml\|\.yaml"; then
        content_themes+=("config-updates")
    fi

    # 6. Analyze function/class mentions in diff
    if echo "$added_lines" | grep -qi "function\|def \|class \|\(\s\)*function"; then
        content_themes+=("code-functions")
    fi

    # 7. Determine primary and secondary themes
    if [[ ${#content_themes[@]} -gt 0 ]]; then
        # Remove duplicates and sort by relevance
        local unique_themes=($(printf "%s\n" "${content_themes[@]}" | sort -u))

        # Set primary theme (most relevant)
        primary_theme="${unique_themes[0]}"

        # Set secondary themes if available
        if [[ ${#unique_themes[@]} -gt 1 ]]; then
            secondary_themes=("${unique_themes[@]:1:2}")
        fi
    fi

    # 8. Generate branch name based on content analysis
    if [[ -n "$primary_theme" ]]; then
        branch_name="$primary_theme"

        # Add secondary themes if they add value
        if [[ ${#secondary_themes[@]} -gt 0 ]]; then
            local secondary=$(IFS=-; echo "${secondary_themes[*]}")
            # Limit total length
            if [[ $((${#branch_name} + ${#secondary} + 1)) -le 40 ]]; then
                branch_name="${branch_name}-${secondary}"
            fi
        fi
    else
        # Fallback: Use enhanced file-based analysis
        local first_file=$(echo "$CHANGED_FILES" | head -1)
        local file_dir=$(dirname "$first_file" | sed 's|^\./||')
        local file_basename=$(basename "$first_file" | sed 's/\.[^.]*$//')

        # Create descriptive name from directory and file
        if [[ -n "$file_dir" && "$file_dir" != "." ]]; then
            branch_name="${file_dir}-${file_basename}"
        else
            branch_name="$file_basename"
        fi
    fi

    # 9. Clean and optimize branch name
    branch_name=$(echo "$branch_name" | tr '[:upper:]' '[:lower:]' | tr ' _' '-' | sed 's/[^a-z0-9-]//g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')

    # 10. Limit length intelligently
    if [[ ${#branch_name} -gt 50 ]]; then
        # Try to preserve meaningful parts
        if [[ "$branch_name" =~ (.+)-(.+)-(.+) ]]; then
            # Keep first two parts if they're meaningful
            local part1="${BASH_REMATCH[1]}"
            local part2="${BASH_REMATCH[2]}"
            local combined="${part1}-${part2}"
            if [[ ${#combined} -le 40 ]]; then
                branch_name="$combined"
            else
                branch_name=$(echo "$branch_name" | cut -c1-40)
            fi
        else
            branch_name=$(echo "$branch_name" | cut -c1-40)
        fi
    fi

    echo "$branch_name"
}

# Analyze git changes to determine branch type and generate intelligent branch name
analyze_git_changes() {
    # Get changed files (staged first, then unstaged)
    STAGED_FILES=$(git diff --cached --name-only 2>/dev/null || true)
    UNSTAGED_FILES=$(git diff --name-only 2>/dev/null || true)
    ALL_CHANGED_FILES="${STAGED_FILES}
${UNSTAGED_FILES}"

    # Remove empty lines and get unique files
    CHANGED_FILES=$(echo "$ALL_CHANGED_FILES" | grep -v '^$' | sort -u)

    if [[ -z "$CHANGED_FILES" ]]; then
        echo "No changes detected. Please stage or make changes first."
        exit 1
    fi

    # Analyze file patterns to determine branch type and generate name
    local branch_type=""
    local branch_name=""
    local commit_type=""
    local commit_scope=""

    # Count file types and directories
    local test_files=$(echo "$CHANGED_FILES" | grep -E '\.(spec|test)\.' | wc -l)
    local doc_files=$(echo "$CHANGED_FILES" | grep -E '\.(md|txt|doc|pdf)' | wc -l)
    local config_files=$(echo "$CHANGED_FILES" | grep -E '\.(json|yaml|yml|toml|ini|conf)' | wc -l)
    local code_files=$(echo "$CHANGED_FILES" | grep -E '\.(js|ts|py|java|cpp|c|go|rs|php|rb)' | wc -l)
    local security_files=$(echo "$CHANGED_FILES" | grep -E '(auth|security|password|token|key|cert)' | wc -l)

    # Determine primary directories affected
    local main_dirs=$(echo "$CHANGED_FILES" | cut -d'/' -f1 | sort -u | tr '\n' ' ' | sed 's/ $//')

    # Detect branch type based on patterns
    if [[ $security_files -gt 0 ]]; then
        branch_type="hotfix"
        commit_type="fix"
        commit_scope="security"
    elif [[ $test_files -gt $(($code_files / 2)) ]]; then
        branch_type="feature"
        commit_type="test"
        commit_scope=$(echo "$main_dirs" | cut -d' ' -f1)
    elif [[ $doc_files -gt $(($code_files / 2)) ]]; then
        branch_type="feature"
        commit_type="docs"
        commit_scope=$(echo "$main_dirs" | cut -d' ' -f1)
    elif [[ $config_files -gt $(($code_files / 2)) ]]; then
        branch_type="feature"
        commit_type="chore"
        commit_scope="config"
    else
        branch_type="feature"
        commit_type="feat"
        commit_scope=$(echo "$main_dirs" | cut -d' ' -f1)
    fi

    # Generate intelligent branch name from diff content analysis
    local intelligent_branch_name=$(generate_intelligent_branch_name)

    # Create final branch name with Git-flow prefix
    local branch_name="${branch_type}/${intelligent_branch_name}"

    # Export variables for use in workflow
    export BRANCH_TYPE="$branch_type"
    export BRANCH_NAME="$branch_name"
    export COMMIT_TYPE="$commit_type"
    export COMMIT_SCOPE="$commit_scope"
    export CHANGED_FILES="$CHANGED_FILES"
    export MAIN_DIRS="$main_dirs"

    echo "🔍 Enhanced Analysis Results:"
    echo "   Branch Type: $branch_type"
    echo "   Branch Name: $branch_name"
    echo "   Content-Based Name: $intelligent_branch_name"
    echo "   Commit Type: $commit_type"
    echo "   Commit Scope: $commit_scope"
    echo "   Changed Files: $(echo "$CHANGED_FILES" | wc -l) files"
    echo "   Main Directories: $main_dirs"
}

# Execute change analysis
analyze_git_changes

# Determine source and target branches based on branch type
if [[ "$BRANCH_TYPE" == "feature" ]]; then
    SOURCE_BRANCH="develop"
    TARGET_BRANCH="develop"
elif [[ "$BRANCH_TYPE" == "release" ]]; then
    SOURCE_BRANCH="develop"
    TARGET_BRANCH="master"
elif [[ "$BRANCH_TYPE" == "hotfix" ]]; then
    SOURCE_BRANCH="master"
    TARGET_BRANCH="master"
fi

# Switch to source branch and create new branch
echo "🔄 Creating branch '$BRANCH_NAME' from '$SOURCE_BRANCH'"
git checkout $SOURCE_BRANCH && git pull origin $SOURCE_BRANCH
git checkout -b $BRANCH_NAME

# Ensure changes are properly applied
git add .
```

**Step 3: Commit Execution**

```bash
# Generate intelligent conventional commit message based on actual changes
generate_commit_message() {
    local commit_type="$COMMIT_TYPE"
    local commit_scope="$COMMIT_SCOPE"
    local commit_description=""
    local commit_body=""
    local breaking_change=""

    # Analyze git diff to generate descriptive commit message
    if [[ -n "$CHANGED_FILES" ]]; then
        # Get diff content for analysis
        if [[ -n "$(git diff --cached --name-only)" ]]; then
            DIFF_CONTENT=$(git diff --cached)
        else
            DIFF_CONTENT=$(git diff)
        fi

        # Analyze diff patterns for better description
        local additions=$(echo "$DIFF_CONTENT" | grep "^+" | wc -l)
        local deletions=$(echo "$DIFF_CONTENT" | grep "^-" | wc -l)
        local total_changes=$((additions + deletions))

        # Detect breaking changes
        if echo "$DIFF_CONTENT" | grep -qi "break\|remove\|delete.*function\|breaking"; then
            breaking_change="!"
        fi

        # Generate description based on changes
        case "$commit_type" in
            "feat")
                if [[ $total_changes -lt 50 ]]; then
                    commit_description="add $commit_scope functionality"
                elif [[ -n "$commit_scope" ]]; then
                    commit_description="implement $commit_scope feature"
                else
                    commit_description="add new functionality"
                fi
                ;;
            "fix")
                if echo "$DIFF_CONTENT" | grep -qi "bug\|error\|issue"; then
                    commit_description="fix $commit_scope bug"
                elif echo "$DIFF_CONTENT" | grep -qi "timeout\|performance\|slow"; then
                    commit_description="improve $commit_scope performance"
                else
                    commit_description="resolve $commit_scope issue"
                fi
                ;;
            "docs")
                if [[ $total_changes -lt 20 ]]; then
                    commit_description="update $commit_scope documentation"
                else
                    commit_description="comprehensive $commit_scope documentation update"
                fi
                ;;
            "test")
                if [[ $total_changes -lt 30 ]]; then
                    commit_description="add $commit_scope tests"
                else
                    commit_description="enhance $commit_scope test coverage"
                fi
                ;;
            "chore")
                if echo "$DIFF_CONTENT" | grep -qi "version\|bump\|release"; then
                    commit_description="bump version"
                elif echo "$DIFF_CONTENT" | grep -qi "dependenc"; then
                    commit_description="update dependencies"
                else
                    commit_description="update $commit_scope configuration"
                fi
                ;;
            *)
                commit_description="update $commit_scope"
                ;;
        esac

        # Generate commit body with detailed information
        if [[ $total_changes -gt 10 ]]; then
            commit_body=$(cat <<EOF

Changes:
- Modified files: $(echo "$CHANGED_FILES" | wc -l | tr -d ' ')
- Additions: $additions lines
- Deletions: $deletions lines
- Affected directories: $MAIN_DIRS

Files changed:
$(echo "$CHANGED_FILES" | sed 's/^/- /')
EOF
)
        fi
    fi

    # Override with user-provided values if available
    if [[ -n "$USER_COMMIT_TYPE" ]]; then
        commit_type="$USER_COMMIT_TYPE"
    fi
    if [[ -n "$USER_COMMIT_SCOPE" ]]; then
        commit_scope="$USER_COMMIT_SCOPE"
    fi
    if [[ -n "$USER_COMMIT_DESCRIPTION" ]]; then
        commit_description="$USER_COMMIT_DESCRIPTION"
    fi

    # Construct conventional commit message
    local commit_msg=""

    # Header: type(scope)!: description
    if [[ -n "$commit_scope" ]]; then
        commit_msg="${commit_type}(${commit_scope})${breaking_change}: ${commit_description}"
    else
        commit_msg="${commit_type}${breaking_change}: ${commit_description}"
    fi

    # Add body if generated
    if [[ -n "$commit_body" ]]; then
        commit_msg="${commit_msg}${commit_body}"
    fi

    # Export for use in workflow
    export GENERATED_COMMIT_MSG="$commit_msg"
    export COMMIT_HEADER="${commit_type}(${commit_scope})${breaking_change}: ${commit_description}"

    echo "📝 Generated Commit Message:"
    echo "   Header: $commit_type(${commit_scope})${breaking_change}: ${commit_description}"
    if [[ -n "$commit_body" ]]; then
        echo "   Body: [Detailed changes included]"
    fi
}

# Stage changes logically based on file patterns
stage_changes_logically() {
    echo "📋 Staging changes..."

    # Stage all changes first
    git add .

    # Get summary of staged changes
    local staged_summary=$(git status --porcelain)
    local staged_files=$(echo "$staged_summary" | grep "^M " | cut -c4-)
    local new_files=$(echo "$staged_summary" | grep "^A " | cut -c4-)
    local deleted_files=$(echo "$staged_summary" | grep "^D " | cut -c4-)

    echo "   Staged files: $(echo "$staged_files" | wc -l | tr -d ' ') modified"
    echo "   New files: $(echo "$new_files" | wc -l | tr -d ' ') added"
    echo "   Deleted files: $(echo "$deleted_files" | wc -l | tr -d ' ') removed"

    # If user provided specific commit details, use them
    if [[ -n "$USER_COMMIT_TYPE" || -n "$USER_COMMIT_SCOPE" || -n "$USER_COMMIT_DESCRIPTION" ]]; then
        export USER_COMMIT_TYPE="$1"
        export USER_COMMIT_SCOPE="$2"
        export USER_COMMIT_DESCRIPTION="$3"
        shift 3
    fi
}

# Execute staging and commit message generation
stage_changes_logically "$@"
generate_commit_message

# Execute commit with generated message
echo "✅ Committing with message:"
echo "$GENERATED_COMMIT_MSG"
echo ""
git commit -m "$GENERATED_COMMIT_MSG"

# Verify commit success
if [[ $? -eq 0 ]]; then
    echo "✅ Commit successful!"
    echo "   Commit hash: $(git rev-parse --short HEAD)"
    echo "   Branch: $BRANCH_NAME"
else
    echo "❌ Commit failed. Please check your changes."
    exit 1
fi
```

**Step 4: Git-flow PR Creation**

```bash
# Push branch to remote
git push -u origin $BRANCH_NAME

# Generate PR content
PR_TITLE=$(generate-pr-title-from-commit)
PR_DESC=$(generate-pr-description-from-history)

# Create Azure DevOps PR with correct target branch
az repos pr create \
  --title "$PR_TITLE" \
  --description "$PR_DESC" \
  --source-branch "$BRANCH_NAME" \
  --target-branch "$TARGET_BRANCH" \
  --reviewers $REVIEWERS \
  --open

# For release and hotfix branches, also merge back to develop
if [[ "$BRANCH_TYPE" == "release" || "$BRANCH_TYPE" == "hotfix" ]]; then
    # Create additional PR to develop branch
    az repos pr create \
      --title "$PR_TITLE (back to develop)" \
      --description "$PR_DESC

This PR includes changes that need to be merged back to develop for the next release." \
      --source-branch "$BRANCH_NAME" \
      --target-branch "develop" \
      --reviewers $REVIEWERS \
      --open
fi
```

### Integration Benefits:

**🎯 Efficiency Gains:**

- **Single Command**: Replace 3 separate commands with 1 integrated workflow
- **Context Preservation**: Share analysis results between workflow steps
- **Intelligent Defaults**: Minimize required parameters while maintaining flexibility
- **Error Reduction**: Automated validation and error handling across all steps

**🔗 Git-flow Consistency Assurance:**

- **Unified Naming**: Branch names follow Git-flow conventions (feature/_, release/_, hotfix/\*)
- **Source/Target Consistency**: Correct source and target branches for each branch type
- **Conventional Compliance**: Maintain standards across all workflow outputs
- **Team Coordination**: Consistent reviewer assignment and notification patterns
- **Quality Gates**: Automated Git-flow compliance checks at each workflow stage
- **Multi-target Handling**: Proper handling of release/hotfix merges to multiple targets

**📊 Workflow Analytics:**

- **Change Tracking**: Monitor workflow success rates and common patterns
- **Team Insights**: Analyze reviewer assignment effectiveness and response times
- **Process Optimization**: Identify bottlenecks and improvement opportunities
- **Quality Metrics**: Track commit message quality and PR completion rates

### Validation and Quality Assurance:

**✅ Git-flow Pre‑Execution Checks:**

- Repository cleanliness validation
- Remote connectivity verification
- Azure CLI authentication check
- Required tool availability confirmation
- Git-flow branch structure validation (main, develop exist)
- Current branch compatibility check
- Source branch availability verification

**✅ Git-flow Step‑by‑Step Validation:**

- Branch type detection accuracy
- Source/Target branch selection validation
- Branch creation success verification
- Git-flow naming convention compliance
- Commit message conventional compliance
- PR creation completion confirmation
- Multi-target PR handling for releases/hotfixes
- Reviewer assignment validation

**✅ Git-flow Post‑Execution Verification:**

- Workflow completion status reporting
- Git-flow compliance verification
- PR URL(s) and next steps provision
- Team notification confirmation
- Integration status validation
- Branch cleanup recommendations

### Troubleshooting Guide:

**🚫 Git-flow Common Issues:**

1. **Git-flow Structure Missing**: Repository lacks main/develop branches - guides setup
2. **Incorrect Source Branch**: Validates and corrects source branch selection
3. **Branch Already Exists**: Workflow suggests alternative Git-flow compliant names
4. **No Changes to Commit**: Guides user to make changes before retrying
5. **Authentication Failures**: Provides Azure CLI setup instructions
6. **Reviewer Not Found**: Suggests alternative reviewers or continues without them
7. **Multi-target PR Conflicts**: Handles release/hotfix branch merge scenarios
8. **Git-flow Violations**: Detects and prevents incorrect workflow patterns

**🔍 Intelligent Analysis Issues:**

1. **No Changes Detected**:
   - **Issue**: `git diff --cached --name-only` and `git diff --name-only` return empty
   - **Solution**: Stage your changes first with `git add .` or make changes to files

2. **Incorrect Branch Type Detection**:
   - **Issue**: Security files not detected as hotfix
   - **Solution**: Manually specify branch type: `/complete-workflow hotfix custom-name`

3. **Poor Branch Name Generation**:
   - **Issue**: Generated branch name is too generic or unclear
   - **Solution**: Provide custom branch name: `/complete-workflow feature my-descriptive-name`

4. **Wrong Commit Type**:
   - **Issue**: Analysis detects wrong commit type for your changes
   - **Solution**: Override with custom commit: `/complete-workflow feat scope "custom description"`

5. **Missing Scope Detection**:
   - **Issue**: Cannot determine appropriate scope from directory structure
   - **Solution**: Specify scope manually: `/complete-workflow feat my-scope "description"`

6. **Breaking Change Not Detected**:
   - **Issue**: Actual breaking change not flagged by automatic detection
   - **Solution**: Add `!` manually in your custom commit description

**🔧 Analysis Debugging:**

To debug the intelligent analysis, you can run these commands manually:

```bash
# Check what files are changed
git diff --cached --name-only  # Staged changes
git diff --name-only           # Unstaged changes

# Verify file pattern detection
git diff --name-only | grep -E '\.(spec|test)\.'    # Test files
git diff --name-only | grep -E '\.(md|txt|doc)'     # Doc files
git diff --name-only | grep -E '(auth|security)'    # Security files

# Check diff statistics
git diff --stat --cached    # Staged changes statistics
git diff --stat            # All changes statistics
```

**🔧 Git-flow Resolution Strategies:**

- **Interactive Mode**: Offer choices when automatic resolution fails
- **Git-flow Setup Assist**: Guide users through proper Git-flow initialization
- **Partial Completion**: Continue workflow steps where possible
- **Rollback Capability**: Clean up partial changes on failure
- **Retry Mechanisms**: Intelligent retry with different approaches
- **Branch Structure Repair**: Automatically fix common Git-flow setup issues
- **Multi-target Merge Assist**: Help with complex release/hotfix scenarios

### Best Practices:

**📝 Git-flow Workflow Guidelines:**

- Use Git-flow compliant branch naming (feature/_, release/_, hotfix/\*)
- Choose correct branch type based on work context
- Review auto‑generated content before submission
- Ensure proper team coordination for reviewer assignment
- Validate workflow completion in your Azure DevOps interface
- Follow Git-flow branching rules (no direct commits to master)

**🎯 Git-flow Team Integration:**

- Establish Git-flow conventions for the team
- Configure reviewer assignment rules based on branch types
- Set up automated notifications for workflow completions
- Monitor workflow analytics for continuous improvement
- Train team on Git-flow principles and workflows
- Configure branch protection rules for main branches

**🔗 Git-flow Tool Integration:**

- Ensure Azure CLI is properly configured and authenticated
- Maintain clean git repository state before workflow execution
- Configure branch protection rules for main and develop branches
- Set up automated testing and validation in CI/CD pipeline
- Configure merge policies for different branch types
- Set up version tagging for releases and hotfixes

The Git-flow complete workflow command provides:

- **Git-flow Compliance**: Full adherence to Git-flow branching model
- **Streamlined Development**: End‑to‑end automation from changes to PR
- **Intelligent Automation**: Smart defaults and context sharing between steps
- **Multi-target Support**: Proper handling of release/hotfix scenarios
- **Team Collaboration**: Automatic reviewer assignment and notification
- **Quality Assurance**: Validation and error handling at each workflow stage
- **Process Efficiency**: Single command execution replacing multiple manual steps

Focus on providing a seamless Git-flow development experience that maintains code quality, team coordination, and operational efficiency while reducing manual overhead and potential errors.
