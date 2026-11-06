<#
  INSTALLER - StudentWorld Carousel Skill (Windows)

  Cara pakai (klik kanan file ini > Run with PowerShell, atau jalankan):
      powershell -ExecutionPolicy Bypass -File .\install.ps1

  Opsi:
      -Target claude   (default) pasang ke Claude Code      -> %USERPROFILE%\.claude\skills\
      -Target codex               pasang ke Codex           -> %USERPROFILE%\.codex\skills\
      -Target both                pasang ke keduanya
      -Dest "C:\path\skills"      pasang ke folder skills lain (untuk uji coba)

  Yang dipasang: folder "studentworld-carousel" LENGKAP (SKILL.md + assets logo/font/hero banner + template + script).
  Installer bisa dijalankan ulang untuk update; versi lama diganti.
#>
param(
  [ValidateSet('claude','codex','both')][string]$Target = 'claude',
  [string]$Dest
)
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$src  = Join-Path $here 'studentworld-carousel'
if (-not (Test-Path -LiteralPath (Join-Path $src 'SKILL.md'))) {
  throw "Folder 'studentworld-carousel' tidak ditemukan di samping install.ps1. Ekstrak seluruh isi ZIP dulu, jangan jalankan dari dalam ZIP."
}

$targets = @()
if ($Dest) { $targets += $Dest }
else {
  if ($Target -in 'claude','both') { $targets += (Join-Path $env:USERPROFILE '.claude\skills') }
  if ($Target -in 'codex','both')  { $targets += (Join-Path $env:USERPROFILE '.codex\skills') }
}

foreach ($t in $targets) {
  New-Item -ItemType Directory -Force -Path $t | Out-Null
  $to = Join-Path $t 'studentworld-carousel'
  if (Test-Path -LiteralPath $to) { Remove-Item -LiteralPath $to -Recurse -Force }
  Copy-Item -LiteralPath $src -Destination $to -Recurse -Force

  # verifikasi
  $need = @('SKILL.md','assets\1. HERO BANNER WEB','assets\2. LOGO\SWID-TEXT-WHT.png','assets\2. LOGO\SWID-TEXT-MAIN.png','assets\3. FONTS','template\carousel.html','scripts\render.ps1')
  $miss = $need | Where-Object { -not (Test-Path -LiteralPath (Join-Path $to $_)) }
  if ($miss) { throw "Instalasi tidak lengkap, file hilang: $($miss -join ', ')" }
  Write-Host "[OK] Terpasang di: $to" -ForegroundColor Green
}

$chrome = @("$env:ProgramFiles\Google\Chrome\Application\chrome.exe","${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe","$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe","${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe") | Where-Object { Test-Path $_ }
if (-not $chrome) { Write-Host "[!] Google Chrome / Edge belum terdeteksi. Install Chrome supaya bisa render PNG." -ForegroundColor Yellow }

Write-Host ""
Write-Host "Selesai. Langkah berikutnya:" -ForegroundColor Cyan
Write-Host "  1. TUTUP lalu buka ulang Claude Code / Codex (supaya skill terbaca)."
Write-Host "  2. Ketik:  /studentworld-carousel  topik: <topik kamu>"
Write-Host "     atau tulis biasa: 'Buatkan carousel StudentWorld tentang <topik>'"
