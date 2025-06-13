<#
.SYNOPSIS
Cleans VMware Workstation inventory file
#>

# Define paths
$invPath = "$env:APPDATA\VMware\inventory.vmls"
$backup = "$invPath.bak"

# Step 1: Verify VMware is closed
Write-Output "Make sure VMware Workstation is closed before continuing..."

# Step 2: File operations
try {
    if (Test-Path $invPath) {
        Write-Output "Found inventory file at: $invPath"
        
        # Create backup
        Copy-Item -Path $invPath -Destination $backup -Force
        Write-Output "Backup created: $backup"
        
        # Remove original
        Remove-Item -Path $invPath -Force
        Write-Output "Original inventory file removed"
    }
    else {
        Write-Output "No inventory file found - nothing to clean up"
    }
}
catch {
    Write-Output "ERROR: $_"
    exit 1
}

# Completion
Write-Output "`nOperation complete. Launch VMware to see changes."
