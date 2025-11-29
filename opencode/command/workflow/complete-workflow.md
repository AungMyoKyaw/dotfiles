---
description: 'Simple Git workflow: create branch, commit, push, and create PR to development'
---

## Simple Git Workflow

Creates a new branch, commits changes, pushes to remote, and creates a pull request to the development branch using Azure DevOps. Automatically generates meaningful branch names and commit messages based on diff analysis.

### Usage

```bash
# Auto-generated branch name and commit message (smart analysis)
/complete-workflow

# Custom branch name and commit message
/complete-workflow feature-auth "add user authentication"

# Just branch name
/complete-workflow bugfix-login

# Just commit message
/complete-workflow "fix validation error"
```

### What it does

1. **Check staged changes** with !`git diff --cached`
2. **Analyze diff content** to auto-generate meaningful branch names and commit messages
3. **Create new branch** from current branch
4. **Commit changes** with descriptive message based on change type
5. **Push** branch to remote origin
6. **Create pull request** to development branch using Azure DevOps CLI

### Auto-Generation Features

**Branch Names:**

- Detects change type: `feature/`, `docs/`, `config/`, `test/`, `deps/`
- Extracts component name from primary changed file/directory
- Format: `{type}/{component}-{MMDD-HMM}`

**Commit Messages:**

- **Dependencies**: `chore: bump dependencies` or `chore: update dependencies`
- **Configuration**: `config: update {filename}`
- **Documentation**: `docs: update {filename}`
- **Tests**: `test: update test coverage`
- **Code Changes** (based on diff size):
  - Large additions: `feat: add new functionality`
  - Large deletions: `refactor: remove deprecated code`
  - Small changes: `fix: update implementation`
  - Medium changes: `feat: improve functionality`

### Implementation

_This command should be AI-generated based on the current git state and context. The AI will:_

1. **Analyze the full staged diff content** to determine change patterns
2. **Generate intelligent branch names** based on:
   - Most common directory across all changed files
   - File type patterns (feature/docs/config/test/deps)
   - Component extraction from directory structure
3. **Generate contextual commit messages** based on:
   - Full diff statistics (additions/deletions)
   - File type analysis across all files
   - Pure type detection (all files are same type)
   - Mixed file type context
   - Change magnitude and patterns

### AI Generation Logic

**Branch Name Analysis:**

- Examine !`git diff --cached --name-only` for **ALL** changed files
- Determine dominant change type from full file pattern analysis
- Find most common directory: !`cut -d'/' -f1 | sort | uniq -c | sort -nr`
- Generate: `{type}/{component}-{MMDD-HMM}`

**Commit Message Analysis:**

- Count files by type across complete diff
- Detect pure changes (all files same type) vs mixed changes
- Analyze change magnitude from full diff statistics
- Generate contextually appropriate messages with type indicators

### Requirements

- Azure CLI configured with PAT
- Git repository with development branch
- Staged changes to commit
- AI generation capability for dynamic analysis
