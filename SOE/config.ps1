# Requires -RunAsAdministrator
# ============================================
# Windows 11 Bare-Bones Privacy + Performance Setup
# ============================================

# Live on the edge
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned -Force

# Exit on errors
$ErrorActionPreference = "Stop"

# --- Computer name ---
Rename-Computer -NewName "WIN11" -Force

# --- Timezone & NTP ---
Set-Service -Name w32time -StartupType Automatic
Start-Service -Name w32time
Set-TimeZone -Name "E. Australia Standard Time"
w32tm /config /manualpeerlist:"pool.ntp.org" /syncfromflags:manual /reliable:YES /update
w32tm /resync

# --- Disable IPv6 on all adapters ---
Get-NetAdapterBinding -ComponentID ms_tcpip6 | Disable-NetAdapterBinding -PassThru | Out-Null

# --- GodMode on Desktop ---
$desktop = [Environment]::GetFolderPath("Desktop")
$godMode = Join-Path $desktop "GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}"
New-Item -Path $godMode -ItemType Directory -Force | Out-Null

# --- “CMD here” context menu (current path) ---
New-Item -Path "HKCR:\Directory\shell\cmdhere" -Force | Out-Null
Set-ItemProperty -Path "HKCR:\Directory\shell\cmdhere" -Name "(default)" -Value "Cmd&Here"
New-Item -Path "HKCR:\Directory\shell\cmdhere\command" -Force | Out-Null
Set-ItemProperty -Path "HKCR:\Directory\shell\cmdhere\command" -Name "(default)" -Value "cmd.exe /c start cmd.exe /k pushd `"%V`""

# --- Disable Windows Update service (full) ---
Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
Set-Service -Name wuauserv -StartupType Disabled

# --- Disable Windows Firewall (all profiles) ---
netsh advfirewall set allprofiles state off | Out-Null

# --- WSL (WSL1 only; no Hyper-V) ---
dism /online /Enable-Feature /FeatureName:Microsoft-Windows-Subsystem-Linux /All /NoRestart


# --- Explorer preferences (current user) ---
$keyAdv = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty $keyAdv Hidden 1
Set-ItemProperty $keyAdv HideFileExt 0
Set-ItemProperty $keyAdv ShowSuperHidden 1

# --- Disable legacy IE first run (keys may not exist on Windows 11) ---
$AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
$UserKey  = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
foreach ($k in @($AdminKey,$UserKey)) {
    if (Test-Path $k) { New-ItemProperty -Path $k -Name "IsInstalled" -Value 0 -PropertyType DWord -Force | Out-Null }
}
$keyIE = "HKLM:\SOFTWARE\Microsoft\Internet Explorer\Main"
if (Test-Path $keyIE) { New-ItemProperty -Path $keyIE -Name "DisableFirstRunCustomize" -Value 1 -PropertyType DWord -Force | Out-Null }

# --- Remove OneDrive (per-machine) ---
$odSetup = Join-Path $env:SystemRoot "System32\OneDriveSetup.exe"
if (Test-Path $odSetup) { Start-Process $odSetup "/uninstall" -Wait | Out-Null }
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Force | Out-Null
New-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSync" -Value 1 -PropertyType DWord -Force | Out-Null


# --- Disable telemetry-related scheduled tasks ---
$tasks = @(
    "\Microsoft\Windows\Application Experience\ProgramDataUpdater",
    "\Microsoft\Windows\Autochk\Proxy",
    "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator",
    "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip",
    "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector",
    "\Microsoft\Windows\Feedback\Siuf\DmClient",
    "\Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload",
    "\Microsoft\Windows\Windows Error Reporting\QueueReporting"
)
foreach ($t in $tasks) {
    schtasks /Change /TN $t /Disable 2>$null | Out-Null
}

# Adapted from http://stackoverflow.com/a/29571064/18475
# Get the OS
$osData = Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $ComputerName

$AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
$UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
if (Test-Path $AdminKey) {
    New-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0 -Force | Out-Null
    Write-Output "IE Enhanced Security Configuration (ESC) has been disabled for Admin."
}

if (Test-Path $UserKey) {
    New-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0 -Force | Out-Null
    Write-Output "IE Enhanced Security Configuration (ESC) has been disabled for User."
}

#Stop-Process -Name Explorer -Force

# http://techrena.net/disable-ie-set-up-first-run-welcome-screen/
$key = "HKLM:\SOFTWARE\Microsoft\Internet Explorer\Main"
if (Test-Path $key) {
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Internet Explorer\Main" -Name "DisableFirstRunCustomize" -Value 1 -PropertyType "DWord" -Force | Out-Null
    Write-Output "IE first run welcome screen has been disabled."
}

Write-Output 'Setting Windows Update service to Manual startup type.'
Set-Service -Name wuauserv -StartupType Manual

#Set-ExecutionPolicy Unrestricted

# Ensure there is a profile file so we can get tab completion
New-Item -ItemType Directory $(Split-Path $profile -Parent) -Force
Set-Content -Path $profile -Encoding UTF8 -Value "" -Force

winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="2048"}'

# Set Preferences
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer'
$advancedKey = "$key\Advanced"
Set-ItemProperty $advancedKey Hidden 1
Set-ItemProperty $advancedKey HideFileExt 0
Set-ItemProperty $advancedKey ShowSuperHidden 1

$identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$parts = $identity.Name -split "\\"
$user = @{Domain = $parts[0]; Name = $parts[1]}

try {
    try { $explorer = Get-Process -Name explorer -ErrorAction stop -IncludeUserName }
    catch {$global:error.RemoveAt(0)}

    if ($explorer -ne $null) {
        $explorer | ? { $_.UserName -eq "$($user.Domain)\$($user.Name)"} | Stop-Process -Force -ErrorAction Stop | Out-Null
    }

    Start-Sleep 1

    if (!(Get-Process -Name explorer -ErrorAction SilentlyContinue)) {
        $global:error.RemoveAt(0)
        start-Process -FilePath explorer
    }
}
catch {$global:error.RemoveAt(0)}

# Enable Network Discovery and File and Print Sharing
# Taken from here: http://win10server2016.com/enable-network-discovery-in-windows-10-creator-edition-without-using-the-netsh-command-in-powershell
Write-Host "Enabling Network Discovery."
$null = Get-NetFirewallRule -DisplayGroup 'Network Discovery' | Set-NetFirewallRule -Profile 'Private, Domain' -Enabled true -PassThru
Write-Host "Enabling File and Printer Sharing."
$null = Get-NetFirewallRule -DisplayGroup 'File and Printer Sharing' | Set-NetFirewallRule -Profile 'Private, Domain' -Enabled true -PassThru

Get-NetAdapter | ForEach-Object {
    Write-Host "Setting '$($_.Name)' interface to a 'Private' network."
    Get-NetConnectionProfile -InterfaceIndex $_.ifIndex | Set-NetConnectionProfile -NetworkCategory Private
}

Write-Host "Disabling IPv6"
Get-NetAdapterBinding | Where-Object ComponentID -eq 'ms_tcpip6' | Disable-NetAdapterBinding


# Server OS
if ($osData.ProductType -eq 3) {
    Write-Host 'Disabling Server Manager for starting at login.'
    Get-ScheduledTask -TaskName 'ServerManager' | Disable-ScheduledTask | Out-Null
}

# --- Enable WSL ---
wsl --install

Write-Output "System setup completed. Reboot recommended."
