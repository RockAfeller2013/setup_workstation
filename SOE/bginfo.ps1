# --- BGINFO configure ---
$bgExe = "C:\ProgramData\chocolatey\bin\Bginfo64.exe"
$bgDst = "C:\ProgramData\bginfo.bgi"
$bgUrl = "https://raw.githubusercontent.com/RockAfeller2013/setup_workstation/main/bginfo.bgi"
if (-not (Test-Path $bgDst)) {
    Invoke-WebRequest -Uri $bgUrl -OutFile $bgDst -UseBasicParsing
}
if (Test-Path $bgExe) {
    & $bgExe $bgDst /accepteula /silent /timer:0
}
