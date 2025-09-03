# Here’s the Chocolatey section updated with logging. It will create C:\choco_install_log.txt with results for each app.
# --- Applications via Chocolatey with logging ---
$logFile = "C:\choco_install_log.txt"
if (Test-Path $logFile) { Remove-Item $logFile -Force }

function Install-ChocoPackage {
    param([Parameter(Mandatory)][string]$Id)

    $found = choco search $Id --exact --limit-output 2>$null |
        ForEach-Object { ($_ -split '\|')[0] } |
        Where-Object { $_ -eq $Id }

    if ($found) {
        Write-Output "Installing: $Id" | Tee-Object -FilePath $logFile -Append
        Start-Process -FilePath "choco" -ArgumentList @("install",$Id,"-y","--ignore-checksums") -Wait
        Write-Output "Installed: $Id" | Tee-Object -FilePath $logFile -Append
    } else {
        Write-Output "Skipping (not found): $Id" | Tee-Object -FilePath $logFile -Append
    }
}

$apps = @(
  "googlechrome","7zip.install","bginfo","vlc","git","nodejs-lts","python",
  "openjdk","docker-desktop","vscode","neovim","curl","wget","httpie",
  "notepadplusplus","sysinternals","everything","awscli","azure-cli","kubernetes-cli",
  "google-cloud-sdk","putty","winscp","filezilla","rufus","foxitreader","thunderbird",
  "mremoteng","cmder","x64dbg.portable","ollydbg","powershell-core"
)

foreach ($app in $apps) {
    Install-ChocoPackage -Id $app
}

Write-Output "Chocolatey installation completed. Log saved at $logFile"
