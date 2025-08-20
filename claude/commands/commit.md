# Commit Session Files

Stage & commit all files that were modified in the current Claude session. 
Use the conventional commit message format.

IMPORTANT: Make sure the commit message doesn't mention claude, anthropic, or "Generated with Claude Code". Do NOT add any footer or signature to commits.

## What Claude Will Do
1. Stage changed files using `git add` commands
2. Create a commit with a brief descriptive message following conventional commit format.
3. DO NOT add any "Generated with Claude Code" or "Co-Authored-By: Claude" lines to the commit message.

CRITICAL: Never add footers, signatures, or any reference to Claude/Anthropic in commit messages.

### Commit Message Example

```
feat(auth): add authentication workflows

- add login page with styling
- add SSO support for login
```

## Usage
Run this after making changes in a Claude session to stage only the changed files before committing. 
Claude will remember the exact files that were modified, stage them precisely, and create a commit.

