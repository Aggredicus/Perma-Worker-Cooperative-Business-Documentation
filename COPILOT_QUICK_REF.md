# Quick Reference Card

## Launch Commands (Windows)

```powershell
# Safe Mode (conservative, asks for approval)
.\scripts\copilot-safe.ps1

# Work Mode (productive, fewer confirmations)
.\scripts\copilot-work.ps1

# With one-off prompt
.\scripts\copilot-safe.ps1 -Prompt "What does this do?"
.\scripts\copilot-work.ps1 -Prompt "Add error handling to auth.ts"

# Resume a session
.\scripts\copilot-safe.ps1 -Resume

# Enable experimental features (autopilot mode)
.\scripts\copilot-safe.ps1 -Experimental

# Full permissive access (Work Mode only)
.\scripts\copilot-work.ps1 -AllowAll
```

## Inside Copilot (Interactive Commands)

```
/plan                 # Create an implementation plan
/diff                 # Show all changes in working directory
/share-gist           # Save conversation to secret GitHub gist
/allow-all            # Grant full permissions (this session only)
/add-dir /path        # Allow access to a specific directory
/help                 # Show all interactive commands
```

## What's Allowed

| Action | Safe Mode | Work Mode |
|--------|-----------|-----------|
| Read files | ✅ | ✅ |
| Search code | ✅ | ✅ |
| Create files | ✅ | ✅ |
| Edit files | ✅ | ✅ |
| Run commands | ✅ ask | ✅ |
| Delete files | ❌ | ✅ ask |
| Commit code | ❌ | ❌ |
| Push to GitHub | ❌ | ❌ |
| Force git ops | ❌ | ❌ |
| Access secrets | ❌ | ❌ |

## Documentation

- **Full Guide**: `docs/copilot-workflow.md`
- **Setup Details**: `COPILOT_SETUP.md`
- **Behavior Rules**: `.github/copilot-instructions.md`

## Key Principles

1. ✅ Powerful — real coding assistance
2. ✅ Not reckless — no auto-push, no force-ops
3. ✅ Reviewable — explain before large changes
4. ✅ Safe by default — conservative permissions
5. ✅ Reusable — same setup every time
