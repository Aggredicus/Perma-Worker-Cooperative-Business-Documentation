# Copilot CLI Workflow Guide

This repository is configured with a **powerful but intentional** approach to AI-assisted development. All scripts and instructions prioritize safety, reviewability, and explicit control.

## Quick Start

### Safe Mode (Recommended for Daily Work)
```powershell
.\scripts\copilot-safe.ps1
```

**When to use:** Code exploration, small fixes, asking questions about the codebase, getting unstuck.

**Permissions:**
- ✅ Read all repository files
- ✅ Search code (grep, glob)
- ✅ Create files
- ✅ Edit files
- ✅ Run shell commands (with your approval)
- ✅ Ask clarifying questions
- ❌ No forced git operations
- ❌ No automatic commits or pushes
- ❌ No access to secrets

---

### Work Mode (More Permissive)
```powershell
.\scripts\copilot-work.ps1
```

**When to use:** Active development, refactoring, building features, when you want less "ask for permission" friction.

**Permissions:**
- ✅ All of Safe Mode, plus:
- ✅ Direct file operations (edit, create, delete via tools)
- ✅ Standard shell commands
- ✅ Background task management
- ❌ No forced git operations
- ❌ No automatic pushes
- ❌ No unrestricted tool access

**To enable full permissive mode** (only if you're confident):
```powershell
.\scripts\copilot-work.ps1 -AllowAll
```

---

## Command Usage

### Starting Interactive Sessions

```powershell
# Safe mode (default interactive)
.\scripts\copilot-safe.ps1

# Work mode (default interactive)
.\scripts\copilot-work.ps1
```

### Running One-Off Prompts (Non-Interactive)

```powershell
# Safe mode, single prompt
.\scripts\copilot-safe.ps1 -Prompt "Explain the architecture of this codebase"

# Work mode, single prompt with file edits
.\scripts\copilot-work.ps1 -Prompt "Add error handling to the authentication module"
```

### Resuming a Previous Session

```powershell
# Resume the most recent session
.\scripts\copilot-safe.ps1 -Resume

# Resume a specific session by ID
.\scripts\copilot-safe.ps1 -Resume "session-abc123"
```

### Sharing Your Work

Inside Copilot, use these commands:

```
# Save the conversation to a markdown file (in Safe or Work mode)
/share              # Saves to copilot-session-<id>.md

# Save to a secret GitHub gist
/share-gist
```

Or, use the `--share` flag when running with `-Prompt`:
```powershell
.\scripts\copilot-safe.ps1 -Prompt "..." --share "my-session.md"
```

---

## Permission Model Explained

### Safe Mode
**Philosophy:** Assume the user wants to review all actions.

| Action | Allowed | Notes |
|--------|---------|-------|
| Read files | ✅ | Essential for understanding code |
| Search code | ✅ | grep, glob for exploration |
| Create files | ✅ | New files are visible for review |
| Edit files | ✅ | Changes are shown before commit |
| Run commands | ✅ | But asks for confirmation |
| Delete files | ❓ | Requires explicit approval |
| Commit changes | ❌ | You must commit manually |
| Push to remote | ❌ | You must push manually |
| Force git ops | ❌ | Never automatic |
| Access secrets | ❌ | Redacted from environment |

### Work Mode
**Philosophy:** Allow productive work while still preventing catastrophes.

| Action | Allowed | Notes |
|--------|---------|-------|
| Read files | ✅ | Full repository access |
| Search code | ✅ | Fast code navigation |
| Create/Edit files | ✅ | Direct file manipulation |
| Run commands | ✅ | Standard shell commands allowed |
| Delete files | ✅ | But asks for confirmation |
| Commit changes | ❌ | You must commit manually |
| Push to remote | ❌ | You must push manually |
| Force git ops | ❌ | Rebase/reset only with approval |
| Access secrets | ❌ | Redacted from environment |
| Unrestricted tools | ❌ | Even in work mode, some tools are denied |

---

## When to Use Each Mode

### Use Safe Mode For:
- **Learning:** Ask about patterns, architecture, design decisions
- **Debugging:** Get help understanding why code doesn't work
- **Small fixes:** Typos, simple refactors, isolated changes
- **Exploration:** Understand an unfamiliar part of the codebase
- **First time working on a new area:** Be cautious until you understand the system

### Use Work Mode For:
- **Active feature development:** When you're deep in a change
- **Bulk edits:** Refactoring multiple files
- **Build & test cycles:** Running frequent test suites
- **Time-sensitive work:** When you need fewer confirmation prompts
- **Familiar codebases:** When you know the system well

---

## Advanced: Customizing Permissions

### Temporarily Allow a Specific Tool
Inside Copilot, use:
```
/allow-all        # Enable all permissions for this session only
/add-dir /path    # Allow access to a specific directory
```

### Disable Custom Instructions
If you want Copilot to ignore `.github/copilot-instructions.md` for a session:
```powershell
.\scripts\copilot-safe.ps1 -NoCustomInstructions
```

*(Note: The current scripts don't expose this flag yet. You can modify them or run copilot directly.)*

### Enable Experimental Features
```powershell
.\scripts\copilot-safe.ps1 -Experimental
```

This enables features like **Autopilot mode** (Shift+Tab to cycle modes).

---

## Secret Handling

By default, Copilot redacts common secret environment variables:
- `GH_TOKEN`
- `GITHUB_TOKEN`
- `API_KEY`
- `SECRET_KEY`
- And others

If you need Copilot to see certain environment variables (for context, not secrets), you can pass them explicitly:

```powershell
$env:PUBLIC_BUILD_INFO = "v1.2.3"
.\scripts\copilot-work.ps1
```

**Never expose secrets in Copilot sessions.** If Copilot outputs a secret, report it immediately.

---

## Tips & Best Practices

1. **Start with Safe Mode.** Use Work Mode only when you need the extra flexibility.

2. **Use `/plan` before large changes.**
   ```
   /plan Refactor the authentication module to support OAuth
   ```
   This lets Copilot create a plan and ask clarifying questions.

3. **Review diffs before committing.**
   ```
   /diff
   ```
   Shows all changes in the working directory.

4. **Leverage code search.**
   ```
   /lsp      # Manage language servers for go-to-definition, etc.
   grep      # Fast ripgrep-based search
   ```

5. **Save important sessions.**
   ```
   /share-gist
   ```
   This creates a secret GitHub gist you can reference later.

6. **Use the reasoning toggle.**
   ```
   Ctrl+T    # Toggle model reasoning display
   ```
   Helpful for understanding Copilot's thought process.

7. **Manage background tasks.**
   ```
   /tasks    # View and manage subagents and shell sessions
   ```

---

## Troubleshooting

### Permission Denied When Editing a File
You're in Safe Mode. Either:
- Approve the file edit interactively
- Switch to Work Mode if you want less friction
- Use `/add-dir /path/to/directory` to pre-approve access

### Copilot Tried to Push Without Asking
This shouldn't happen with the default scripts, but if it does:
- The scripts deny `--allow-all-tools`
- Ensure you're not running with `-AllowAll` flag
- Check that `.github/copilot-instructions.md` is in place

### I Need to Restart or Recover a Session
```powershell
# Inside Copilot:
/restart              # Restart preserving session

# Or resume an old session:
.\scripts\copilot-safe.ps1 -Resume "session-id"

# List available sessions:
# (Use /tasks or /session inside Copilot)
```

---

## Configuration Files

- **`.github/copilot-instructions.md`** — Repository-level guidelines for Copilot behavior
- **`scripts/copilot-safe.ps1`** — Safe mode launcher
- **`scripts/copilot-work.ps1`** — Work mode launcher

To modify behavior, edit `.github/copilot-instructions.md` and commit it to the repo.

---

## Links & Resources

- [Copilot CLI Docs](https://docs.github.com/en/copilot/concepts/agents/about-copilot-cli)
- [CLI Commands Reference](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/use-copilot-cli)
- [MCP Server Configuration](https://docs.github.com/en/copilot/using-github-copilot/copilot-cli-mcp-servers)
