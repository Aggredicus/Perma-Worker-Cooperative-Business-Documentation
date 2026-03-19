# GitHub Copilot CLI - Work Mode Launcher
# Purpose: More permissive than safe mode, but still intentional and reviewable
# - Allows file creation and editing with confirmation
# - Allows shell commands with caution (no automatic approval)
# - Streaming enabled, color enabled, high reasoning
# - Still denies: force git ops, auto push, unrestricted tool access
# - Still respects: ask_user, custom instructions

param(
    [switch]$NoReasoning,
    [switch]$NoStream,
    [switch]$NoColor,
    [string]$Prompt,
    [string]$Resume,
    [switch]$Experimental,
    [switch]$AllowAll
)

$args = @()

# Default: interactive mode unless --prompt is provided
if ($Prompt) {
    $args += @("--prompt", $Prompt)
    $args += "--silent"
} else {
    # Interactive mode (default for work)
    $args += "--interactive", ""
}

# Streaming mode (enabled by default, unless --NoStream)
if (-not $NoStream) {
    $args += "--stream", "on"
}

# Color output (enabled by default, unless --NoColor)
if (-not $NoColor) {
    $args += "--no-color:$False"  # Keep colors on
}

# Reasoning effort: high (unless --NoReasoning)
if (-not $NoReasoning) {
    $args += "--reasoning-effort", "high"
}

# Resume session if requested
if ($Resume) {
    $args += "--resume", $Resume
}

# Experimental features (opt-in)
if ($Experimental) {
    $args += "--experimental"
}

# ========== PERMISSIONS CONFIGURATION ==========
# Work mode is more permissive but still controlled
# Allow file read/write, shell commands, etc.
# But still deny dangerous git operations

if ($AllowAll) {
    # Override: grant full permissions if explicitly requested
    Write-Host "⚠️  PERMISSIVE MODE ACTIVATED" -ForegroundColor Yellow
    Write-Host "This grants broader permissions. Review all actions carefully." -ForegroundColor Yellow
    $args += "--allow-all-tools"
    $args += "--allow-all-paths"
    $args += "--allow-all-urls"
} else {
    # Controlled work mode: allow normal tools, deny only the riskiest
    $args += @(
        "--allow-tool=powershell",
        "--allow-tool=bash",
        "--allow-tool=view",
        "--allow-tool=glob",
        "--allow-tool=grep",
        "--allow-tool=edit",
        "--allow-tool=create",
        "--allow-tool=ask_user",
        "--allow-tool=report_intent",
        "--allow-tool=sql"
    )
    
    # Deny forced git operations and risky shell commands
    $args += @(
        "--deny-tool=bash_force_git_operation",
        "--deny-tool=powershell_force_git_operation"
    )
}

# Custom instructions are loaded by default from .github/copilot-instructions.md
# To disable them, add: --no-custom-instructions

Write-Host "💼 Copilot Work Mode" -ForegroundColor Blue
Write-Host "Permissions: Standard tools allowed, dangerous ops denied" -ForegroundColor Gray
Write-Host "Streaming: ON | Reasoning: HIGH | Color: ON" -ForegroundColor Gray
if ($AllowAll) {
    Write-Host "Mode: PERMISSIVE (all tools enabled)" -ForegroundColor Yellow
} else {
    Write-Host "Mode: CONTROLLED (selective tool access)" -ForegroundColor Gray
}
Write-Host ""

# Launch Copilot with work defaults
& copilot @args
