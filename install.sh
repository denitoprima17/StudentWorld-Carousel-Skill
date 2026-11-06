#!/usr/bin/env bash
# INSTALLER - StudentWorld Carousel Skill (macOS / Linux)
#
# Pakai:
#   bash install.sh                 # pasang ke Claude Code  (~/.claude/skills)
#   bash install.sh codex           # pasang ke Codex        (~/.codex/skills)
#   bash install.sh both            # keduanya
#   bash install.sh dest /path/skills   # folder skills lain (uji coba)
#
# Yang dipasang: folder "studentworld-carousel" LENGKAP (SKILL.md + assets + template + script).
# Bisa dijalankan ulang untuk update; versi lama diganti.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$HERE/studentworld-carousel"
[ -f "$SRC/SKILL.md" ] || { echo "Folder 'studentworld-carousel' tidak ditemukan di samping install.sh. Ekstrak seluruh ZIP dulu." >&2; exit 1; }

MODE="${1:-claude}"
TARGETS=()
case "$MODE" in
  claude) TARGETS+=("$HOME/.claude/skills") ;;
  codex)  TARGETS+=("$HOME/.codex/skills") ;;
  both)   TARGETS+=("$HOME/.claude/skills" "$HOME/.codex/skills") ;;
  dest)   TARGETS+=("${2:?Sebutkan folder tujuan}") ;;
  *) echo "Opsi tidak dikenal: $MODE" >&2; exit 1 ;;
esac

for T in "${TARGETS[@]}"; do
  mkdir -p "$T"
  rm -rf "$T/studentworld-carousel"
  cp -R "$SRC" "$T/studentworld-carousel"
  for f in "SKILL.md" "assets/1. HERO BANNER WEB" "assets/2. LOGO/SWID-TEXT-WHT.png" "assets/2. LOGO/SWID-TEXT-MAIN.png" "assets/3. FONTS" "template/carousel.html" "scripts/render.sh"; do
    [ -e "$T/studentworld-carousel/$f" ] || { echo "Instalasi tidak lengkap, hilang: $f" >&2; exit 1; }
  done
  chmod +x "$T/studentworld-carousel/scripts/render.sh"
  echo "[OK] Terpasang di: $T/studentworld-carousel"
done

if [ ! -x "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" ] && ! command -v google-chrome >/dev/null 2>&1 && ! command -v chromium >/dev/null 2>&1; then
  echo "[!] Chrome/Chromium belum terdeteksi. Mac/Windows: install Google Chrome. ChromeOS/Linux: sudo apt install -y chromium"
fi

echo
echo "Selesai. Langkah berikutnya:"
echo "  1. TUTUP lalu buka ulang Claude Code / Codex (supaya skill terbaca)."
echo "  2. Ketik:  /studentworld-carousel  topik: <topik kamu>"
echo "     atau tulis biasa: 'Buatkan carousel StudentWorld tentang <topik>'"
