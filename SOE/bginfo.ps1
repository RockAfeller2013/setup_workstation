# --- BGINFO configure ---
$bgExe = "C:\ProgramData\chocolatey\bin\Bginfo64.exe"
$bgDst = "C:\ProgramData\bginfo.bgi"
$bgUrl = "https://raw.githubusercontent.com/RockAfeller2013/setup_workstation/main/bginfo.bgi"

if (-not (Test-Path $bgDst)) {
    try {
        Invoke-WebRequest -Uri $bgUrl -OutFile $bgDst -UseBasicParsing
        Write-Output "Downloaded BgInfo config to $bgDst"
    } catch {
        Write-Warning "Failed to download BgInfo config: $($_.Exception.Message)"
    }
}

if (Test-Path $bgExe) {
    try {
        & $bgExe $bgDst /accepteula /silent /timer:0
        Write-Output "BgInfo applied."
    } catch {
        Write-Warning "Failed to execute BgInfo: $($_.Exception.Message)"
    }
} else {
    Write-Warning "BgInfo executable not found at $bgExe"
}
