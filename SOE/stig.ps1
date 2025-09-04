# DISA STIG hardening script for Windows

<#
All-in-one Windows 11 STIG enforcer for standalone (non-domain) machines.

What it does:
1. Downloads DISA Windows 11 STIG zip.
2. Extracts files.
3. Applies included .inf via secedit if present.
4. Imports any .reg files found.
5. Finds and executes any embedded "reg add", "reg import", or "auditpol" commands inside XML/HTML/TXT files.
6. Attempts to apply audit settings with auditpol for common categories if explicit commands are not found.
7. Forces policy refresh.

Run as Administrator. This script makes system changes. Review before running.
#>

# --- Configuration ---
$stigUrl = "https://dl.dod.cyber.mil/wp-content/uploads/stigs/zip/U_Windows_11_STIG_V2R1_Manual-xccdf.zip"
$temp = Join-Path $env:TEMP "Win11_STIG_$(Get-Random)"
$zipPath = Join-Path $temp "win11_stig.zip"
$extractPath = Join-Path $temp "extracted"
$sdbPath = "C:\Windows\Security\Database\win11_stig.sdb"

# --- Admin check ---
If (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Error "Script must be run as Administrator. Exiting."
    exit 1
}

# --- Prepare workspace ---
Remove-Item -LiteralPath $temp -Recurse -Force -ErrorAction SilentlyContinue
New-Item -Path $extractPath -ItemType Directory -Force | Out-Null

# --- Download STIG zip ---
Write-Output "Downloading STIG..."
Invoke-WebRequest -Uri $stigUrl -OutFile $zipPath -UseBasicParsing

# --- Extract ---
Write-Output "Extracting..."
Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force

# --- Apply .inf (secedit) if exists ---
$infCandidates = Get-ChildItem -Path $extractPath -Recurse -Include *.inf -ErrorAction SilentlyContinue
if ($infCandidates -and $infCandidates.Count -gt 0) {
    foreach ($inf in $infCandidates) {
        Write-Output "Applying INF: $($inf.FullName)"
        & secedit.exe /configure /db $sdbPath /cfg $inf.FullName /overwrite
    }
} else {
    Write-Output "No INF files found."
}

# --- Import .reg files found ---
$regFiles = Get-ChildItem -Path $extractPath -Recurse -Include *.reg -ErrorAction SilentlyContinue
foreach ($reg in $regFiles) {
    Write-Output "Importing REG: $($reg.FullName)"
    & reg.exe import $reg.FullName
}

# --- Helper: execute shell commands found inside text/xml/html files matching patterns ---
$txtFiles = Get-ChildItem -Path $extractPath -Recurse -Include *.xml,*.txt,*.html,*.htm,*.csv -ErrorAction SilentlyContinue
$commandPatterns = @(
    'reg add [^"\r\n]+',
    'reg import [^"\r\n]+',
    'secedit.exe /configure [^"\r\n]+',
    'auditpol\s+/set[^\r\n]+',
    'wevtutil\s+sl[^\r\n]+'  # sometimes used by STIGs
)

foreach ($file in $txtFiles) {
    $content = Get-Content -Raw -LiteralPath $file.FullName -ErrorAction SilentlyContinue
    if (-not $content) { continue }
    foreach ($pattern in $commandPatterns) {
        $matches = [regex]::Matches($content, $pattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        foreach ($m in $matches) {
            $cmd = $m.Value.Trim()
            Write-Output "Executing extracted command from $($file.Name): $cmd"
            try {
                Start-Process -FilePath "cmd.exe" -ArgumentList "/c $cmd" -NoNewWindow -Wait -ErrorAction Stop
            } catch {
                Write-Warning "Failed to run: $cmd"
            }
        }
    }
}

# --- If no explicit auditpol commands were found, apply conservative audit policy baseline used by STIGs ---
Function Apply-ConservativeAuditBaseline {
    Write-Output "Applying conservative audit baseline via auditpol..."
    $baseline = @{
        "Account Logon" = "/subcategory:`"Kerberos Authentication Service`" /success:Enable /failure:Enable"
        "Account Management" = "/subcategory:`"User Account Management`" /success:Enable /failure:Enable"
        "Logon/Logoff" = "/subcategory:`"Logon`" /success:Enable /failure:Enable"
        "Policy Change" = "/subcategory:`"Audit Policy Change`" /success:Enable /failure:Enable"
        "System" = "/subcategory:`"Security System Extension`" /success:Enable /failure:Enable"
    }
    foreach ($k in $baseline.Keys) {
        $arg = $baseline[$k]
        $full = "auditpol /set $arg"
        Write-Output "Running: $full"
        Start-Process -FilePath "cmd.exe" -ArgumentList "/c $full" -NoNewWindow -Wait
    }
}

# Check whether any auditpol commands were executed earlier by checking the extracted commands count
$foundAuditCommands = ($txtFiles | ForEach-Object {
    (Get-Content -Raw -LiteralPath $_.FullName) -match "auditpol\s+/set"
}) -contains $true

if (-not $foundAuditCommands) {
    Apply-ConservativeAuditBaseline
} else {
    Write-Output "Auditpol commands found and executed from STIG package."
}

# --- Apply additional common registry STIG settings not always present in INF ---
$extraRegs = @(
    @{Path='HKLM:\SYSTEM\CurrentControlSet\Control\Lsa'; Name='LimitBlankPasswordUse'; Value=1; Type='DWord'},
    @{Path='HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'; Name='EnableLUA'; Value=1; Type='DWord'},
    @{Path='HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'; Name='ConsentPromptBehaviorAdmin'; Value=2; Type='DWord'},
    @{Path='HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters'; Name='EnableTCPA'; Value=1; Type='DWord'}
)
foreach ($r in $extraRegs) {
    if (-not (Test-Path -LiteralPath $r.Path)) { New-Item -Path $r.Path -Force | Out-Null }
    New-ItemProperty -LiteralPath $r.Path -Name $r.Name -Value $r.Value -PropertyType $r.Type -Force | Out-Null
    Write-Output "Set $($r.Path)\$($r.Name) = $($r.Value)"
}

# --- Force policy refresh ---
Write-Output "Refreshing policies..."
Start-Process -FilePath "gpupdate.exe" -ArgumentList "/force" -NoNewWindow -Wait

# --- Cleanup workspace (optional) ---
# Remove-Item -LiteralPath $temp -Recurse -Force

Write-Output "STIG application attempt complete. Review logs and run STIG validation tools if required."
