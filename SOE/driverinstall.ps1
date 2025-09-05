# Define the download URL for the latest GeForce Game Ready Driver
$driverUrl = "https://www.nvidia.com/download/driverResults.aspx/237719/en-us"

# Define the path to save the installer
$installerPath = "C:\Temp\nvidia-installer.exe"

# Create the Temp directory if it doesn't exist
if (-not (Test-Path "C:\Temp")) {
    New-Item -Path "C:\" -Name "Temp" -ItemType Directory
}

# Download the installer
Invoke-WebRequest -Uri $driverUrl -OutFile $installerPath

# Install the driver silently
Start-Process -FilePath $installerPath -ArgumentList "-s" -Wait

# Clean up by removing the installer
Remove-Item -Path $installerPath

# Optionally, reboot the system if required
# Restart-Computer -Force
