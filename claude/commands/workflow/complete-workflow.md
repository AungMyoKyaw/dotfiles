---
description: 'Simple Git workflow: create branch, commit, push, and create PR to development'
argument-hint: '[branch-name] [commit-message]'
---

## Simple Git Workflow with Conventional Commits

Creates a new branch, commits changes following conventional commit standards, pushes to remote, and creates a well-structured pull request to the development branch.

### Usage

```bash
# Quick workflow with auto-generated branch name and conventional commit message
/complete-workflow

# Custom branch name and commit message (auto-converts to conventional commit)
/complete-workflow feature-auth "add user authentication"

# Just branch name (auto-generates conventional commit message)
/complete-workflow bugfix-login

# Just commit message (auto-converts to conventional commit format)
/complete-workflow "fix validation error"

# Using conventional commit format directly
/complete-workflow api "feat(auth): implement JWT token refresh"
```

### What it does

1. **Create new branch** from current branch with meaningful naming
2. **Stage and commit** all changes using conventional commit format
3. **Auto-detect commit type** (feat, fix, docs, style, refactor, test, chore, etc.)
4. **Generate scope** based on changed directories
5. **Push** branch to remote repository
6. **Create comprehensive pull request** with best practices structure

### Conventional Commit Types Supported

- **feat**: New features
- **fix**: Bug fixes
- **docs**: Documentation changes
- **style**: Code formatting, missing semicolons, etc.
- **refactor**: Code refactoring without feature changes
- **test**: Adding or updating tests
- **chore**: Build process, dependency updates, configuration
- **perf**: Performance improvements
- **ci**: CI/CD configuration changes
- **build**: Build system changes
- **revert**: Reverting previous changes

### Examples

```bash
# Feature work (auto-detects as feat)
/complete-workflow user-profile "implement user profile management"
# Output: feat(user): implement user profile management

# Bug fixes (auto-detects as fix)
/complete-workflow fix-auth-timeout "resolve authentication timeout issue"
# Output: fix: resolve authentication timeout issue

# Documentation updates (auto-detects as docs)
/complete-workflow readme "update installation instructions"
# Output: docs: update installation instructions

# Test updates (auto-detects as test)
/complete-workflow unit-tests "add coverage for auth module"
# Output: test: add coverage for auth module

# Direct conventional commit format
/complete-workflow api "feat(auth): implement JWT token refresh"
# Output: feat(auth): implement JWT token refresh

# Quick changes with smart detection
/complete-workflow "add validation middleware"
# Output: feat: add validation middleware
```

### PR Structure Generated

The workflow automatically creates pull requests with:

- **Clean title** extracted from conventional commit (without type prefix)
- **Structured description** with:
  - Summary section
  - Changes overview with git statistics
  - Type of change checkboxes
  - Testing instructions based on commit type
  - Development checklist
  - Proper markdown formatting

### Requirements

- Azure CLI configured with PAT
- Git repository with development branch
- Staged or unstaged changes to commit
- Conventional commit compliance for automated tooling

### Implementation

```bash
#!/bin/bash

# Simple Git workflow: branch -> commit -> push -> PR

# Parse arguments
BRANCH_NAME="$1"
COMMIT_MESSAGE="$2"

# Auto-generate branch name if not provided
if [[ -z "$BRANCH_NAME" ]]; then
    # Get first changed file to create meaningful branch name
    FIRST_FILE=$(git diff --name-only | head -1 | cut -d'/' -f2- | sed 's/\.[^.]*$//')
    if [[ -n "$FIRST_FILE" ]]; then
        BRANCH_NAME="feature/${FIRST_FILE}"
    else
        BRANCH_NAME="feature/$(date +%Y%m%d-%H%M%S)"
    fi
fi

# Auto-generate conventional commit message if not provided
if [[ -z "$COMMIT_MESSAGE" ]]; then
    # Analyze changes to determine commit type and generate conventional commit
    CHANGED_FILES=$(git diff --name-only)

    # Determine commit type based on changed files
    COMMIT_TYPE="feat"  # default to feature

    if echo "$CHANGED_FILES" | grep -qE "\.(md|txt|rst)$"; then
        COMMIT_TYPE="docs"
    elif echo "$CHANGED_FILES" | grep -qE "\.(js|ts|py|java|cpp|c|go|rs)$"; then
        # Check if it's a fix vs feature based on file patterns
        if echo "$CHANGED_FILES" | grep -qiE "(test|spec)"; then
            COMMIT_TYPE="test"
        elif echo "$CHANGED_FILES" | grep -qiE "(fix|bug|patch)" || git diff --unified=0 | grep -q "^[-].*TODO\|^[-].*FIXME\|^[-].*BUG"; then
            COMMIT_TYPE="fix"
        fi
    elif echo "$CHANGED_FILES" | grep -qE "\.(json|yaml|yml|toml|ini|conf)$"; then
        COMMIT_TYPE="config"
    fi

    # Generate scope based on most common directory
    SCOPE=$(echo "$CHANGED_FILES" | cut -d'/' -f1 | sort | uniq -c | sort -nr | head -1 | awk '{print $2}')
    if [[ -z "$SCOPE" || "$SCOPE" == "." ]]; then
        SCOPE=""
    fi

    # Generate descriptive message
    FILE_COUNT=$(echo "$CHANGED_FILES" | wc -l | tr -d ' ')
    if [[ $FILE_COUNT -eq 1 ]]; then
        DESCRIPTION="update $(basename $CHANGED_FILES)"
    else
        DESCRIPTION="update $FILE_COUNT files"
    fi

    # Build conventional commit message
    if [[ -n "$SCOPE" ]]; then
        COMMIT_MESSAGE="$COMMIT_TYPE($SCOPE): $DESCRIPTION"
    else
        COMMIT_MESSAGE="$COMMIT_TYPE: $DESCRIPTION"
    fi

    # If user provided message, convert to conventional commit format if not already
elif [[ ! "$COMMIT_MESSAGE" =~ ^(feat|fix|docs|style|refactor|test|chore|perf|ci|build|revert)(\(.+\))?: .+ ]]; then
    # Auto-detect commit type for user-provided messages
    if echo "$COMMIT_MESSAGE" | grep -qiE "(add|implement|create|new|feature)"; then
        COMMIT_TYPE="feat"
    elif echo "$COMMIT_MESSAGE" | grep -qiE "(fix|bug|resolve|patch|correct)"; then
        COMMIT_TYPE="fix"
    elif echo "$COMMIT_MESSAGE" | grep -qiE "(document|readme|md)"; then
        COMMIT_TYPE="docs"
    elif echo "$COMMIT_MESSAGE" | grep -qiE "(test|spec)"; then
        COMMIT_TYPE="test"
    elif echo "$COMMIT_MESSAGE" | grep -qiE "(refactor|clean|reorganize)"; then
        COMMIT_TYPE="refactor"
    else
        COMMIT_TYPE="feat"  # default
    fi

    COMMIT_MESSAGE="$COMMIT_TYPE: $COMMIT_MESSAGE"
fi

echo "🚀 Starting simple Git workflow..."
echo "   Branch: $BRANCH_NAME"
echo "   Commit: $COMMIT_MESSAGE"

# 1. Create new branch
echo "📂 Creating branch: $BRANCH_NAME"
git checkout -b "$BRANCH_NAME"
if [[ $? -ne 0 ]]; then
    echo "❌ Failed to create branch"
    exit 1
fi

# 2. Stage and commit changes
echo "📋 Staging changes..."
git add .
if [[ $? -ne 0 ]]; then
    echo "❌ Failed to stage changes"
    exit 1
fi

echo "💾 Committing changes..."
git commit -m "$COMMIT_MESSAGE"
if [[ $? -ne 0 ]]; then
    echo "❌ Failed to commit changes"
    exit 1
fi

# 3. Push to remote
echo "📤 Pushing to remote..."
git push -u origin "$BRANCH_NAME"
if [[ $? -ne 0 ]]; then
    echo "❌ Failed to push to remote"
    exit 1
fi

# 4. Create pull request to development branch
echo "🔗 Creating pull request to development branch..."

# Extract PR title from conventional commit message (remove type prefix for cleaner title)
PR_TITLE=$(echo "$COMMIT_MESSAGE" | sed 's/^[^(]*(([^)]*)): \(.*\)/\3/g' | sed 's/^[^:]*: //')

# Generate PR description following best practices
PR_DESCRIPTION="## Summary

This PR implements $PR_TITLE.

## Changes

- **Branch**: \`$BRANCH_NAME\`
- **Commit**: \`$COMMIT_MESSAGE\`

### What's Changed

$(git diff --stat HEAD~1 | sed 's/^/- /')

### Type of Change

$(echo "$COMMIT_MESSAGE" | grep -q '^feat' && echo '- [ ] 🎉 New feature (non-breaking change)' || echo '- [ ] 🐛 Bug fix (non-breaking change)')
$(echo "$COMMIT_MESSAGE" | grep -q '^fix' && echo '- [x] 🐛 Bug fix (non-breaking change)' || echo '- [ ] 🐛 Bug fix (non-breaking change)')
$(echo "$COMMIT_MESSAGE" | grep -q '^docs' && echo '- [x] 📝 Documentation update' || echo '- [ ] 📝 Documentation update')
$(echo "$COMMIT_MESSAGE" | grep -q '^style' && echo '- [x] 💄 Code style changes (formatting, missing semicolons, etc)' || echo '- [ ] 💄 Code style changes (formatting, missing semicolons, etc)')
$(echo "$COMMIT_MESSAGE" | grep -q '^refactor' && echo '- [x] ♻️ Code refactoring (production code change)' || echo '- [ ] ♻️ Code refactoring (production code change)')
$(echo "$COMMIT_MESSAGE" | grep -q '^perf' && echo '- [x] ⚡ Performance improvements' || echo '- [ ] ⚡ Performance improvements)')
$(echo "$COMMIT_MESSAGE" | grep -q '^test' && echo '- [x] ✅ Adding or updating tests' || echo '- [ ] ✅ Adding or updating tests)')
$(echo "$COMMIT_MESSAGE" | grep -q '^chore' && echo '- [x] 🔧 Build process or auxiliary tool changes' || echo '- [ ] 🔧 Build process or auxiliary tool changes')
$(echo "$COMMIT_MESSAGE" | grep -q '^ci' && echo '- [x] 🔄 CI configuration changes' || echo '- [ ] 🔄 CI configuration changes')

## How to Test

$(if echo "$COMMIT_MESSAGE" | grep -q '^feat\|^fix'; then
    echo '1. Pull the latest changes from this branch'
    echo '2. Run the application locally'
    echo '3. Test the new/updated functionality'
    echo '4. Verify existing functionality remains intact'
else
    echo '1. Review the changes in this PR'
    echo '2. Ensure the changes align with the description'
fi)

## Checklist

- [ ] My code follows the project's coding guidelines
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes
- [ ] Any dependent changes have been merged and published in downstream modules

---

*This PR was created automatically using the complete-workflow command.*"

az repos pr create \
    --title "$PR_TITLE" \
    --description "$PR_DESCRIPTION" \
    --source-branch "$BRANCH_NAME" \
    --target-branch "development" \
    --open

if [[ $? -eq 0 ]]; then
    echo "✅ Workflow completed successfully!"
    echo "   Branch: $BRANCH_NAME"
    echo "   Commit: $(git rev-parse --short HEAD)"
    echo "   PR created to development branch"
else
    echo "❌ Failed to create pull request"
    echo "💡 You can manually create a PR at: https://dev.azure.com/your-org/your-project/_git/your-repo/pullrequestcreate?sourceRef=$BRANCH_NAME&targetRef=development"
    exit 1
fi
```

### Requirements

- Azure CLI configured with PAT
- Git repository with development branch
- Staged or unstaged changes to commit
