# Copilot Workflow Instructions

## Philosophy
This repository uses a "powerful but not reckless" approach to AI-assisted development. Copilot should be helpful for real work while maintaining safety, reviewability, and explicit control.

## Behavioral Guidelines

### Code Changes
- **Prioritize small, reviewable diffs.** Avoid large refactors or rewrites without explicit planning.
- **Explain planned changes before implementation.** Use `/plan` to outline approach, show the plan, and wait for approval.
- **Prefer reading code before editing.** Understand the existing codebase structure first.
- **Preserve functionality.** Do not remove features or change behavior speculatively.
- **Only run tests/lint when relevant.** Do not run the full test suite after every change unless asked.

### Permissions & Safety
- **Never push to remote** unless explicitly asked with "push to GitHub" or similar intent.
- **Never change secrets, tokens, or deployment settings** unless explicitly requested and confirmed.
- **Ask before destructive actions:** delete files, reset branches, force checkout, force git operations, or bulk changes.
- **Don't assume access.** Maintain minimal permissions by default and ask to expand if needed.

### Git Operations
- Create commits with clear, descriptive messages.
- Do not force-push or rewrite history without explicit approval.
- Do not merge branches or pull from remote without being asked.
- Always use `git --no-pager` to avoid pager issues in automated contexts.

### Documentation
- Keep documentation updated with code changes.
- Explain non-obvious decisions in code comments and commit messages.

### Communication
- Be concise but thorough; explain your approach before executing complex tasks.
- Show summaries of changes before they are committed.
- Ask clarifying questions rather than guessing intent.

## Tool Usage
- Prefer ecosystem tools (npm, pip, cargo) over manual changes.
- Only run existing linters, builders, and tests; do not add new tools without discussion.
- Use grep/glob for code search; avoid modifying files without understanding context first.

## Default Permissions
By default, Copilot has:
- ✅ Read access to repository files
- ✅ Ability to search and grep code
- ✅ Ability to execute local shell commands for building/testing
- ✅ Ability to create and edit files locally
- ✅ Ability to read GitHub issues and PRs
- ❌ No automatic file deletion, reset, or force git operations
- ❌ No unrestricted access to URLs
- ❌ No automatic git push or merge
- ❌ No access to secrets or tokens
