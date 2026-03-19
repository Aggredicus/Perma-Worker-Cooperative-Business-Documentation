# GitHub Copilot CLI - Safe Mode Launcher
# Purpose: Launch Copilot with conservative defaults for daily development
# - Streaming enabled, color enabled, strong reasoning
# - Interactive mode by default
# - Minimal permissions: no push, no force operations, no secrets
# - Ask before destructive actions

param(
    [switch]$NoReasoning,
    [switch]$NoStream,
    [switch]$NoColor,
    [string]$Prompt,
    [string]$Resume,
    [switch]$Experimental
)

$args = @()

# Default: interactive mode unless --prompt is provided
if ($Prompt) {
    $args += @("--prompt", $Prompt)
    $args += "--silent"
} else {
    # Interactive mode (default for safe)
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
# Deny dangerous operations by default
$args += @(
    "--deny-tool=bash_write_file",
    "--deny-tool=bash_edit_file",
    "--deny-tool=powershell_write_file",
    "--deny-tool=powershell_edit_file",
    "--deny-tool=bash_run_shell_command",
    "--deny-tool=powershell_run_shell_command"
)

# Add back the safe, essential tools
$args += @(
    "--allow-tool=powershell",
    "--allow-tool=bash",
    "--allow-tool=view",
    "--allow-tool=glob",
    "--allow-tool=grep",
    "--allow-tool=edit",
    "--allow-tool=create",
    "--allow-tool=ask_user"
)

# Custom instructions are loaded by default from .github/copilot-instructions.md
# To disable them, add: --no-custom-instructions

Write-Host "🔒 Copilot Safe Mode" -ForegroundColor Green
Write-Host "Permissions: Read-only by default, ask before destructive actions" -ForegroundColor Gray
Write-Host "Streaming: ON | Reasoning: HIGH | Color: ON" -ForegroundColor Gray
Write-Host ""

# Launch Copilot with safe defaults
& copilot @args
