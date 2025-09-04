# Here’s the Chocolatey section updated with logging. It will create C:\choco_install_log.txt with results for each app.
# --- Applications via Chocolatey with logging ---

# --- Chocolatey bootstrap ---
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
choco upgrade chocolatey -y

<#
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
#>

# Install Apps

choco install classic-shell -force -y
choco install googlechrome --ignore-checksums --force -y
choco install bginfo --force -y
choco install 7zip.install --force -y
choco install foxitreader --force -y
choco install postman --force -y
choco install insomnia-rest-api-client --force -y
choco install thunderbird --force -y
choco install mremoteng --force -y
choco install putty --force -y
choco install filezilla --force -y
choco install winscp --force -y
choco install vlc --force -y
choco install monosnap --force -y
choco install rufus --force -y
choco install brave --force -y
choco install firefox --force -y


choco install git --force -y
choco install gitkraken --force -y
choco install nodejs-lts --force -y
choco install python --force -y
choco install openjdk --force -y
choco install visualstudio2019community --force -y
choco install docker-desktop --force -y
choco install cmder --force -y
choco install vscode-insiders --force -y
choco install jetbrains-toolbox --force -y
choco install neovim --force -y

choco install curl --force -y
choco install wget --force -y
choco install httpie --force -y

choco install notepadplusplus --force -y
choco install sysinternals --force -y
choco install powershell-core --force -y
choco install everything --force -y
choco install f.lux --force -y
choco install clipjump --force -y

choco install awscli --force -y
choco install azure-cli --force -y
choco install kubernetes-cli --force -y
choco install gcp-cli --force -y
choco install docker-desktop --force -y

choco install x64dbg.portable --force -y
choco install ollydbg --force -y

choco install cursoride --force -y
choco install nvidia-broadcast --force -y
choco install claude --force -y
choco install warp-terminal --force -y
choco install windsurf --force -y
choco install pycharm-community --force -y
choco install pycharm-edu --force -y
choco install pycharm --force -y
