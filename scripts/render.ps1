<#
  Render carousel HTML -> PNG 1080x1350 per slide (Windows).
  Pakai:  powershell -ExecutionPolicy Bypass -File render.ps1 -Html "<TOPIK>\_source\carousel.html" -OutDir "<TOPIK>"
  Hasil:  <OutDir>\slide-01.png, slide-02.png, ...
#>
param(
  [Parameter(Mandatory=$true)][string]$Html,
  [Parameter(Mandatory=$true)][string]$OutDir
)
$ErrorActionPreference = 'Stop'

$candidates = @(
  "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
  "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
  "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe",
  "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
  "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe"
)
$browser = $candidates | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
if (-not $browser) { throw "Chrome atau Edge tidak ditemukan. Install Google Chrome dulu." }

$Html   = (Resolve-Path -LiteralPath $Html).Path
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
$OutDir = (Resolve-Path -LiteralPath $OutDir).Path

$count = ([regex]::Matches((Get-Content -LiteralPath $Html -Raw -Encoding UTF8), '<section class="slide')).Count
if ($count -lt 1) { throw "Tidak ada <section class=""slide""> di $Html" }

$uri = ([uri]$Html).AbsoluteUri
for ($i = 1; $i -le $count; $i++) {
  $out = Join-Path $OutDir ("slide-{0:00}.png" -f $i)
  # Chrome menulis log ke stderr; jangan dianggap error oleh PowerShell
  $ErrorActionPreference = 'Continue'
  & $browser --headless=new --disable-gpu --hide-scrollbars --allow-file-access-from-files `
    --force-device-scale-factor=1 --window-size=1080,1350 --virtual-time-budget=8000 `
    "--screenshot=$out" "$uri`?s=$i" 2>$null | Out-Null
  $ErrorActionPreference = 'Stop'
  if (-not (Test-Path -LiteralPath $out)) { throw "Gagal render slide $i" }
  Write-Host ("OK  " + $out)
}
Write-Host "Selesai: $count slide -> $OutDir"
