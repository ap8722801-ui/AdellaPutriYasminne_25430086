-- =====================================================================
-- Mata Kuliah : Praktikum Basis Data
-- Tugas       : Modul 7 - Menjawab Pertanyaan dengan SELECT dan Fungsi Skalar
-- Tema Proyek : Akademik 
-- Nama        : Adella Putri Yasminne
-- NIM         : 25430086
-- Kelas       : C
-- Berkas      : p07_kueri_25430086.sql
-- =====================================================================

-- Memilih basis data kerja akademik
USE akademik_086;

-- ---------------------------------------------------------------------
-- KUERI 1: Penggunaan Operator LIKE (Pencarian Pola Teks)
-- ---------------------------------------------------------------------
-- Kode KI   : KI-01
-- Pertanyaan: Siapa saja mahasiswa yang berasal dari program studi dengan kata kunci 'Teknik'?
-- Harapan   : Menampilkan daftar mahasiswa yang nama program studinya mengandung kata 'Teknik'.
SELECT 
    id_mahasiswa, 
    nim, 
    nama_mahasiswa, 
    prodi_mahasiswa, 
    angkatan
FROM mahasiswa
WHERE prodi_mahasiswa LIKE '%Teknik%';


-- ---------------------------------------------------------------------
-- KUERI 2: Penggunaan Operator BETWEEN (Rentang Nilai)
-- ---------------------------------------------------------------------
-- Kode KI   : KI-02
-- Pertanyaan: Mata kuliah apa saja yang memiliki bobot SKS antara 2 hingga 4?
-- Harapan   : Menampilkan daftar mata kuliah yang jumlah SKS-nya berada di dalam rentang tersebut.
SELECT 
    kode_mk, 
    nama_mk, 
    sks, 
    semester
FROM mata_kuliah
WHERE sks BETWEEN 2 AND 4;


-- ---------------------------------------------------------------------
-- KUERI 3: Penggunaan Operator IN (Pencocokan Nilai Majemuk)
-- ---------------------------------------------------------------------
-- Kode KI   : KI-03
-- Pertanyaan: Mahasiswa angkatan tahun berapa saja yang tercatat pada daftar tertentu (misal: '2024' atau '2025')?
-- Harapan   : Menampilkan data mahasiswa yang tahun angkatannya sesuai dengan klausul IN.
SELECT 
    id_mahasiswa, 
    nim, 
    nama_mahasiswa, 
    prodi_mahasiswa, 
    angkatan
FROM mahasiswa
WHERE angkatan IN ('2024', '2025');


-- ---------------------------------------------------------------------
-- KUERI 4: Penggunaan Operator IS NULL / IS NOT NULL (Pemeriksaan Nilai Kosong)
-- ---------------------------------------------------------------------
-- Kode KI   : KI-04
-- Pertanyaan: Apakah ada data KRS yang belum mencantumkan nama dosen wali?
-- Harapan   : Menampilkan daftar KRS yang kolom dosen walinya bernilai NULL.
SELECT 
    id_krs, 
    tahun_akademik, 
    semester, 
    id_mahasiswa
FROM krs
WHERE dosen_wali IS NULL;


-- ---------------------------------------------------------------------
-- KUERI 5: Penggunaan Fungsi String (UPPER / CONCAT)
-- ---------------------------------------------------------------------
-- Kode KI   : KI-05
-- Pertanyaan: Bagaimana tampilan nama mata kuliah digabungkan dengan kode MK dalam huruf kapital penuh?
-- Harapan   : Menampilkan gabungan kode dan nama mata kuliah dengan format string khusus.
SELECT 
    CONCAT('[', UPPER(kode_mk), '] - ', UPPER(nama_mk)) AS informasi_mata_kuliah,
    sks
FROM mata_kuliah;


-- ---------------------------------------------------------------------
-- KUERI 6: Penggunaan Fungsi Tanggal atau Format Waktu
-- ---------------------------------------------------------------------
-- Kode KI   : KI-06
-- Pertanyaan: Kapan waktu saat ini sistem diakses saat kueri pencatatan KRS dieksekusi?
-- Harapan   : Menampilkan informasi waktu saat ini menggunakan fungsi tanggal/waktu SQL.
SELECT 
    id_krs,
    tahun_akademik,
    NOW() waktu_akses_laporan
FROM krs;


-- ---------------------------------------------------------------------
-- KUERI 7: Penggunaan Kondisional CASE-WHEN
-- ---------------------------------------------------------------------
-- Kode KI   : KI-07
-- Pertanyaan: Bagaimana klasifikasi bobot SKS mata kuliah (apakah SKS Tinggi atau SKS Standar)?
-- Harapan   : Menampilkan label 'SKS Tinggi' jika SKS >= 3, atau 'SKS Standar' jika sebaliknya.
SELECT 
    nama_mk,
    sks,
    CASE 
        WHEN sks >= 3 THEN 'SKS Tinggi (Bobot Besar)'
        ELSE 'SKS Standar'
    END AS klasifikasi_sks
FROM mata_kuliah;


-- ---------------------------------------------------------------------
-- KUERI 8: Penggunaan Fungsi Matematika (ROUND / Perkalian)
-- ---------------------------------------------------------------------
-- Kode KI   : KI-08
-- Pertanyaan: Berapa estimasi konversi beban jam belajar mahasiswa jika 1 SKS setara dengan 45 menit dikali faktor pengali 1.5?
-- Harapan   : Menampilkan perhitungan matematis total menit belajar per mata kuliah.
SELECT 
    nama_mk,
    sks,
    ROUND(sks * 45 * 1.5, 0) AS estimasi_menit_belajar
FROM mata_kuliah;


-- ---------------------------------------------------------------------
-- KUERI 9: Penggunaan Klausul ORDER BY dan LIMIT
-- ---------------------------------------------------------------------
-- Kode KI   : KI-09
-- Pertanyaan: Apa 3 mata kuliah yang memiliki jumlah SKS terbesar di kurikulum?
-- Harapan   : Menampilkan 3 baris mata kuliah dengan SKS tertinggi yang diurutkan secara menurun (DESC).
SELECT 
    kode_mk, 
    nama_mk, 
    sks, 
    semester
FROM mata_kuliah
ORDER BY sks DESC
LIMIT 3;


-- ---------------------------------------------------------------------
-- KUERI 10: Penggunaan Fungsi Agregat Sederhana pada Satu Tabel
-- ---------------------------------------------------------------------
-- Kode KI   : KI-10
-- Pertanyaan: Berapa total keseluruhan akumulasi SKS dari semua mata kuliah, rata-rata SKS, serta bobot SKS maksimum dan minimum?
-- Harapan   : Menampilkan nilai SUM, AVG, MAX, dan MIN dari kolom SKS mata kuliah.
SELECT 
    SUM(sks) AS total_keseluruhan_sks,
    AVG(sks) AS rata_rata_sks,
    MAX(sks) AS sks_tertinggi,
    MIN(sks) AS sks_terendah
FROM mata_kuliah;

-- =====================================================================
-- AKHIR BERKAS KUERI AKADEMIK MODUL 7
-- =====================================================================