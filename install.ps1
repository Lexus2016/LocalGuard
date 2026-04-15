# LocalGuard installer for Windows
# Usage: irm https://raw.githubusercontent.com/Lexus2016/LocalGuard/main/install.ps1 | iex
$ErrorActionPreference = "Stop"

$Repo = "Lexus2016/LocalGuard"
$Binary = "llm-security-proxy"

# --- Detect architecture ---
$Arch = if ([Environment]::Is64BitOperatingSystem) { "x86_64" } else {
    Write-Error "32-bit Windows is not supported."
    exit 1
}

$Target = "${Arch}-pc-windows-gnu"

# --- Find latest release ---
Write-Host "Detecting latest version..."
$Release = Invoke-RestMethod "https://api.github.com/repos/${Repo}/releases/latest"
$Version = $Release.tag_name -replace '^v', ''

if (-not $Version) {
    Write-Error "Failed to detect latest version. Check https://github.com/${Repo}/releases"
    exit 1
}

Write-Host "Latest version: v${Version}"

# --- Download ---
$Asset = "${Binary}-v${Version}-${Target}.tar.gz"
$Url = "https://github.com/${Repo}/releases/download/v${Version}/${Asset}"

$TmpDir = Join-Path $env:TEMP "localguard-install"
New-Item -ItemType Directory -Force -Path $TmpDir | Out-Null

Write-Host "Downloading ${Asset}..."
Invoke-WebRequest -Uri $Url -OutFile (Join-Path $TmpDir $Asset)

# --- Extract ---
# Use tar (available on Windows 10+)
tar xzf (Join-Path $TmpDir $Asset) -C $TmpDir

# --- Install ---
$InstallDir = Join-Path $env:LOCALAPPDATA "LocalGuard"
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null

$ExePath = Join-Path $TmpDir "${Binary}.exe"
$DestPath = Join-Path $InstallDir "${Binary}.exe"
Move-Item -Force $ExePath $DestPath

# --- Add to PATH (user-level) ---
$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($UserPath -notlike "*${InstallDir}*") {
    [Environment]::SetEnvironmentVariable("Path", "${InstallDir};${UserPath}", "User")
    Write-Host "Added ${InstallDir} to user PATH."
    Write-Host "Restart your terminal for PATH changes to take effect."
}

# --- Cleanup ---
Remove-Item -Recurse -Force $TmpDir

Write-Host ""
Write-Host "LocalGuard v${Version} installed successfully!"
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Start:    ${Binary} start"
Write-Host "  2. Buy:      https://llm-proxy.gumroad.com"
Write-Host "  3. Activate: ${Binary} activate"
