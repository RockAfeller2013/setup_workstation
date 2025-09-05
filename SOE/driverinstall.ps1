# Define the direct download URL
$driverUrl = "https://us.download.nvidia.com/Windows/581.15/581.15-desktop-win10-win11-64bit-international-dch-whql.exe"

# Path to save the installer
$installerPath = "C:\Temp\nvidia-installer.exe"

# Create Temp directory if it doesn't exist
if (-not (Test-Path "C:\Temp")) {
    New-Item -Path "C:\" -Name "Temp" -ItemType Directory
}

# Download the installer
Invoke-WebRequest -Uri $driverUrl -OutFile $installerPath

# Install the driver silently
Start-Process -FilePath $installerPath -ArgumentList "-s" -Wait

# Cleanup
Remove-Item -Path $installerPath

# Optional: reboot after installation
# Restart-Computer -Force
