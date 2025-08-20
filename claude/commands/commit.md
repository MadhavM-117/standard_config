# Stage & Commit Session Files

Stage & commit all files that were modified in the current Claude session.

## Description
This command instructs Claude to identify and stage only the files that were modified during the current coding session. Claude will remember which files were edited and stage them appropriately.
Once staged, Claude should commit the changes with a brief commit message that captures the changes with a brief descriptive message.

## What Claude Will Do
1. Identify all files that were modified in the current session
2. Stage only those specific files using individual `git add` commands
3. Show the staged changes with `git status`
4. Create a commit with a brief descriptive message (that doesn't mention claude)

## Usage
Run this after making changes in a Claude session to stage only the relevant files before committing. Claude will remember the exact files that were modified, stage them precisely, and create a commit.

