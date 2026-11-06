STUDENTWORLD CAROUSEL SKILL
===========================

CARA PASANG (PALING MUDAH, TANPA TERMINAL)
  1. Jangan ekstrak ZIP ini. Buka Claude Code atau Codex, mulai sesi baru.
  2. Seret file StudentWorld-Carousel-Skill.zip ke kolom chat.
  3. Kirim:  "Pasang skill dari ZIP ini ke Claude Code saya. Ekstrak, jalankan
     installer di dalamnya, dan pastikan 3 folder aset ikut terpasang."
     (untuk Codex: ganti "Claude Code" dengan "Codex")
  4. Klik Izinkan saat diminta. Tutup lalu buka ulang aplikasinya.
  5. Cek: ketik /studentworld-carousel

CHROMEBOOK: baca "Panduan ChromeOS StudentWorld Carousel.pdf".
PANDUAN LENGKAP: "Panduan StudentWorld Carousel.pdf".

--------------------------------------------------------------------
UNTUK CLAUDE / CODEX YANG MEMBACA FILE INI (instruksi pemasangan)
--------------------------------------------------------------------
Jika user meminta memasang skill dari ZIP ini:
  1. Ekstrak ZIP ke folder sementara baru (jangan jalankan dari dalam ZIP).
  2. Di folder hasil ekstrak ada install.ps1 (Windows), install.sh (macOS/Linux/ChromeOS)
     dan folder studentworld-carousel.
  3. Windows : powershell -ExecutionPolicy Bypass -File .\install.ps1   [-Target claude|codex|both]
     Mac/Linux: bash install.sh   [claude|codex|both]
     Default = Claude Code (~/.claude/skills). Codex = ~/.codex/skills.
  4. Pastikan keluar "[OK] Terpasang di: ..." dan folder
     studentworld-carousel/assets berisi: 1. HERO BANNER WEB, 2. LOGO, 3. FONTS.
  5. Beri tahu user untuk menutup lalu membuka ulang aplikasi, lalu cek /studentworld-carousel.
  6. Minta persetujuan user sebelum menjalankan perintah; jangan mengubah isi paket.
  7. ChromeOS/Linux: butuh Chromium (sudo apt install -y chromium) untuk render PNG.

ISI PAKET
  install.ps1 / install.sh   installer (dijalankan oleh Claude/Codex di atas)
  studentworld-carousel/     skill lengkap (SKILL.md, aset, template, script, referensi, contoh)
  Panduan *.pdf              panduan tim

Catatan: pemasangan lewat seret ZIP dan Mac/Codex/ChromeOS belum diuji langsung; Windows + Claude Code sudah.