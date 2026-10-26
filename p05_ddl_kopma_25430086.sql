-- ============================================================================
-- Berkas     : p05_ddl_kopma_25430086.sql
-- Nama       : Adella Putri Yasminne
-- NIM        : 25430086
-- Praktikum  : Modul 5 - Membangun Struktur dengan DDL dan Constraint
-- Kasus      : Koperasi Mahasiswa Sejahtera (Kopma)
-- Basis Data : kopma_086
-- ============================================================================

-- 1. PEMBUATAN BASIS DATA
CREATE DATABASE IF NOT EXISTS kopma_086
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE kopma_086;

-- 2. HAPUS TABEL JIKA SUDAH ADA (Urutan dari TABEL ANAK ke TABEL INDUK)
--    Menghindari ERROR 1451 saat penghapusan struktur
DROP TABLE IF EXISTS detail_pembelian;
DROP TABLE IF EXISTS pembelian;
DROP TABLE IF EXISTS detail_penjualan;
DROP TABLE IF EXISTS penjualan;
DROP TABLE IF EXISTS pemasok;
DROP TABLE IF EXISTS barang;
DROP TABLE IF EXISTS anggota;
DROP TABLE IF EXISTS petugas;

-- ============================================================================
-- 3. PEMBUATAN TABEL MASTER (INDUK)
-- ============================================================================

-- Tabel 1: petugas
CREATE TABLE petugas (
  id_petugas      SMALLINT NOT NULL AUTO_INCREMENT,
  kode_petugas    CHAR(3) NOT NULL, -- mis. K03[cite: 149]
  nama_petugas    VARCHAR(100) NOT NULL,
  peran_petugas   ENUM('kasir','gudang','ketua') NOT NULL,
  PRIMARY KEY (id_petugas),
  CONSTRAINT uq_petugas_kode UNIQUE (kode_petugas)
) ENGINE=InnoDB;

-- Tabel 2: anggota
CREATE TABLE anggota (
  id_anggota      INT NOT NULL AUTO_INCREMENT,
  no_anggota      CHAR(6) NOT NULL, -- A-0457[cite: 149]
  nim_anggota     CHAR(10) NOT NULL,
  nama_anggota    VARCHAR(100) NOT NULL,
  prodi_anggota   VARCHAR(60) NOT NULL,
  no_hp_anggota   VARCHAR(15) NULL, -- data pribadi (PDP)[cite: 149]
  status_anggota  ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif',
  tgl_daftar_anggota DATE NOT NULL,
  PRIMARY KEY (id_anggota),
  CONSTRAINT uq_anggota_no UNIQUE (no_anggota),
  CONSTRAINT uq_anggota_nim UNIQUE (nim_anggota) -- AB-05[cite: 149]
) ENGINE=InnoDB;

-- Tabel 3: barang
CREATE TABLE barang (
  id_barang       INT NOT NULL AUTO_INCREMENT,
  kode_barang     VARCHAR(10) NOT NULL,
  nama_barang     VARCHAR(100) NOT NULL,
  kategori_barang ENUM('ATK','makanan','minuman') NOT NULL,
  harga_jual_barang DECIMAL(12,2) NOT NULL,
  stok_barang     INT NOT NULL DEFAULT 0,
  stok_min_barang INT NOT NULL DEFAULT 5,
  PRIMARY KEY (id_barang),
  CONSTRAINT uq_barang_kode UNIQUE (kode_barang),
  CONSTRAINT ck_barang_stok CHECK (stok_barang >= 0), -- AB-03[cite: 150]
  CONSTRAINT ck_barang_harga CHECK (harga_jual_barang >= 0)
) ENGINE=InnoDB;

-- Tabel 4: pemasok
CREATE TABLE pemasok (
  id_pemasok      INT NOT NULL AUTO_INCREMENT,
  nama_pemasok    VARCHAR(100) NOT NULL,
  telepon_pemasok VARCHAR(15) NULL,
  alamat_pemasok  VARCHAR(200) NULL,
  PRIMARY KEY (id_pemasok)
) ENGINE=InnoDB;

-- ============================================================================
-- 4. PEMBUATAN TABEL TRANSAKSI (ANAK)
-- ============================================================================

-- Tabel 5: penjualan
CREATE TABLE penjualan (
  id_penjualan    INT NOT NULL AUTO_INCREMENT,
  no_nota_penjualan CHAR(12) NOT NULL, -- PJ-2609-0142, AB-01[cite: 150]
  tgl_penjualan   DATETIME NOT NULL,
  id_petugas      SMALLINT NOT NULL,
  id_anggota      INT NULL, -- NULL = pembeli umum, AB-02[cite: 150]
  bayar_penjualan DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (id_penjualan),
  CONSTRAINT uq_penjualan_nota UNIQUE (no_nota_penjualan),
  CONSTRAINT fk_penjualan_petugas FOREIGN KEY (id_petugas) REFERENCES petugas (id_petugas),
  CONSTRAINT fk_penjualan_anggota FOREIGN KEY (id_anggota) REFERENCES anggota (id_anggota)
) ENGINE=InnoDB;

-- Tabel 6: detail_penjualan (Entitas Asosiatif)
CREATE TABLE detail_penjualan (
  id_penjualan    INT NOT NULL,
  id_barang       INT NOT NULL,
  qty_detail_penjualan SMALLINT NOT NULL,
  harga_satuan_detail_penjualan DECIMAL(12,2) NOT NULL, -- harga saat transaksi, AB-04[cite: 150]
  PRIMARY KEY (id_penjualan, id_barang),
  CONSTRAINT fk_detail_penjualan FOREIGN KEY (id_penjualan) REFERENCES penjualan (id_penjualan) ON DELETE CASCADE,
  CONSTRAINT fk_detail_barang FOREIGN KEY (id_barang) REFERENCES barang (id_barang),
  CONSTRAINT ck_detail_qty CHECK (qty_detail_penjualan > 0)
) ENGINE=InnoDB;

-- Tabel 7: pembelian
CREATE TABLE pembelian (
  id_pembelian    INT NOT NULL AUTO_INCREMENT,
  no_faktur_pembelian VARCHAR(20) NOT NULL,
  tgl_pembelian   DATE NOT NULL,
  id_pemasok      INT NOT NULL,
  status_pembelian ENUM('dipesan','diterima') NOT NULL DEFAULT 'dipesan', -- AB-06[cite: 151]
  PRIMARY KEY (id_pembelian),
  CONSTRAINT fk_pembelian_pemasok FOREIGN KEY (id_pemasok) REFERENCES pemasok (id_pemasok)
) ENGINE=InnoDB;

-- Tabel 8: detail_pembelian (Entitas Asosiatif)
CREATE TABLE detail_pembelian (
  id_pembelian    INT NOT NULL,
  id_barang       INT NOT NULL,
  qty_detail_pembelian INT NOT NULL,
  harga_beli_detail_pembelian DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (id_pembelian, id_barang),
  CONSTRAINT fk_dbeli_pembelian FOREIGN KEY (id_pembelian) REFERENCES pembelian (id_pembelian) ON DELETE CASCADE,
  CONSTRAINT fk_dbeli_barang FOREIGN KEY (id_barang) REFERENCES barang (id_barang),
  CONSTRAINT ck_dbeli_qty CHECK (qty_detail_pembelian > 0)
) ENGINE=InnoDB;