---
name: studentworld-carousel
description: Membuat carousel Instagram StudentWorld Indonesia (7 slide, 1080x1350) dari satu topik, dengan model foto AI. Gunakan saat user minta "buatkan carousel", "konten IG StudentWorld", "desain postingan SWID", atau memberi topik kuliah luar negeri (SAT, IELTS, visa, beasiswa, kampus, negara) untuk dijadikan carousel. Sudah memuat logo, font, hero banner web, template, dan aturan desain brand.
---

# StudentWorld Carousel Maker

Skill ini membuat **carousel Instagram StudentWorld Indonesia** dari sebuah topik, lalu mengekspornya sebagai PNG ke folder bernama sesuai topik.

> **Lokasi skill:** folder tempat file `SKILL.md` ini berada. Sebut saja `SKILL_DIR`.
> Biasanya `~/.claude/skills/studentworld-carousel` (Claude Code) atau `~/.codex/skills/studentworld-carousel` (Codex).
> Semua aset (logo, font, hero banner) ada di `SKILL_DIR/assets/`. **Jangan** mencari aset di tempat lain dan **jangan** mengubah isinya.

## Isi paket

```
SKILL_DIR/
├─ SKILL.md                ← file ini (alur + aturan)
├─ assets/
│  ├─ 1. HERO BANNER WEB/  ← screenshot hero banner web (untuk layar mockup laptop)
│  ├─ 2. LOGO/             ← SWID-TEXT-WHT.png (slide biru), SWID-TEXT-MAIN.png (slide terang)
│  └─ 3. FONTS/            ← Plus Jakarta Sans + Poppins (lisensi OFL)
├─ template/carousel.html  ← template 7 pola slide (siap pakai)
├─ scripts/render.ps1|sh   ← HTML -> PNG per slide
├─ references/ref-01..12   ← 12 postingan IG asli perusahaan (acuan gaya, BUKAN untuk dipublikasi ulang). ref-06..12 = 7 varian cover slide 1
└─ examples/SAT-Buat-Siapa ← contoh hasil jadi lengkap (7 slide + HTML + cutout model)
```

Sebelum mulai pertama kali, **lihat** 2–3 gambar di `references/` dan `examples/SAT-Buat-Siapa/` (pakai tool Read pada gambar) supaya gaya visualnya tertanam.

---

## ALUR KERJA (ikuti urutan ini, jangan lompat)

### Langkah 1. Terima topik
- Input minimal: **topik** (contoh: "SAT Buat Siapa? Panduan Pilih Kampus untuk Kuliah Luar Negeri").
- **Setelah topik diterima, tanyakan varian cover** dengan rekomendasi sesuai topik (aturan lengkap di Langkah 4A). Jangan membuat outline sebelum user memilih, kecuali user sudah menyebut varian.
- Jika user memberi **link artikel**, baca isinya (WebFetch / tool baca web). Itu sumber fakta utama.
- Jika tidak ada sumber, tanya sekali: "Ada artikel/sumber yang jadi acuan? Kalau tidak, saya susun dari pengetahuan umum dan tandai hal yang perlu dicek." Jangan menunda lama; lanjut jika user bilang bebas.
- **Dilarang mengarang fakta**: angka skor, nama kampus, biaya, kuota, tanggal, aturan visa. Hanya pakai yang ada di sumber. Kalau sumber tidak menyebut angka, jangan tambahkan angka. Parafrase, jangan menyalin kalimat artikel mentah.

### Langkah 2. Susun outline 7 slide (tampilkan ke user ringkas, lalu lanjut)
Default **7 slide**. Pola dan tema:

| # | Tema | Pola | Fungsi |
|---|---|---|---|
| 1 | Biru | COVER + foto model (pilih salah satu dari 8 varian di Langkah 4A) | Hook: pertanyaan/pernyataan memancing + punchline kiri bawah |
| 2 | Terang | LIST bernomor (4 poin) | Jawaban inti / kerangka |
| 3 | Biru | CARDS (3 kartu kaca + pill) | Perbandingan / kategori |
| 4 | Terang | CHECK (checklist + kutipan stabilo) | Hal yang harus dicek |
| 5 | Biru | GRID (4 tile kaca + kotak penutup) | Kasus/negara lain atau detail |
| 6 | Terang | ICONS (4 poin + ikon vektor) | Pertanyaan penentu / kesimpulan |
| 7 | Biru | CTA + mockup laptop | "CEK REKOMENDASI UNIVERSITAS — Gratis 5 Menit, Link Di Bio" |

Aturan outline:
- **Tema biru & terang SELALU selang-seling**. Slide 1 dan slide terakhir selalu biru.
- Slide terakhir **selalu** CTA dengan mockup laptop hero banner web (teks CTA tidak diubah).
- Boleh menambah/mengurangi slide isi (5–9 total) bila topik butuh, tapi pertahankan selang-seling dan pola.
- Satu slide = satu ide. Maksimal 4 poin per slide.
- Urutan cerita: Hook → Jawaban → Rincian → Cek → Kesimpulan → CTA.

### Langkah 3. Siapkan folder kerja
Nama folder = **nama topik** (bersihkan karakter terlarang Windows `\ / : * ? " < > |`, ganti spasi ganda; contoh `SAT Buat Siapa`). Buat di **folder kerja saat ini** (cwd) kecuali user menyebut lokasi lain.

```
<cwd>/<Nama Topik>/
├─ slide-01.png ... slide-07.png   ← HASIL AKHIR (diisi di langkah 7)
└─ _source/
   ├─ carousel.html                ← salinan template yang sudah diisi
   ├─ model-cutout.png             ← foto model AI latar transparan
   └─ assets/                      ← salinan SKILL_DIR/assets (logo, font, hero banner)
```

Salin: `SKILL_DIR/template/carousel.html` → `_source/carousel.html` dan `SKILL_DIR/assets` → `_source/assets`.

### Langkah 4A. Pilih VARIAN COVER slide 1
Cover tidak harus selalu satu gaya. Ada **8 varian** (A–H). **Lihat dulu gambar referensinya (tool Read)** sebelum memilih. Aturan memilih:
- **WAJIB TANYA USER sebelum membuat outline/foto.** Setiap ada permintaan konten baru, berhenti sebentar dan tanyakan varian cover mana yang dipakai. Sajikan **rekomendasi untuk topik tersebut** (1 pilihan utama + 1–2 alternatif, masing-masing dengan alasan singkat), lalu tunggu jawaban. Gunakan tool tanya-jawab bila tersedia (mis. AskUserQuestion), kalau tidak, tulis di chat. Format:
  > Topik: "<topik>". Untuk cover slide 1, rekomendasi saya:
  > 1. **Varian X: <nama>** (disarankan): <alasan sesuai topik>
  > 2. **Varian Y: <nama>**: <alasan>
  > 3. **Varian Z: <nama>**: <alasan>
  > Daftar lengkap A–H ada di tabel; mau pakai yang mana?
  Jika user sudah menyebut varian di permintaannya, **jangan tanya lagi**, langsung pakai. Jika user menjawab "terserah", pakai rekomendasi utama dan sebutkan pilihannya di laporan.
- Saat memberi rekomendasi, **jangan merekomendasikan varian yang sama dengan carousel sebelumnya** (kalau diketahui) supaya feed tidak monoton.
- Semua varian tetap memakai: header logo + tagline, latar biru, grain halus, foto subjek **menembus tepi bawah**, headline di 15–38% bagian atas, headline **tidak menutupi wajah**.
- **Semua orang di gambar WAJIB hasil AI** (fiktif), bukan wajah orang nyata.

| Varian | Referensi | Kapan dipakai | Ciri visual |
|---|---|---|---|
| **A. Mendongak (default)** | `examples/SAT-Buat-Siapa/`, ref-01..05 | topik umum, tips, persiapan tes | model high-angle mendongak, seluruh badan, latar kobalt polos. Detail di "Gaya foto" di bawah |
| **B. Gestur Frontal** | ref-06 | pertanyaan galau / pilihan ("Mau ke mana?", "Pilih mana?") | model dari pinggang ke atas, **menghadap depan**, kedua tangan terbuka (angkat bahu), ekspresi ragu. Baju seragam/cardigan + dasi/biru navy. Headline 2 tingkat: baris kecil regular Title Case + baris **sangat besar ExtraBold Title Case** (2 baris), tengah, putih polos |
| **C. Konsep Metafora** | ref-07 | beda level/perbandingan, "versi dirimu di masa depan" | satu adegan konsep: cermin/pintu/jendela yang memperlihatkan masa depan (landmark negara tujuan, paspor, hoodie kampus). Model dari belakang. Latar gradasi biru muda (atas) → navy (bawah). Headline HURUF KAPITAL 2 tingkat (atas kecil, bawah besar) + 1 baris subjudul kecil Title Case |
| **D. Dramatis Sorotan** | ref-08 | aturan berubah, risiko, "Plan B", topik serius | latar navy gelap + cahaya sorot cyan di pojok kanan atas; **kelompok 3–4 orang** (mis. orang tua/pakar) close-up dari bawah, pencahayaan studio dramatis. Headline **miring (italic)** ExtraBold KAPITAL + satu frasa Title Case lebih kecil, gradasi silver, bayangan lembut |
| **E. Objek / Bangunan** | ref-09 | validasi, kampus/institusi, profesi baru | cutout foto bangunan/landmark **memenuhi bagian bawah**, tepi bawah terpotong layar. Headline 3 tingkat: KAPITAL besar / Title Case kecil di tengah / KAPITAL besar. **Foto bangunan/kampus nyata hanya dari sumber resmi atau izin kampus**; kalau tidak ada, pakai ilustrasi/render AI tanpa logo |
| **F. Trio Jurusan** | ref-10 | "3 jurusan", daftar program/profesi unik | 2–3 model AI berkelompok, saling tumpang, menatap ke atas sambil berpikir; **seragam + properti khas tiap jurusan** (jas lab + gelas, jaket lapangan, binokular). Angka besar di headline ("3 JURUSAN"), baris tengah kecil, kata kunci KAPITAL besar. Boleh ada cahaya ungu-biru lembut di kiri-kanan |
| **G. Meja dari Atas** | ref-11 | riset, AI/teknologi, cek ulang, tips belajar | kamera dari atas, model mengintip di atas laptop (kacamata, mata lebar), **meja putih di bagian bawah** dengan properti (notebook, ponsel, buku biru, botol). Headline KAPITAL 2 baris + subjudul Title Case kecil. Grain biru lebih terasa |
| **H. Kasual Langit** | ref-12 | pertanyaan "mulai dari mana?", topik ringan/relatable | model dewasa/santai (topi, kacamata hitam, kemeja navy) dari atas, latar biru **langit dengan awan lembut**, meja berisi buku/notebook di bawah. Headline KAPITAL ExtraBold + baris Title Case ringan di bawahnya |

**Gaya headline cover (berlaku untuk semua varian):**
- Selalu **campuran ukuran dan bobot**: kata kunci sangat besar & ExtraBold, kata penghubung kecil & ringan ("Tapi", "Ini Beneran Ada Di").
- Gradasi putih→silver tipis dan `text-shadow` lembut (`0 6px 20px rgba(0,20,90,.35)`) agar terbaca di atas foto.
- Letter-spacing rapat (`-.05em` s/d `-.065em`), `line-height:.9`; tiap baris muat dengan margin ≥ 60px.
- Maksimal 3 baris. Slide 2–7 tetap memakai template biasa.

**Cara menerapkan:** ubah hanya `<section>` slide 1 di `_source/carousel.html` (headline, posisi/ukuran `.model`, latar). Latar khusus (cahaya sorot, awan, glow ungu, meja) dibuat dengan CSS `radial-gradient`/`linear-gradient` atau **disatukan ke dalam gambar AI** (minta generator membuat latar/meja sekaligus). Varian yang gambarnya sudah berlatar (C, D, E, G, H) boleh **tanpa remove-background**; simpan sebagai `_source/model-cutout.png` atau `_source/cover.png` dan pakai sebagai `background`/`img` penuh.

### Langkah 4. Buat foto model AI
Model **wajib AI-generated** (tidak ada foto model asli). Targetnya: **sangat mirip gaya referensi** varian yang dipilih di 4A. Bagian di bawah adalah **varian A (default)**; untuk varian lain, pertahankan semua yang sama (tanpa teks/logo, studio commercial look, palet biru/putih) dan ganti pose/komposisi sesuai tabel 4A.

**Prompt tambahan per varian (gabungkan dengan template prompt di bawah, ganti bagian pose):**
- **B:** "waist-up shot, facing the camera straight on, both hands open in a shrug gesture, unsure skeptical expression, wearing navy cardigan over white shirt with striped blue tie, black backpack straps visible."
- **C:** "young man seen from behind looking into a tall standing mirror; the reflection shows a happier version of him in [landmark/city of destination] holding a passport and boarding pass, wearing a [country] university hoodie."
- **D:** "four well-dressed Indonesian mature professionals in dark blazers, close-up from slightly below, serious calm expressions, dramatic studio lighting, deep navy background with a cyan light flare from the top right."
- **E:** "wide photo of a [modern university building] with glass facade, clear sky, cut-out ready, no readable logos."
- **F:** "three young Indonesian students grouped closely, looking up and thinking, each wearing outfit and prop specific to a different [course/profession], high-angle, blue studio background with soft purple-blue glow on both sides."
- **G:** "top-down high-angle shot of a young Indonesian woman with glasses peeking over her laptop, eyes wide, white desk at the bottom with notebook, pen, phone, blue books and water bottle, cobalt blue background."
- **H:** "high-angle shot of a casual Indonesian man in a cap and sunglasses, navy overshirt and white t-shirt, leaning on a wooden desk with notebook and books, soft blue sky with faint clouds in the background."

**Gaya foto varian A (wajib untuk A):**
- Mahasiswa muda Indonesia/Asia, **sudut dari atas (high-angle, extreme foreshortening)**, **mendongak menatap kamera** dengan ekspresi kuat (bingung / penasaran / kaget / mengintip dari balik kacamata).
- Seluruh badan terlihat, sepatu putih kecil di bawah.
- Latar studio **biru kobalt polos** (#0A4FE0), cahaya studio lembut, bayangan lantai lembut, tampilan iklan komersial.
- Pakaian & properti **bernuansa biru/putih dan sesuai topik** (jas dokter + stetoskop untuk kedokteran; laptop + notes untuk riset; lembar tes + pensil untuk SAT/IELTS; paspor untuk visa).
- Tanpa teks, logo, atau watermark di foto.

**Template prompt** (ganti bagian [..]):
> Professional studio advertising photo, extreme high-angle shot from above looking down at a young Indonesian [female/male] university student standing, tilting head up and looking directly into the camera with a [confused / curious / surprised] expression, [lips slightly parted, one eyebrow raised]. [Hair & glasses], wearing [cobalt blue knit sweater / white coat over navy scrubs / ...] with a black backpack, holding [prop sesuai topik]. Full body visible, small white sneakers at the bottom, strong foreshortening perspective. Seamless solid cobalt royal blue studio background (#0A4FE0), soft diffused studio lighting, soft blue shadow on the floor, clean commercial campaign look, sharp focus, high resolution. No text, no logos, no watermark.

Gunakan aspect ratio **PORTRAIT_4_5**. Variasikan model (gender, gaya rambut, ekspresi) antar topik supaya feed tidak monoton.

**Cara generate (urutan prioritas):**
1. **Canva connector** (tool `generate-image`, lalu `remove-background`) bila tersedia di sesi ini. Cek dengan ToolSearch "canva generate-image". Alurnya:
   1. `generate-image` (prompt di atas) → tunggu job (`get-generate-image-job`) → dapat `MEDIA id`.
   2. `remove-background` pada media itu → dapat `MEDIA id` cutout.
   3. **Mengunduh file resolusi penuh**: URL thumbnail Canva dan link media langsung **ditolak (HTTP 403)**; jangan mencoba menembusnya. Gunakan jalur resmi ini:
      - `create-design` (format Instagram Post) → baca dengan `read-design` (`open_transaction: true`) → `edit-design` `add_page` ukuran **1136x1408** → ambil id halaman baru lewat `read-design` + `transaction_id` + `filter.page_indices` (`page_metadata` tidak menampilkan halaman draf) → `edit-design` `insert_fill` (asset id cutout, left 0, top 0, 1136x1408) → `finalize: commit` → `export-design` PNG, `pages:[nomor halaman]`, `transparent_background: true`, `export_quality: pro` → unduh URL hasil ekspor.
   4. Simpan sebagai `_source/model-cutout.png`. Verifikasi alpha (sudut = 0, tengah = 255).
   5. Desain sementara di akun Canva boleh dibiarkan; sebutkan ke user bahwa itu bisa dihapus.
2. **Tool pembuat gambar lain** yang tersedia di sesi (MCP image generation, dll.) → hasilnya dihapus latarnya dulu.
3. **Tidak ada tool gambar sama sekali** → jangan memalsukan. Beri tahu user, berikan prompt di atas untuk dipakai di generator pilihan mereka (Canva, Gemini, dll.), minta mereka simpan hasilnya sebagai `_source/model-cutout.png`, lalu lanjutkan. Sementara itu, boleh render slide dengan placeholder dan tandai jelas.

Catatan resolusi: generator Canva menghasilkan ±1136x1408. Versi "2K" hanyalah perbesaran. Cukup untuk slide 1080x1350.

**Catatan teknis PowerShell:** nama file ber-`[ ]` (mis. `PlusJakartaSans[wght].ttf`) bermasalah dengan `Invoke-WebRequest -OutFile` karena dianggap wildcard. Unduh dengan `(New-Object System.Net.WebClient).DownloadFile($url,$path)`.

### Langkah 5. Isi template
Edit `_source/carousel.html`. Isi bawaan adalah contoh "SAT Buat Siapa?"; **ganti seluruh teksnya** sesuai topik. Jangan mengubah CSS/struktur kecuali perlu. Hal yang boleh disesuaikan:
- Teks headline/subjudul/poin; `font-size` headline agar muat (lihat aturan di bawah).
- Slide 1: posisi `.model` (left/top/width) dan `.floor` bila model beda proporsi; isi `.chip` (3 chip) dan `.punch`.
- Slide 6: ikon SVG (lihat aturan ikon).
- Slide 7: **jangan ubah** mockup laptop dan teks CTA, kecuali headline atas.
- Menambah slide: salin satu `<section class="slide ...">` dengan pola yang sesuai, pertahankan atribut `data-hdr`.

### Langkah 6. Render & periksa visual (WAJIB, minimal 1 putaran perbaikan)
Windows:
```powershell
powershell -ExecutionPolicy Bypass -File "SKILL_DIR\scripts\render.ps1" -Html "<Topik>\_source\carousel.html" -OutDir "<Topik>"
```
macOS/Linux:
```bash
bash "SKILL_DIR/scripts/render.sh" "<Topik>/_source/carousel.html" "<Topik>"
```
Lalu **buka setiap PNG dengan tool Read** dan cek (lihat "Checklist QA"). Perbaiki → render ulang. Jangan lapor selesai sebelum semua slide diperiksa.

### Langkah 7. Serahkan hasil
Laporkan singkat: lokasi folder, daftar file, ringkasan isi tiap slide, dan **hal yang perlu dicek manusia** (fakta dari sumber, foto AI, kebijakan label AI perusahaan). Tawarkan revisi. Jika sesi mendukung kirim file/preview, kirim ketujuh PNG.

---

## ATURAN DESAIN BRAND (wajib)

**Format:** 1080x1350 (4:5), carousel 7 slide.

**Header (semua slide):** kiri atas **logo asli** (`assets/2. LOGO`, lebar 250px; versi PUTIH untuk slide biru, versi MAIN untuk slide terang), kanan atas tagline **"APPLY TODAY / SHAPE TOMORROW"** (Poppins ExtraBold 27px). Margin samping ±94px, atas 70px. Header sudah ada di template; jangan digeser.

**Dua tema:**
- **Biru:** gradasi radial kobalt (`#1766F5` → `#0A4FE0` → `#0534A6`) + grain halus. Teks putih; headline gradasi putih→silver tipis.
- **Terang:** putih ke biru sangat muda + blob biru pastel + watermark huruf besar outline tipis. Teks navy `#0B3C9E`; aksen sky `#3B9BE5`; tagline: APPLY TODAY navy, SHAPE TOMORROW sky.
- Aksen: kuning stabilo `#F5E53A` (kutipan/angka/pill), kotak **kaca** (glassmorphism) di slide biru, bar kutipan hitam. Jangan menambah warna lain.

**Tipografi (hanya 2 font, sudah ada di `assets/3. FONTS`):**
- **Plus Jakarta Sans** untuk semua isi. **Poppins** hanya untuk logo-teks/tagline.
- **Headline:** HURUF KAPITAL, ExtraBold (800), `letter-spacing:-.065em`, `line-height:.9`, posisi tengah sepertiga atas (cover/biru) atau rata kiri (terang). `white-space:nowrap`: **pastikan tiap baris muat** dalam lebar 1080 dengan margin ≥ 60px; kecilkan `font-size` atau pecah dengan `<br>`.
- **Subjudul/isi:** **Title Case Di Setiap Kata**, Medium (500) campur Bold/ExtraBold untuk penekanan. Teks pendukung di slide terang boleh *italic*.
- Ukuran minimum teks isi: 24px (tile), disarankan ≥ 29px. Jangan memakai font lain.

**Foto:** sesuai Langkah 4 dan varian cover di 4A. Satu foto/komposisi utama per carousel (slide 1). Slide lain memakai ilustrasi/elemen vektor, bukan foto stok.

**Ikon: VEKTOR SVG GARIS, DILARANG EMOJI.** Gaya: `stroke` navy `#0B3C9E` 3.2px, `round` cap/join, tanpa fill; satu elemen aksen `stroke` sky `#3B9BE5`; diletakkan di dalam kotak putih 96x96px dengan sudut membulat 24px. Contoh ada di slide 6 template. Emoji boleh muncul hanya di teks bila memang gaya referensi (mis. 👀) dan **tidak sebagai ikon**.

**Copywriting:**
- Bahasa Indonesia santai-edukatif: "Mau", "Nggak", "Cuma", "Kamu", campur istilah Inggris yang lazim (WHV, Medical School, Prospectus).
- Hook berupa pertanyaan atau rasa penasaran. Nada **mengingatkan**, bukan jualan keras.
- Judul pendek (≤ 5 kata per baris). Poin ≤ 8 kata.
- Slide CTA selalu: **"CEK REKOMENDASI UNIVERSITAS"** + "Gratis 5 Menit, Link Di Bio".

**Mockup laptop (slide 7):** layar = screenshot hero banner web (`assets/1. HERO BANNER WEB`), rasio 1828:1113. Jangan menggambar ulang isi layar. Bila ada screenshot baru, ganti file di `assets/1. HERO BANNER WEB` dan perbarui path di CSS `.screen`.

---

## CHECKLIST QA (centang semua sebelum lapor selesai)

- [ ] Logo asli tampil di semua slide (putih di biru, berwarna di terang) dan tidak terpotong.
- [ ] Tema selang-seling; slide 1 & terakhir biru.
- [ ] Tidak ada teks terpotong, bertabrakan, atau keluar margin; headline tidak menyentuh header (jarak ≥ 40px).
- [ ] Teks tidak menutupi wajah model; kaki/ujung properti tidak menabrak teks punchline.
- [ ] Semua teks Title Case, tanpa typo; angka/nama kampus hanya yang ada di sumber.
- [ ] Ikon vektor, tanpa emoji sebagai ikon.
- [ ] Varian cover sudah **ditanyakan ke user dengan rekomendasi sesuai topik** (atau user sudah menyebutnya), dipilih (A–H), dan ditulis di laporan.
- [ ] Foto model: latar sudah transparan bila varian memakai cutout (tidak ada halo/tepi biru kasar); komposisi sesuai varian yang dipilih.
- [ ] Semua orang di foto fiktif (AI); foto bangunan/kampus nyata hanya bila ada izin/sumber resmi.
- [ ] Slide CTA lengkap dengan mockup laptop dan "Gratis 5 Menit, Link Di Bio".
- [ ] 7 PNG ada di folder `<Nama Topik>/`, ukuran 1080x1350.

## JANGAN

- Jangan mengubah/menimpa file di `assets/` atau menukar font/logo/warna.
- Jangan membuat konten yang menjanjikan hasil ("pasti diterima", "dijamin lolos"). Gunakan bahasa hati-hati ("belum tentu", "tergantung", "cek lagi").
- Jangan memakai foto orang nyata, logo kampus, atau merek lain tanpa izin user.
- Jangan menyalin ulang postingan di `references/` (itu hanya acuan gaya).
- Jangan lapor "selesai" tanpa membuka PNG hasil render.

## Catatan untuk Codex

Aturan, template, dan script identik. Jika Codex tidak mendukung format skill di versi yang dipakai, taruh isi file ini di `AGENTS.md` pada folder kerja dan arahkan `SKILL_DIR` ke folder paket. Alur dan perintah render sama.
