-- =====================================================================
-- Mata Kuliah : Praktikum Basis Data
-- Tugas       : Modul 6 - Pengisian, Pengubahan, dan Pengujian Data (DML)
-- Tema Proyek : Sistem Informasi Koperasi Mahasiswa (Kopma)
-- Nama        : Adella Putri Yasminne
-- NIM         : 25430086
-- Kelas       : C
-- Parameter P : 6 ((86 mod 9) + 1 = 6)
-- Berkas      : p06_data_kopma_25430086.sql
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. INISIALISASI DAN PENGATURAN LINGKUNGAN BASIS DATA
-- ---------------------------------------------------------------------
USE kopma_086;

-- Menonaktifkan sementara pemeriksaan foreign key untuk proses reset data
SET FOREIGN_KEY_CHECKS = 0;

-- Melakukan pembersihan tabel secara sekuensial dari tabel anak ke induk
TRUNCATE TABLE detail_penjualan;
TRUNCATE TABLE penjualan;
TRUNCATE TABLE produk;
TRUNCATE TABLE kategori_produk;
TRUNCATE TABLE anggota;
TRUNCATE TABLE kasir;

-- Mengaktifkan kembali pemeriksaan foreign key
SET FOREIGN_KEY_CHECKS = 1;


-- ---------------------------------------------------------------------
-- 2. PENGISIAN ENTITAS MASTER: KASIR
-- ---------------------------------------------------------------------
INSERT INTO kasir (id_kasir, nama_kasir, telepon_kasir, shift_kasir) VALUES
('KSR01', 'Rian Utama', '081234567890', 'Pagi'),
('KSR02', 'Dewi Lestari', '081345678901', 'Siang'),
('KSR03', 'Bayu Pratama', '081456789023', 'Pagi'),
('KSR04', 'Siska Amelia', '081567890124', 'Siang'),
('KSR05', 'Fajar Sidik', '081678901235', 'Malam');


-- ---------------------------------------------------------------------
-- 3. PENGISIAN ENTITAS MASTER: ANGGOTA
-- ---------------------------------------------------------------------
INSERT INTO anggota (id_anggota, no_anggota, nama_anggota, prodi_anggota, telepon_anggota) VALUES
(1, 'AGT-2026-001', 'Ahmad Fauzi', 'S1 Teknik Informatika', '082111222333'),
(2, 'AGT-2026-002', 'Siti Rahma', 'S1 Akuntansi', '082222333444'),
(3, 'AGT-2026-003', 'Budi Santoso', 'S1 Manajemen', '082333444555'),
(4, 'AGT-2026-004', 'Rina Melati', 'S1 Ilmu Hukum', '082444555666'),
(5, 'AGT-2026-005', 'Eko Prasetyo', 'S1 Teknik Elektro', '082555666777');


-- ---------------------------------------------------------------------
-- 4. PENGISIAN ENTITAS MASTER: KATEGORI PRODUK
-- ---------------------------------------------------------------------
INSERT INTO kategori_produk (id_kategori, nama_kategori) VALUES
(1, 'Alat Tulis Kantor (ATK)'),
(2, 'Makanan & Minuman Ringan'),
(3, 'Atribut & Perlengkapan Kuliah'),
(4, 'Buku & Modul Praktikum'),
(5, 'Elektronik & Aksesoris');


-- ---------------------------------------------------------------------
-- 5. PENGISIAN ENTITAS MASTER: PRODUK
-- ---------------------------------------------------------------------
INSERT INTO produk (id_produk, kode_produk, id_kategori, nama_produk, harga_satuan, stok_produk, stok_minimum) VALUES
(1, 'PRD-01', 1, 'Buku Tulis Sidu 38 Lembar', 5000.00, 150, 20),
(2, 'PRD-02', 1, 'Pulpen Standard AE7', 3000.00, 200, 25),
(3, 'PRD-03', 2, 'Air Mineral 600ml', 4000.00, 120, 30),
(4, 'PRD-04', 2, 'Roti Abon Cokelat', 7000.00, 80, 15),
(5, 'PRD-05', 3, 'Jas Almamater Universitas', 150000.00, 45, 10),
(6, 'PRD-06', 4, 'Modul Praktikum Basis Data', 35000.00, 60, 10),
(7, 'PRD-07', 5, 'Flashdisk 32GB SanDisk', 75000.00, 30, 5),
(8, 'PRD-08', 3, 'Topi Resmi Kopma', 25000.00, 50, 10);


-- ---------------------------------------------------------------------
-- 6. PENGISIAN ENTITAS TRANSAKSI UTAMA: PENJUALAN
-- ---------------------------------------------------------------------
-- Data transaksi penjualan utama (minimal memenuhi parameter P = 6 baris)
INSERT INTO penjualan (id_penjualan, no_transaksi, tgl_penjualan, id_anggota, id_kasir, total_belanja, status_bayar) VALUES
(1, 'TRX-2609-001', '2026-09-02 08:30:00', 1, 1, 44000.00, 'Lunas'),
(2, 'TRX-2609-002', '2026-09-03 09:15:00', 2, 2, 150000.00, 'Lunas'),
(3, 'TRX-2609-003', '2026-09-04 10:00:00', 3, 1, 39000.00, 'Lunas'),
(4, 'TRX-2609-004', '2026-09-05 11:20:00', 4, 3, 75000.00, 'Lunas'),
(5, 'TRX-2609-005', '2026-09-06 13:00:00', 5, 4, 35000.00, 'Lunas'),
(6, 'TRX-2609-006', '2026-09-07 14:10:00', 1, 2, 28000.00, 'Lunas'),
(7, 'TRX-2609-007', '2026-09-08 09:45:00', 2, 5, 11000.00, 'Lunas'),
(8, 'TRX-2609-008', '2026-09-09 10:30:00', 3, 1, 150000.00, 'Lunas'),
(9, 'TRX-2609-009', '2026-09-10 15:00:00', 4, 2, 43000.00, 'Lunas'),
(10, 'TRX-2609-010', '2026-09-11 16:15:00', 5, 3, 35000.00, 'Lunas');


-- ---------------------------------------------------------------------
-- 7. PENGISIAN ENTITAS TRANSAKSI RELASIONAL: DETAIL PENJUALAN
-- ---------------------------------------------------------------------
-- Rincian barang yang dibeli pada setiap nomor transaksi penjualan
INSERT INTO detail_penjualan (id_detail, id_penjualan, id_produk, jumlah_beli, harga_satuan_saat_ini, subtotal) VALUES
(1, 1, 1, 4, 5000.00, 20000.00),
(2, 1, 3, 6, 4000.00, 24000.00),
(3, 2, 5, 1, 150000.00, 150000.00),
(4, 3, 2, 3, 3000.00, 9000.00),
(5, 3, 6, 1, 35000.00, 35000.00),
(6, 4, 7, 1, 75000.00, 75000.00),
(7, 5, 6, 1, 35000.00, 35000.00),
(8, 6, 1, 2, 5000.00, 10000.00),
(9, 6, 4, 2, 7000.00, 14000.00),
(10, 7, 2, 1, 3000.00, 3000.00),
(11, 7, 3, 2, 4000.00, 8000.00),
(12, 8, 5, 1, 150000.00, 150000.00),
(13, 9, 1, 3, 5000.00, 15000.00),
(14, 9, 4, 4, 7000.00, 28000.00),
(15, 10, 6, 1, 35000.00, 35000.00);


-- ---------------------------------------------------------------------
-- 8. MODIFIKASI DATA (DML UPDATE): PENYESUAIAN STOK PRODUK
-- ---------------------------------------------------------------------
-- Mengurangi stok fisik produk berdasarkan akumulasi kuantitas penjualan di atas
UPDATE produk SET stok_produk = stok_produk - 9 WHERE id_produk = 1;
UPDATE produk SET stok_produk = stok_produk - 4 WHERE id_produk = 2;
UPDATE produk SET stok_produk = stok_produk - 8 WHERE id_produk = 3;
UPDATE produk SET stok_produk = stok_produk - 6 WHERE id_produk = 4;
UPDATE produk SET stok_produk = stok_produk - 2 WHERE id_produk = 5;
UPDATE produk SET stok_produk = stok_produk - 3 WHERE id_produk = 6;
UPDATE produk SET stok_produk = stok_produk - 1 WHERE id_produk = 7;

-- =====================================================================
-- AKHIR BERKAS SKRIP DML KOPMA MODUL 6
-- =====================================================================