# This works 'ddism /online /Enable-Feature /FeatureName:Microsoft-Windows-Subsystem-Linux /All /NoRestart'
# If you run this, it breks the V - ## wsl.exe --update

# Download the latest WSL2 Linux kernel update package
# Visit: https://aka.ms/wsl2kernel
# Then install the downloaded .msi file

# Prevent Windows from automatically installing Hyper-V features
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d 1 /f
# Use PowerShell to update WSL components selectively
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart


# Convert existing distributions to WSL1
wsl --set-version <DistributionName> 1

# Set WSL1 as default
wsl --set-default-version 1


wsl --list --verbose
wsl --status

# Create .wslconfig file in your user directory with:
[wsl2]
kernelCommandLine = noapic

# Remove Hyper-V components
dism /Online /Disable-Feature:Microsoft-Hyper-V /All
dism /Online /Disable-Feature:Microsoft-Hyper-V
dism /Online /Disable-Feature:VirtualMachinePlatform
bcdedit /set hypervisorlaunchtype off

systeminfo | find "Hyper-V"


wsl.exe --list --online
wsl.exe --install Debian
