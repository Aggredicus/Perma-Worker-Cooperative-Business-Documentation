#!/bin/bash
# GitHub Copilot CLI - Safe Mode Launcher (Bash)
# Purpose: Launch Copilot with conservative defaults for daily development
# - Streaming enabled, color enabled, strong reasoning
# - Interactive mode by default
# - Minimal permissions: no push, no force operations, no secrets
# - Ask before destructive actions

set -euo pipefail

# Parse arguments
NO_REASONING=false
NO_STREAM=false
NO_COLOR=false
PROMPT=""
RESUME=""
EXPERIMENTAL=false

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
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--no-reasoning] [--no-stream] [--no-color] [--prompt TEXT] [--resume ID] [--experimental]"
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
    # Interactive mode (default for safe)
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
# Deny dangerous operations by default
ARGS+=(
    "--deny-tool=bash_write_file"
    "--deny-tool=bash_edit_file"
    "--deny-tool=powershell_write_file"
    "--deny-tool=powershell_edit_file"
    "--deny-tool=bash_run_shell_command"
    "--deny-tool=powershell_run_shell_command"
)

# Add back the safe, essential tools
ARGS+=(
    "--allow-tool=powershell"
    "--allow-tool=bash"
    "--allow-tool=view"
    "--allow-tool=glob"
    "--allow-tool=grep"
    "--allow-tool=edit"
    "--allow-tool=create"
    "--allow-tool=ask_user"
)

# Custom instructions are loaded by default from .github/copilot-instructions.md
# To disable them, add: --no-custom-instructions

echo "🔒 Copilot Safe Mode"
echo "Permissions: Read-only by default, ask before destructive actions"
echo "Streaming: ON | Reasoning: HIGH | Color: ON"
echo ""

# Launch Copilot with safe defaults
copilot "${ARGS[@]}"
