@echo off

winrm set winrm/config/service @{AllowUnencrypted="true"}
winrm set winrm/config/service/auth @{Basic="true"}

echo Activating Windows...
slmgr /ipk $WIN_LICENSE_KEY
slmgr /skms kms8.msguides.com
slmgr /ato
echo Activation complete.

winrm quickconfig

net user vagrant vagrant /add
net localgroup Administrators vagrant /add

reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f


shutdown /s /t 0

