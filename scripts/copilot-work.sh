#!/bin/bash
# GitHub Copilot CLI - Work Mode Launcher (Bash)
# Purpose: More permissive than safe mode, but still intentional and reviewable
# - Allows file creation and editing with confirmation
# - Allows shell commands with caution (no automatic approval)
# - Streaming enabled, color enabled, high reasoning
# - Still denies: force git ops, auto push, unrestricted tool access
# - Still respects: ask_user, custom instructions

set -euo pipefail

# Parse arguments
NO_REASONING=false
NO_STREAM=false
NO_COLOR=false
PROMPT=""
RESUME=""
EXPERIMENTAL=false
ALLOW_ALL=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --no-reasoning)
            NO_REASONING=true
            shift
            ;;
        --no-stream)
            NO_STREAM=true
            shift
            ;;
        --no-color)
            NO_COLOR=true
            shift
            ;;
        --prompt)
            PROMPT="$2"
            shift 2
            ;;
        --resume)
            RESUME="$2"
            shift 2
            ;;
        --experimental)
            EXPERIMENTAL=true
            shift
            ;;
        --allow-all)
            ALLOW_ALL=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--no-reasoning] [--no-stream] [--no-color] [--prompt TEXT] [--resume ID] [--experimental] [--allow-all]"
            exit 1
            ;;
    esac
done

declare -a ARGS=()

# Default: interactive mode unless --prompt is provided
if [[ -n "$PROMPT" ]]; then
    ARGS+=("--prompt" "$PROMPT")
    ARGS+=("--silent")
else
    # Interactive mode (default for work)
    ARGS+=("--interactive" "")
fi

# Streaming mode (enabled by default, unless --no-stream)
if [[ "$NO_STREAM" != "true" ]]; then
    ARGS+=("--stream" "on")
fi

# Color output (enabled by default, unless --no-color)
if [[ "$NO_COLOR" != "true" ]]; then
    # Keep colors on by default; no special flag needed
    :
fi

# Reasoning effort: high (unless --no-reasoning)
if [[ "$NO_REASONING" != "true" ]]; then
    ARGS+=("--reasoning-effort" "high")
fi

# Resume session if requested
if [[ -n "$RESUME" ]]; then
    ARGS+=("--resume" "$RESUME")
fi

# Experimental features (opt-in)
if [[ "$EXPERIMENTAL" == "true" ]]; then
    ARGS+=("--experimental")
fi

# ========== PERMISSIONS CONFIGURATION ==========
# Work mode is more permissive but still controlled
# Allow file read/write, shell commands, etc.
# But still deny dangerous git operations

if [[ "$ALLOW_ALL" == "true" ]]; then
    # Override: grant full permissions if explicitly requested
    echo "⚠️  PERMISSIVE MODE ACTIVATED"
    echo "This grants broader permissions. Review all actions carefully."
    ARGS+=("--allow-all-tools")
    ARGS+=("--allow-all-paths")
    ARGS+=("--allow-all-urls")
else
    # Controlled work mode: allow normal tools, deny only the riskiest
    ARGS+=(
        "--allow-tool=powershell"
        "--allow-tool=bash"
        "--allow-tool=view"
        "--allow-tool=glob"
        "--allow-tool=grep"
        "--allow-tool=edit"
        "--allow-tool=create"
        "--allow-tool=ask_user"
        "--allow-tool=report_intent"
        "--allow-tool=sql"
    )
    
    # Deny forced git operations and risky shell commands
    ARGS+=(
        "--deny-tool=bash_force_git_operation"
        "--deny-tool=powershell_force_git_operation"
    )
fi

# Custom instructions are loaded by default from .github/copilot-instructions.md
# To disable them, add: --no-custom-instructions

echo "💼 Copilot Work Mode"
echo "Permissions: Standard tools allowed, dangerous ops denied"
echo "Streaming: ON | Reasoning: HIGH | Color: ON"
if [[ "$ALLOW_ALL" == "true" ]]; then
    echo "Mode: PERMISSIVE (all tools enabled)"
else
    echo "Mode: CONTROLLED (selective tool access)"
fi
echo ""

# Launch Copilot with work defaults
copilot "${ARGS[@]}"
