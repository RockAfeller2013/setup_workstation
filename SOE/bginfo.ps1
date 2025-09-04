& "C:\ProgramData\chocolatey\bin\Bginfo64.exe"  /accepteula /silent /timer:0

@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: --- Config ---
set "BG_DST=C:\ProgramData\bginfo.bgi"
set "BG_URL=https://raw.githubusercontent.com/RockAfeller2013/setup_workstation/main/bginfo.bgi"

:: --- Candidate paths for Bginfo64.exe ---
set "C1=C:\ProgramData\chocolatey\bin\Bginfo64.exe"
set "C2=C:\Program Files\BGInfo\Bginfo64.exe"
set "C3=C:\Program Files\Sysinternals\Bginfo64.exe"
set "C4=%ProgramFiles(x86)%\BGInfo\Bginfo64.exe"
set "C5=%ProgramFiles(x86)%\Sysinternals\Bginfo64.exe"

for %%P in ("%C1%" "%C2%" "%C3%" "%C4%" "%C5%") do (
  if exist "%%~P" set "BG_EXE=%%~P"
)

:: --- Try installing via Chocolatey if not found ---
if not defined BG_EXE (
  where choco >nul 2>&1
  if not errorlevel 1 (
    choco install bginfo -y
    for %%P in ("%C1%" "%C2%" "%C3%" "%C4%" "%C5%") do (
      if exist "%%~P" set "BG_EXE=%%~P"
    )
  )
)

:: --- Download from Sysinternals if still missing ---
if not defined BG_EXE (
  set "ZIP=%TEMP%\bginfo.zip"
  set "EXTRACT=%TEMP%\bginfo_extracted"
  rmdir /s /q "%EXTRACT%" 2>nul
  mkdir "%EXTRACT%" >nul 2>&1
  curl -L -o "%ZIP%" "https://download.sysinternals.com/files/BGInfo.zip" ^
    || powershell -NoP -NonI -W Hidden -C "Invoke-WebRequest 'https://download.sysinternals.com/files/BGInfo.zip' -OutFile '%ZIP%'"
  powershell -NoP -NonI -W Hidden -C "Expand-Archive -Path '%ZIP%' -DestinationPath '%EXTRACT%' -Force" 2>nul ^
    || tar -xf "%ZIP%" -C "%EXTRACT%" 2>nul
  if exist "%EXTRACT%\Bginfo64.exe" (
    copy /y "%EXTRACT%\Bginfo64.exe" "C:\ProgramData\Bginfo64.exe" >nul
    set "BG_EXE=C:\ProgramData\Bginfo64.exe"
  )
)

if not defined BG_EXE (
  echo ERROR: Bginfo64.exe not found or installed.
  exit /b 1
)

:: --- Ensure .bgi exists ---
if not exist "%BG_DST%" (
  mkdir "C:\ProgramData" >nul 2>&1
  curl -L -o "%BG_DST%" "%BG_URL%" ^
    || powershell -NoP -NonI -W Hidden -C "Invoke-WebRequest '%BG_URL%' -OutFile '%BG_DST%' -UseBasicParsing"
)

:: --- Apply BgInfo profile ---
"%BG_EXE%" "%BG_DST%" /accepteula /silent /timer:0
exit /b %ERRORLEVEL%
