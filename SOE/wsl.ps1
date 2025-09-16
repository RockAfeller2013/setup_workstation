# This works 'ddism /online /Enable-Feature /FeatureName:Microsoft-Windows-Subsystem-Linux /All /NoRestart'
# If you run this, it breks the V - ## wsl.exe --update

# Download the latest WSL2 Linux kernel update package
# Visit: https://aka.ms/wsl2kernel
# Then install the downloaded .msi file

# Prevent Windows from automatically installing Hyper-V features
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d 1 /f
# Use PowerShell to update WSL components selectively
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart

wsl --list --verbose
wsl --status

# Remove Hyper-V components
dism /Online /Disable-Feature:Microsoft-Hyper-V /All
bcdedit /set hypervisorlaunchtype off
