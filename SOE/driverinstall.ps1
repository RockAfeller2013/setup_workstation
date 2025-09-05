# Define URLs
$driverUrl = "https://us.download.nvidia.com/Windows/581.15/581.15-desktop-win10-win11-64bit-international-dch-whql.exe"
$appUrl    = "https://us.download.nvidia.com/nvapp/client/11.0.5.245/NVIDIA_app_v11.0.5.245.exe"

# Define paths
$driverPath = "C:\Temp\nvidia-driver.exe"
$appPath    = "C:\Temp\nvidia-app.exe"

# Ensure Temp directory exists
if (-not (Test-Path "C:\Temp")) {
    New-Item -Path "C:\" -Name "Temp" -ItemType Directory
}

# Download and install driver
Invoke-WebRequest -Uri $driverUrl -OutFile $driverPath
Start-Process -FilePath $driverPath -ArgumentList "-s" -Wait
Remove-Item -Path $driverPath

# Download and install NVIDIA App
Invoke-WebRequest -Uri $appUrl -OutFile $appPath
Start-Process -FilePath $appPath -ArgumentList "-s" -Wait
Remove-Item -Path $appPath

# Optional reboot
# Restart-Computer -Force
