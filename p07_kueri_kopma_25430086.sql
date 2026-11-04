-- =====================================================================
-- Mata Kuliah : Praktikum Basis Data
-- Tugas       : Modul 7 - Menjawab Pertanyaan dengan SELECT dan Fungsi Skalar
-- Tema Proyek : Sistem Informasi Koperasi Mahasiswa (Kopma)
-- Nama        : Adella Putri Yasminne
-- NIM         : 25430086
-- Kelas       : C
-- Berkas      : p07_kueri_kopma_25430086.sql
-- =====================================================================

-- Memilih basis data kerja koperasi mahasiswa
USE kopma_086;

-- ---------------------------------------------------------------------
-- KUERI 1: Penggunaan Operator LIKE (Pencarian Pola Teks)
-- ---------------------------------------------------------------------
-- Kode KI   : KI-01
-- Pertanyaan: Produk apa saja yang memiliki nama mengandung kata 'Buku'?
-- Harapan   : Menampilkan daftar produk yang nama barangnya mengandung kata 'Buku'.
SELECT 
    id_produk, 
    kode_produk, 
    nama_produk, 
    harga_satuan, 
    stok_produk
FROM produk
WHERE nama_produk LIKE '%Buku%';


-- ---------------------------------------------------------------------
-- KUERI 2: Penggunaan Operator BETWEEN (Rentang Nilai)
-- ---------------------------------------------------------------------
-- Kode KI   : KI-02
-- Pertanyaan: Produk apa saja yang memiliki harga satuan di antara Rp5.000 hingga Rp50.000?
-- Harapan   : Menampilkan daftar produk dengan kisaran harga di dalam rentang tersebut.
SELECT 
    id_produk, 
    kode_produk, 
    nama_produk, 
    harga_satuan
FROM produk
WHERE harga_satuan BETWEEN 5000.00 AND 50000.00;


-- ---------------------------------------------------------------------
-- KUERI 3: Penggunaan Operator IN (Pencocokan Nilai Majemuk)
-- ---------------------------------------------------------------------
-- Kode KI   : KI-03
-- Pertanyaan: Kasir mana saja yang bertugas pada shift 'Pagi' atau 'Malam'?
-- Harapan   : Menampilkan data kasir yang jadwal shift-nya sesuai dengan klausul IN.
SELECT 
    id_kasir, 
    nama_kasir, 
    telepon_kasir, 
    shift_kasir
FROM kasir
WHERE shift_kasir IN ('Pagi', 'Malam');


-- ---------------------------------------------------------------------
-- KUERI 4: Penggunaan Operator IS NULL / IS NOT NULL (Pemeriksaan Nilai Kosong)
-- ---------------------------------------------------------------------
-- Kode KI   : KI-04
-- Pertanyaan: Apakah ada transaksi penjualan yang status bayarnya kosong atau belum terdata?
-- Harapan   : Menampilkan data transaksi yang kolom status bayarnya bernilai NULL.
SELECT 
    id_penjualan, 
    no_transaksi, 
    tgl_penjualan, 
    total_belanja
FROM penjualan
WHERE status_bayar IS NULL;


-- ---------------------------------------------------------------------
-- KUERI 5: Penggunaan Fungsi String (UPPER / CONCAT)
-- ---------------------------------------------------------------------
-- Kode KI   : KI-05
-- Pertanyaan: Bagaimana tampilan informasi nama kasir digabungkan dengan shift kerjanya dalam huruf kapital penuh?
-- Harapan   : Menampilkan gabungan nama dan shift kasir dengan format string khusus.
SELECT 
    CONCAT(UPPER(nama_kasir), ' (SHIFT: ', UPPER(shift_kasir), ')') AS informasi_kasir,
    telepon_kasir
FROM kasir;


-- ---------------------------------------------------------------------
-- KUERI 6: Penggunaan Fungsi Tanggal atau Format Waktu
-- ---------------------------------------------------------------------
-- Kode KI   : KI-06
-- Pertanyaan: Kapan waktu saat ini sistem diakses saat laporan kueri penjualan dicetak?
-- Harapan   : Menampilkan informasi waktu saat ini menggunakan fungsi tanggal/waktu SQL.
SELECT 
    id_penjualan,
    no_transaksi,
    NOW() AS waktu_cetak_laporan
FROM penjualan;


-- ---------------------------------------------------------------------
-- KUERI 7: Penggunaan Kondisional CASE-WHEN
-- ---------------------------------------------------------------------
-- Kode KI   : KI-07
-- Pertanyaan: Bagaimana klasifikasi status stok produk (apakah 'Stok Menipis' atau 'Stok Aman') berdasarkan stok minimum?
-- Harapan   : Menampilkan label status stok secara kondisional.
SELECT 
    nama_produk,
    stok_produk,
    stok_minimum,
    CASE 
        WHEN stok_produk <= stok_minimum THEN 'Stok Menipis (Perlu Restock)'
        ELSE 'Stok Aman'
    END AS status_stok_barang
FROM produk;


-- ---------------------------------------------------------------------
-- KUERI 8: Penggunaan Fungsi Matematika (ROUND / Perkalian)
-- ---------------------------------------------------------------------
-- Kode KI   : KI-08
-- Pertanyaan: Berapa estimasi harga jual produk jika dinaikkan sebesar 10% dan dibulatkan?
-- Harapan   : Menampilkan perhitungan matematis kenaikan harga satuan produk.
SELECT 
    nama_produk,
    harga_satuan AS harga_asli,
    ROUND(harga_satuan * 1.10, 2) AS harga_setelah_kenaikan
FROM produk;


-- ---------------------------------------------------------------------
-- KUERI 9: Penggunaan Klausul ORDER BY dan LIMIT
-- ---------------------------------------------------------------------
-- Kode KI   : KI-09
-- Pertanyaan: Apa 3 produk yang memiliki harga satuan tertinggi di koperasi mahasiswa?
-- Harapan   : Menampilkan 3 baris produk dengan harga termahal yang diurutkan secara menurun (DESC).
SELECT 
    kode_produk, 
    nama_produk, 
    harga_satuan, 
    stok_produk
FROM produk
ORDER BY harga_satuan DESC
LIMIT 3;


-- ---------------------------------------------------------------------
-- KUERI 10: Penggunaan Fungsi Agregat Sederhana pada Satu Tabel
-- ---------------------------------------------------------------------
-- Kode KI   : KI-10
-- Pertanyaan: Berapa total keseluruhan nilai transaksi belanja, rata-rata belanja, serta nilai transaksi maksimum dan minimum?
-- Harapan   : Menampilkan nilai SUM, AVG, MAX, dan MIN dari kolom total belanja penjualan.
SELECT 
    SUM(total_belanja) AS total_pendapatan_penjualan,
    AVG(total_belanja) AS rata_rata_belanja,
    MAX(total_belanja) AS transaksi_tertinggi,
    MIN(total_belanja) AS transaksi_terendah
FROM penjualan;

-- =====================================================================
-- AKHIR BERKAS KUERI KOPMA MODUL 7
-- =====================================================================