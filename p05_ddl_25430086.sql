-- ============================================================================
-- Berkas     : p05_ddl_25430086.sql
-- Nama       : Adella Putri Yasminne
-- NIM        : 25430086
-- Praktikum  : Modul 5 - Membangun Struktur dengan DDL dan Constraint
-- Tema Proyek: Akademik (akad_086)
-- ============================================================================

-- 1. PEMBUATAN BASIS DATA PROYEK
CREATE DATABASE IF NOT EXISTS akad_086
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE akad_086;

-- 2. HAPUS TABEL JIKA SUDAH ADA (Urutan dari TABEL ANAK ke TABEL INDUK)
--    Menghindari ERROR 1451 saat penghapusan struktur
DROP TABLE IF EXISTS khs_detail;
DROP TABLE IF EXISTS krs_detail;
DROP TABLE IF EXISTS krs;
DROP TABLE IF EXISTS jadwal_kuliah;
DROP TABLE IF EXISTS kelas;
DROP TABLE IF EXISTS mata_kuliah;
DROP TABLE IF EXISTS dosen;
DROP TABLE IF EXISTS mahasiswa;

-- ============================================================================
-- 3. PEMBUATAN TABEL MASTER (INDUK)
-- ============================================================================

-- Tabel 1: mahasiswa
-- Mencatat identitas mahasiswa (PDP: no_hp_mahasiswa bersifat pribadi/NULL)
CREATE TABLE mahasiswa (
  id_mahasiswa      INT NOT NULL AUTO_INCREMENT,
  nim_mahasiswa     CHAR(10) NOT NULL,
  nama_mahasiswa    VARCHAR(100) NOT NULL,
  prodi_mahasiswa   VARCHAR(60) NOT NULL,
  angkatan_mahasiswa SMALLINT NOT NULL,
  no_hp_mahasiswa   VARCHAR(15) NULL,
  status_mahasiswa  ENUM('aktif', 'cuti', 'lulus', 'drop_out') NOT NULL DEFAULT 'aktif',
  PRIMARY KEY (id_mahasiswa),
  CONSTRAINT uq_mahasiswa_nim UNIQUE (nim_mahasiswa),
  CONSTRAINT ck_mahasiswa_angkatan CHECK (angkatan_mahasiswa >= 2000) -- AB-01: Angkatan valid
) ENGINE=InnoDB;

-- Tabel 2: dosen
-- Mencatat identitas dosen pengampu
CREATE TABLE dosen (
  id_dosen          INT NOT NULL AUTO_INCREMENT,
  nip_dosen         VARCHAR(18) NOT NULL,
  nama_dosen        VARCHAR(100) NOT NULL,
  email_dosen       VARCHAR(100) NULL,
  PRIMARY KEY (id_dosen),
  CONSTRAINT uq_dosen_nip UNIQUE (nip_dosen)
) ENGINE=InnoDB;

-- Tabel 3: mata_kuliah
-- Katalog mata kuliah beserta bobot SKS
CREATE TABLE mata_kuliah (
  id_mata_kuliah    INT NOT NULL AUTO_INCREMENT,
  kode_mata_kuliah  VARCHAR(10) NOT NULL,
  nama_mata_kuliah  VARCHAR(100) NOT NULL,
  sks_mata_kuliah   TINYINT NOT NULL DEFAULT 3,
  semester_paket    TINYINT NOT NULL,
  PRIMARY KEY (id_mata_kuliah),
  CONSTRAINT uq_matakuliah_kode UNIQUE (kode_mata_kuliah),
  CONSTRAINT ck_matakuliah_sks CHECK (sks_mata_kuliah BETWEEN 1 AND 6) -- AB-02: SKS 1-6
) ENGINE=InnoDB;

-- Tabel 4: kelas
-- Membuka kelas paralel untuk mata kuliah pada semester/tahun ajaran tertentu
CREATE TABLE kelas (
  id_kelas          INT NOT NULL AUTO_INCREMENT,
  nama_kelas        VARCHAR(10) NOT NULL, -- Contoh: 'IF-3A', 'A'
  tahun_ajaran      VARCHAR(9) NOT NULL,  -- Contoh: '2026/2027'
  semester_ta       ENUM('ganjil', 'genap') NOT NULL,
  id_mata_kuliah    INT NOT NULL,
  id_dosen          INT NOT NULL,
  kuota_kelas       TINYINT NOT NULL DEFAULT 40,
  PRIMARY KEY (id_kelas),
  CONSTRAINT fk_kelas_matakuliah FOREIGN KEY (id_mata_kuliah) 
    REFERENCES mata_kuliah (id_mata_kuliah),
  CONSTRAINT fk_kelas_dosen FOREIGN KEY (id_dosen) 
    REFERENCES dosen (id_dosen),
  CONSTRAINT ck_kelas_kuota CHECK (kuota_kelas > 0) -- AB-03: Kuota minimal 1
) ENGINE=InnoDB;

-- ============================================================================
-- 4. PEMBUATAN TABEL TRANSAKSI (ANAK)
-- ============================================================================

-- Tabel 5: jadwal_kuliah
-- Rincian ruang dan waktu pelaksanaan kelas
CREATE TABLE jadwal_kuliah (
  id_jadwal_kuliah  INT NOT NULL AUTO_INCREMENT,
  id_kelas          INT NOT NULL,
  hari_jadwal       ENUM('Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu') NOT NULL,
  jam_mulai         TIME NOT NULL,
  jam_selesai       TIME NOT NULL,
  ruang_jadwal      VARCHAR(20) NOT NULL,
  PRIMARY KEY (id_jadwal_kuliah),
  CONSTRAINT fk_jadwal_kelas FOREIGN KEY (id_kelas) 
    REFERENCES kelas (id_kelas) ON DELETE CASCADE,
  CONSTRAINT ck_jadwal_jam CHECK (jam_selesai > jam_mulai) -- AB-04: Jam selesai > jam mulai
) ENGINE=InnoDB;

-- Tabel 6: krs (Kepala Kartu Rencana Studi)
-- Menyimpan header pengisian KRS mahasiswa per semester
CREATE TABLE krs (
  id_krs            INT NOT NULL AUTO_INCREMENT,
  no_krs            VARCHAR(20) NOT NULL, -- Contoh: 'KRS-20261-001'
  tgl_krs           DATE NOT NULL,
  id_mahasiswa      INT NOT NULL,
  tahun_ajaran      VARCHAR(9) NOT NULL,
  semester_ta       ENUM('ganjil', 'genap') NOT NULL,
  status_krs        ENUM('draft', 'disetujui', 'ditolak') NOT NULL DEFAULT 'draft',
  PRIMARY KEY (id_krs),
  CONSTRAINT uq_krs_no UNIQUE (no_krs),
  CONSTRAINT fk_krs_mahasiswa FOREIGN KEY (id_mahasiswa) 
    REFERENCES mahasiswa (id_mahasiswa)
) ENGINE=InnoDB;

-- Tabel 7: krs_detail (Rincian Kelas yang Diambil pada KRS)
-- Entitas asosiatif penghubung KRS dengan Kelas
CREATE TABLE krs_detail (
  id_krs            INT NOT NULL,
  id_kelas          INT NOT NULL,
  tgl_ambil         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_krs, id_kelas),
  CONSTRAINT fk_krsdetail_krs FOREIGN KEY (id_krs) 
    REFERENCES krs (id_krs) ON DELETE CASCADE,
  CONSTRAINT fk_krsdetail_kelas FOREIGN KEY (id_kelas) 
    REFERENCES kelas (id_kelas)
) ENGINE=InnoDB;

-- Tabel 8: khs_detail (Detail Kartu Hasil Studi / Nilai Akhir)
-- Menyimpan nilai mahasiswa per kelas yang diambil
CREATE TABLE khs_detail (
  id_krs            INT NOT NULL,
  id_kelas          INT NOT NULL,
  nilai_angka       DECIMAL(5,2) NULL,
  nilai_huruf       CHAR(2) NULL,
  bobot_nilai       DECIMAL(3,2) NULL,
  PRIMARY KEY (id_krs, id_kelas),
  CONSTRAINT fk_khsdetail_krsdetail FOREIGN KEY (id_krs, id_kelas) 
    REFERENCES krs_detail (id_krs, id_kelas) ON DELETE CASCADE,
  CONSTRAINT ck_khs_nilai CHECK (nilai_angka IS NULL OR (nilai_angka BETWEEN 0 AND 100)) -- AB-05: Nilai 0-100
) ENGINE=InnoDB;