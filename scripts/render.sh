#!/usr/bin/env bash
# Render carousel HTML -> PNG 1080x1350 per slide (macOS / Linux).
# Pakai:  bash render.sh "<TOPIK>/_source/carousel.html" "<TOPIK>"
# Hasil:  <OutDir>/slide-01.png, slide-02.png, ...
set -euo pipefail

HTML="${1:?Pakai: render.sh <carousel.html> <out-dir>}"
OUT="${2:?Pakai: render.sh <carousel.html> <out-dir>}"

find_browser() {
  local c
  for c in \
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
    "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge" \
    "$(command -v google-chrome 2>/dev/null || true)" \
    "$(command -v google-chrome-stable 2>/dev/null || true)" \
    "$(command -v chromium 2>/dev/null || true)" \
    "$(command -v chromium-browser 2>/dev/null || true)" \
    "/snap/bin/chromium"; do
    [ -n "$c" ] && [ -x "$c" ] && { echo "$c"; return; }
  done
  return 1
}
BROWSER="$(find_browser)" || { echo "Chrome/Edge tidak ditemukan. Install Google Chrome dulu." >&2; exit 1; }

HTML="$(cd "$(dirname "$HTML")" && pwd)/$(basename "$HTML")"
mkdir -p "$OUT"; OUT="$(cd "$OUT" && pwd)"
COUNT="$(grep -o '<section class="slide' "$HTML" | wc -l | tr -d ' ')"
[ "$COUNT" -ge 1 ] || { echo "Tidak ada <section class=\"slide\"> di $HTML" >&2; exit 1; }

URL_PATH="${HTML// /%20}"
for i in $(seq 1 "$COUNT"); do
  F="$OUT/slide-$(printf '%02d' "$i").png"
  # Percobaan 1: normal. Percobaan 2 (ChromeOS/Linux container): tambah --no-sandbox.
  for EXTRA in "" "--no-sandbox --disable-dev-shm-usage"; do
    # shellcheck disable=SC2086
    "$BROWSER" --headless=new --disable-gpu --hide-scrollbars --allow-file-access-from-files $EXTRA \
      --force-device-scale-factor=1 --window-size=1080,1350 --virtual-time-budget=8000 \
      --screenshot="$F" "file://${URL_PATH}?s=${i}" >/dev/null 2>&1 || true
    [ -s "$F" ] && break
  done
  [ -s "$F" ] || { echo "Gagal render slide $i" >&2; exit 1; }
  echo "OK  $F"
done
echo "Selesai: $COUNT slide -> $OUT"
