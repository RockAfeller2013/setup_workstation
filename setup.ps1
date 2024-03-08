Create Desktop folder GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}
Choco install
https://gist.github.com/hotoo/452523

change computer name
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



Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
choco install googlechrome --ignore-checksums --force -y
choco install bginfo --force -y
choco install 7zip.install --force -y
choco install foxitreader --force -y

"C:\ProgramData\chocolatey\bin\Bginfo64.exe /timer:0 /silent /nolicprompt /accepteula /ALL"

C:\BGInfo\Bginfo.exe /silent /accepteula /nolicprompt /timer:00 BGconfig.bgi

sc config wuauserv start= disabled


