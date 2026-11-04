-- Mata Kuliah : Praktikum Basis Data
-- Tugas       : Modul 6 - Pengisian, Pengubahan, dan Pengujian Data (DML)
-- Tema Proyek : Akademik
-- Nama        : Adella Putri Yasminne
-- NIM         : 25430086

-- 1. Membuat dan Menggunakan Database
CREATE DATABASE IF NOT EXISTS akademik_della;
USE akademik_della;

-- 2. Menghapus Tabel Jika Sudah Ada (Untuk Mencegah Konflik)
DROP TABLE IF EXISTS jadwal_kuliah;
DROP TABLE IF EXISTS krs_detail;
DROP TABLE IF EXISTS krs;
DROP TABLE IF EXISTS kelas;
DROP TABLE IF EXISTS mata_kuliah;
DROP TABLE IF EXISTS dosen;
DROP TABLE IF EXISTS mahasiswa;

-- 3. Membuat Struktur Tabel (DDL)
CREATE TABLE mahasiswa (
    nim VARCHAR(10) PRIMARY KEY,
    nama VARCHAR(50) NOT NULL,
    kelas VARCHAR(10) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE dosen (
    kode_dosen VARCHAR(10) PRIMARY KEY,
    nama_dosen VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE mata_kuliah (
    kode_mk VARCHAR(10) PRIMARY KEY,
    nama_mk VARCHAR(50) NOT NULL,
    sks INT NOT NULL
) ENGINE=InnoDB;

CREATE TABLE kelas (
    id_kelas VARCHAR(10) PRIMARY KEY,
    nama_kelas VARCHAR(20) NOT NULL,
    kode_dosen VARCHAR(10),
    FOREIGN KEY (kode_dosen) REFERENCES dosen(kode_dosen)
) ENGINE=InnoDB;

CREATE TABLE krs (
    id_krs VARCHAR(10) PRIMARY KEY,
    nim VARCHAR(10),
    semester VARCHAR(10),
    FOREIGN KEY (nim) REFERENCES mahasiswa(nim)
) ENGINE=InnoDB;

CREATE TABLE krs_detail (
    id_detail INT AUTO_INCREMENT PRIMARY KEY,
    id_krs VARCHAR(10),
    kode_mk VARCHAR(10),
    FOREIGN KEY (id_krs) REFERENCES krs(id_krs),
    FOREIGN KEY (kode_mk) REFERENCES mata_kuliah(kode_mk)
) ENGINE=InnoDB;

CREATE TABLE jadwal_kuliah (
    id_jadwal VARCHAR(10) PRIMARY KEY,
    kode_mk VARCHAR(10),
    id_kelas VARCHAR(10),
    hari VARCHAR(10),
    jam VARCHAR(20),
    FOREIGN KEY (kode_mk) REFERENCES mata_kuliah(kode_mk),
    FOREIGN KEY (id_kelas) REFERENCES kelas(id_kelas)
) ENGINE=InnoDB;

-- 4. Memasukkan Data Awal (DML - INSERT)
INSERT INTO mahasiswa (nim, nama, kelas) VALUES 
('25430086', 'Adella Putri Yasminne', '3A'),
('25430001', 'Putri', '3A'),
('25430002', 'Budi Santoso', '3B');

INSERT INTO dosen (kode_dosen, nama_dosen) VALUES 
('DSN01', 'Dr. Ir. Aris Rahman, M.Kom.'),
('DSN02', 'Siti Aminah, S.T., M.Cs.');

INSERT INTO mata_kuliah (kode_mk, nama_mk, sks) VALUES 
('IF101', 'Basis Data', 4),
('IF102', 'Struktur Data dan Algoritma', 4),
('IF103', 'Grafika Komputer', 3);

INSERT INTO kelas (id_kelas, nama_kelas, kode_dosen) VALUES 
('KLS01', 'Kelas 3A', 'DSN01'),
('KLS02', 'Kelas 3B', 'DSN02');

INSERT INTO krs (id_krs, nim, semester) VALUES 
('KRS001', '25430086', 'Ganjil'),
('KRS002', '25430001', 'Ganjil');

INSERT INTO krs_detail (id_krs, kode_mk) VALUES 
('KRS001', 'IF101'),
('KRS001', 'IF102'),
('KRS002', 'IF103');

INSERT INTO jadwal_kuliah (id_jadwal, kode_mk, id_kelas, hari, jam) VALUES 
('JDW01', 'IF101', 'KLS01', 'Senin', '08:00 - 10:30'),
('JDW02', 'IF102', 'KLS01', 'Rabu', '10:00 - 12:30');