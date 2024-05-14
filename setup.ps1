Create Desktop folder GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}
Choco install
https://gist.github.com/hotoo/452523

# change computer name
# setup hostname
# setup IP
# setup NTP/timezone
# setup DNS

Disable updates / SCONFIG and set updates to Manual

shell:startup
@Echo Stopping the Windows Update Service ...
@echo off
Net stop wuauserv
@echo ***********************************
@Echo Disabling the Windows Update Service ...
@echo off
sc config "wuauserv" start=disabled
@echo ***********************************
@echo Finished ....
pause

# God Mode
https://answers.microsoft.com/en-us/insider/forum/all/god-mode-other-windows-10-tips-tricks/9e81e023-9179-4b59-9937-f1e9aab537b4

# Disable firewall
netsh advfirewall set allprofiles state off

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
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

"C:\ProgramData\chocolatey\bin\Bginfo64.exe /timer:0 /silent /nolicprompt /accepteula /ALL"

C:\BGInfo\Bginfo.exe /silent /accepteula /nolicprompt /timer:00 BGconfig.bgi

sc config wuauserv start= disabled
Set-MpPreference -DisableRealtimeMonitoring $false

slmgr.vbs /ipk <your_product_key>
slmgr.vbs /ato
slmgr.vbs /dlv

https://github.com/chocolatey/chocolatey-environments/blob/master/scripts/PrepareWindows.ps1



