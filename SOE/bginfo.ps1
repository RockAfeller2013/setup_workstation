& "C:\ProgramData\chocolatey\bin\Bginfo64.exe"  /accepteula /silent /timer:0

Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" `
  -Name "BgInfo" `
  -Value '"C:\ProgramData\chocolatey\bin\Bginfo64.exe" /accepteula /silent /timer:0'
