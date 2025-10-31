---
description: 'Simple Git workflow: create branch, commit, push, and create PR to development'
argument-hint: '[branch-name] [commit-message]'
---

## Simple Git Workflow

Creates a new branch, commits changes, pushes to remote, and creates a pull request to the development branch using Azure DevOps.

### Usage

```bash
# Auto-generated branch name and commit message
/complete-workflow

# Custom branch name and commit message
/complete-workflow feature-auth "add user authentication"

# Just branch name
/complete-workflow bugfix-login

# Just commit message
/complete-workflow "fix validation error"
```

### What it does

1. **Check staged changes** with `git diff --cached`
2. **Create new branch** from current branch
3. **Commit changes** with descriptive message
4. **Push** branch to remote origin
5. **Create pull request** to development branch using Azure DevOps CLI

### Implementation

```bash
#!/bin/bash

# Simple Git workflow: branch -> commit -> push -> PR

# Parse arguments
BRANCH_NAME="$1"
COMMIT_MESSAGE="$2"

# Check staged changes first
echo "🔍 Checking staged changes..."
git diff --cached --stat
if [[ $? -ne 0 ]]; then
    echo "❌ No staged changes found. Please stage your changes first."
    exit 1
fi

# Auto-generate branch name if not provided
if [[ -z "$BRANCH_NAME" ]]; then
    BRANCH_NAME="feature/$(date +%Y%m%d-%H%M%S)"
fi

# Auto-generate descriptive commit message if not provided
if [[ -z "$COMMIT_MESSAGE" ]]; then
    CHANGED_FILES=$(git diff --cached --name-only)
    FILE_COUNT=$(echo "$CHANGED_FILES" | wc -l | tr -d ' ')

    if [[ $FILE_COUNT -eq 1 ]]; then
        COMMIT_MESSAGE="Update $(basename $CHANGED_FILES)"
    else
        COMMIT_MESSAGE="Update $FILE_COUNT files"
    fi
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

# 2. Commit changes
echo "💾 Committing changes..."
git commit -m "$COMMIT_MESSAGE"
if [[ $? -ne 0 ]]; then
    echo "❌ Failed to commit changes"
    exit 1
fi

# 3. Push to remote
echo "📤 Pushing to remote..."
git push origin "$BRANCH_NAME"
if [[ $? -ne 0 ]]; then
    echo "❌ Failed to push to remote"
    exit 1
fi

# 4. Create pull request to development branch
echo "🔗 Creating pull request to development branch..."

# Generate descriptive PR description
PR_DESCRIPTION="## Summary

$COMMIT_MESSAGE

## Changes

- **Branch**: \`$BRANCH_NAME\`
- **Files Modified**: $(git diff --cached --name-only | wc -l | tr -d ' ')

## How to Test

1. Pull the latest changes from this branch
2. Review the changes made in this PR
3. Test the updated functionality
4. Verify existing functionality remains intact

---

*This PR was created automatically using the complete-workflow command.*"

az repos pr create \
    --title "$COMMIT_MESSAGE" \
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
    echo "💡 You can manually create a PR using Azure DevOps web interface"
    exit 1
fi
```

### Requirements

- Azure CLI configured with PAT
- Git repository with development branch
- Staged changes to commit
