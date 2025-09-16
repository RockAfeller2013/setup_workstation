# This works 'ddism /online /Enable-Feature /FeatureName:Microsoft-Windows-Subsystem-Linux /All /NoRestart'
# If you run this, it breks the V - ## wsl.exe --update

# Download the latest WSL2 Linux kernel update package
# Visit: https://aka.ms/wsl2kernel
# Then install the downloaded .msi file

# Prevent Windows from automatically installing Hyper-V features
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d 1 /f

# Use PowerShell to update WSL components selectively
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart

wsl.exe --install Ubuntu
wsl.exe -d Ubuntu

# Convert existing distributions to WSL1
wsl --set-version Ubuntu 1

# Set WSL1 as default
# WSL1 uses less resources and doesn't require Hyper-V virtualization
# Some features are different - WSL1 uses a translation layer instead of a real VM
wsl --set-default-version 1




# Create .wslconfig file in your user directory with:
[wsl2]
kernelCommandLine = noapic
guiApplications = false
nestedVirtualization = false

# Remove Hyper-V components
dism /Online /Disable-Feature:Microsoft-Hyper-V /All
dism /Online /Disable-Feature:Microsoft-Hyper-V
dism /Online /Disable-Feature:VirtualMachinePlatform
bcdedit /set hypervisorlaunchtype off

systeminfo | find "Hyper-V"


wsl.exe --list --online
wsl.exe --list --verbose
wsl.exe --status


