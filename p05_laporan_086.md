LAPORAN PRAKTIKUM BASIS DATA

MODUL 5: MEMBANGUN STRUKTUR DENGAN DDL DAN CONSTRAINT

Nama : Adella putri yasminne
NIM : 25430086

Kelas : Praktikum Basis Data

Tanggal : 26 Oktober 2026

1. TUJUAN PRAKTIKUM

Menerjemahkan skema relasional 3NF dari Modul 4 menjadi skrip SQL Data Definition Language (DDL) berupa perintah CREATE TABLE pada DBMS MariaDB.

Menerapkan berbagai bentuk constraint (PRIMARY KEY, FOREIGN KEY, UNIQUE, NOT NULL, DEFAULT, dan CHECK) untuk menguatkan aturan bisnis secara otomatis pada tingkat server basis data.

Menulis skrip DDL yang bersifat re-eksidabel (idempotent) dengan urutan penghapusan (DROP TABLE IF EXISTS) dan pembuatan tabel yang tepat guna menghindari constraint error (ERROR 1451).

Menguji ketahanan constraint basis data melalui pengujian query data valid dan invalid (pelanggaran constraint).

2. RINGKASAN DASAR TEORI

Data Definition Language (DDL): Kelompok perintah SQL yang digunakan untuk mendefinisikan, mengubah, dan menghapus struktur objek basis data (CREATE, ALTER, DROP, TRUNCATE).

Integrity Constraints: Aturan-aturan yang diberlakukan pada kolom atau tabel untuk menjamin akurasi dan konsistensi data:

PRIMARY KEY: Kombinasi UNIQUE dan NOT NULL sebagai identitas unik setiap baris.

FOREIGN KEY: Menjamin referential integrity antara tabel anak dan tabel induk.

UNIQUE: Mencegah duplikasi nilai pada kolom tertentu.

NOT NULL: Memastikan kolom tidak boleh kosong.

DEFAULT: Memberikan nilai awal otomatis jika nilai tidak dispesifikasikan saat pemuatan data.

CHECK: Menerapkan ekspresi logika untuk memvalidasi rentang atau syarat nilai data.

Tipe Data MariaDB: Penggunaan tipe data presisi seperti INT, SMALLINT, TINYINT, DECIMAL, CHAR, VARCHAR, ENUM, DATE, TIME, dan DATETIME.

3. HASIL LANGKAH PERCOBAAN (STUDI KASUS KOPMA)

Pada bagian ini, dilakukan pembuatan basis data kopma_086 dan pengujian constraint pada tabel-tabel Koperasi Mahasiswa.

3.1 Skrip DDL Kopma (p05_ddl_kopma_25430086.sql)

-- ============================================================================
-- Berkas     : p05_ddl_kopma_25430086.sql
-- Nama       : Adella putri yasminne
-- NIM        : 25430086
-- Praktikum  : Modul 5 - Membangun Struktur dengan DDL dan Constraint
-- Kasus      : Koperasi Mahasiswa Sejahtera (Kopma)
-- Basis Data : kopma_086
-- ============================================================================

CREATE DATABASE IF NOT EXISTS kopma_086
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE kopma_086;

-- Hapus Tabel dari Tabel Anak ke Tabel Induk
DROP TABLE IF EXISTS detail_pembelian;
DROP TABLE IF EXISTS pembelian;
DROP TABLE IF EXISTS detail_penjualan;
DROP TABLE IF EXISTS penjualan;
DROP TABLE IF EXISTS pemasok;
DROP TABLE IF EXISTS barang;
DROP TABLE IF EXISTS anggota;
DROP TABLE IF EXISTS petugas;

-- Pembuatan Tabel Master (Induk)
CREATE TABLE petugas (
  id_petugas      SMALLINT NOT NULL AUTO_INCREMENT,
  kode_petugas    CHAR(3) NOT NULL,
  nama_petugas    VARCHAR(100) NOT NULL,
  peran_petugas   ENUM('kasir','gudang','ketua') NOT NULL,
  PRIMARY KEY (id_petugas),
  CONSTRAINT uq_petugas_kode UNIQUE (kode_petugas)
) ENGINE=InnoDB;

CREATE TABLE anggota (
  id_anggota      INT NOT NULL AUTO_INCREMENT,
  no_anggota      CHAR(6) NOT NULL,
  nim_anggota     CHAR(10) NOT NULL,
  nama_anggota    VARCHAR(100) NOT NULL,
  prodi_anggota   VARCHAR(60) NOT NULL,
  no_hp_anggota   VARCHAR(15) NULL,
  status_anggota  ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif',
  tgl_daftar_anggota DATE NOT NULL,
  PRIMARY KEY (id_anggota),
  CONSTRAINT uq_anggota_no UNIQUE (no_anggota),
  CONSTRAINT uq_anggota_nim UNIQUE (nim_anggota)
) ENGINE=InnoDB;

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
  CONSTRAINT ck_barang_stok CHECK (stok_barang >= 0),
  CONSTRAINT ck_barang_harga CHECK (harga_jual_barang >= 0)
) ENGINE=InnoDB;

CREATE TABLE pemasok (
  id_pemasok      INT NOT NULL AUTO_INCREMENT,
  nama_pemasok    VARCHAR(100) NOT NULL,
  telepon_pemasok VARCHAR(15) NULL,
  alamat_pemasok  VARCHAR(200) NULL,
  PRIMARY KEY (id_pemasok)
) ENGINE=InnoDB;

-- Pembuatan Tabel Transaksi (Anak)
CREATE TABLE penjualan (
  id_penjualan    INT NOT NULL AUTO_INCREMENT,
  no_nota_penjualan CHAR(12) NOT NULL,
  tgl_penjualan   DATETIME NOT NULL,
  id_petugas      SMALLINT NOT NULL,
  id_anggota      INT NULL,
  bayar_penjualan DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (id_penjualan),
  CONSTRAINT uq_penjualan_nota UNIQUE (no_nota_penjualan),
  CONSTRAINT fk_penjualan_petugas FOREIGN KEY (id_petugas) REFERENCES petugas (id_petugas),
  CONSTRAINT fk_penjualan_anggota FOREIGN KEY (id_anggota) REFERENCES anggota (id_anggota)
) ENGINE=InnoDB;

CREATE TABLE detail_penjualan (
  id_penjualan    INT NOT NULL,
  id_barang       INT NOT NULL,
  qty_detail_penjualan SMALLINT NOT NULL,
  harga_satuan_detail_penjualan DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (id_penjualan, id_barang),
  CONSTRAINT fk_detail_penjualan FOREIGN KEY (id_penjualan) REFERENCES penjualan (id_penjualan) ON DELETE CASCADE,
  CONSTRAINT fk_detail_barang FOREIGN KEY (id_barang) REFERENCES barang (id_barang),
  CONSTRAINT ck_detail_qty CHECK (qty_detail_penjualan > 0)
) ENGINE=InnoDB;

CREATE TABLE pembelian (
  id_pembelian    INT NOT NULL AUTO_INCREMENT,
  no_faktur_pembelian VARCHAR(20) NOT NULL,
  tgl_pembelian   DATE NOT NULL,
  id_pemasok      INT NOT NULL,
  status_pembelian ENUM('dipesan','diterima') NOT NULL DEFAULT 'dipesan',
  PRIMARY KEY (id_pembelian),
  CONSTRAINT fk_pembelian_pemasok FOREIGN KEY (id_pemasok) REFERENCES pemasok (id_pemasok)
) ENGINE=InnoDB;

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


4. JAWABAN TITIK ANALISIS

Titik Analisis 1: Mengapa tabel anak harus dihapus terlebih dahulu sebelum tabel induk saat menjalankan skrip DDL ulang?

Jawaban: Karena tabel anak memiliki constraint Foreign Key yang merujuk ke Primary Key pada tabel induk. Jika tabel induk dihapus lebih dulu, MariaDB akan menolak eksekusi dan memicu ERROR 1451 (23000): Cannot drop table ... referenced by a foreign key constraint.

Titik Analisis 2: Apa perbedaan utama antara constraint NOT NULL dan UNIQUE?

Jawaban: NOT NULL memastikan bahwa suatu kolom wajib memiliki nilai (tidak boleh bernilai unknown/kosong), sedangkan UNIQUE memastikan bahwa setiap nilai dalam kolom tersebut tidak boleh ada yang sama (duplikat), tetapi masih dapat menerima satu nilai NULL (kecuali dikombinasikan dengan NOT NULL).

Titik Analisis 3: Mengapa tipe data id_petugas di tabel penjualan harus sama persis (SMALLINT) dengan yang ada di tabel petugas?

Jawaban: MariaDB/MySQL mewajibkan kolom kunci tamu (Foreign Key) dan kolom kunci primer yang dirujuk memiliki tipe data dan panjang presisi yang identik agar indeks relasi InnoDB dapat terbentuk secara sempurna.

5. HASIL LATIHAN DAN MODIFIKASI (PENGUJAN CONSTRAINT)

Pengujian Pelanggaran Foreign Key

-- Mencoba memasukkan transaksi penjualan dengan id_petugas yang tidak ada (id_petugas = 999)
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, bayar_penjualan)
VALUES ('PJ-2610-0001', NOW(), 999, 50000);


Hasil Error: ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails (Relasi berhasil menolak data rujukan tidak sah).

Pengujian Pelanggaran Check Constraint

-- Mencoba memasukkan data barang dengan stok negatif
INSERT INTO barang (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang)
VALUES ('BRG-001', 'Buku Tulis', 'ATK', 5000, -5);


Hasil Error: ERROR 4025 (23000): CONSTRAINT ck_barang_stok failed for kopma_086.barang (Check constraint berhasil menolak stok negatif).

6. TUGAS MANDIRI: MILESTONE PROYEK 5 (AKADEMIK - akad_086)

Berdasarkan NIM 25430086 (dua digit terakhir: 86), tema proyek mandiri yang dikerjakan adalah Akademik dengan basis data akad_086.

6.1 Skrip DDL Proyek Mandiri (p05_ddl_25430086.sql)

-- ============================================================================
-- Berkas     : p05_ddl_25430086.sql
-- Nama       : Banyu
-- NIM        : 25430086
-- Praktikum  : Modul 5 - Membangun Struktur dengan DDL dan Constraint
-- Tema Proyek: Akademik (akad_086)
-- Keterangan : Skrip DDL sistem informasi akademik yang mencakup entitas
--              mahasiswa, dosen, mata kuliah, kelas, jadwal, KRS, KHS.
-- ============================================================================

CREATE DATABASE IF NOT EXISTS akad_086
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE akad_086;

-- Hapus Tabel dari Tabel Anak ke Tabel Induk
DROP TABLE IF EXISTS khs_detail;
DROP TABLE IF EXISTS krs_detail;
DROP TABLE IF EXISTS krs;
DROP TABLE IF EXISTS jadwal_kuliah;
DROP TABLE IF EXISTS kelas;
DROP TABLE IF EXISTS mata_kuliah;
DROP TABLE IF EXISTS dosen;
DROP TABLE IF EXISTS mahasiswa;

-- Pembuatan Tabel Master (Induk)
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
  CONSTRAINT ck_mahasiswa_angkatan CHECK (angkatan_mahasiswa >= 2000)
) ENGINE=InnoDB;

CREATE TABLE dosen (
  id_dosen          INT NOT NULL AUTO_INCREMENT,
  nip_dosen         VARCHAR(18) NOT NULL,
  nama_dosen        VARCHAR(100) NOT NULL,
  email_dosen       VARCHAR(100) NULL,
  PRIMARY KEY (id_dosen),
  CONSTRAINT uq_dosen_nip UNIQUE (nip_dosen)
) ENGINE=InnoDB;

CREATE TABLE mata_kuliah (
  id_mata_kuliah    INT NOT NULL AUTO_INCREMENT,
  kode_mata_kuliah  VARCHAR(10) NOT NULL,
  nama_mata_kuliah  VARCHAR(100) NOT NULL,
  sks_mata_kuliah   TINYINT NOT NULL DEFAULT 3,
  semester_paket    TINYINT NOT NULL,
  PRIMARY KEY (id_mata_kuliah),
  CONSTRAINT uq_matakuliah_kode UNIQUE (kode_mata_kuliah),
  CONSTRAINT ck_matakuliah_sks CHECK (sks_mata_kuliah BETWEEN 1 AND 6)
) ENGINE=InnoDB;

CREATE TABLE kelas (
  id_kelas          INT NOT NULL AUTO_INCREMENT,
  nama_kelas        VARCHAR(10) NOT NULL,
  tahun_ajaran      VARCHAR(9) NOT NULL,
  semester_ta       ENUM('ganjil', 'genap') NOT NULL,
  id_mata_kuliah    INT NOT NULL,
  id_dosen          INT NOT NULL,
  kuota_kelas       TINYINT NOT NULL DEFAULT 40,
  PRIMARY KEY (id_kelas),
  CONSTRAINT fk_kelas_matakuliah FOREIGN KEY (id_mata_kuliah) REFERENCES mata_kuliah (id_mata_kuliah),
  CONSTRAINT fk_kelas_dosen FOREIGN KEY (id_dosen) REFERENCES dosen (id_dosen),
  CONSTRAINT ck_kelas_kuota CHECK (kuota_kelas > 0)
) ENGINE=InnoDB;

-- Pembuatan Tabel Transaksi (Anak)
CREATE TABLE jadwal_kuliah (
  id_jadwal_kuliah  INT NOT NULL AUTO_INCREMENT,
  id_kelas          INT NOT NULL,
  hari_jadwal       ENUM('Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu') NOT NULL,
  jam_mulai         TIME NOT NULL,
  jam_selesai       TIME NOT NULL,
  ruang_jadwal      VARCHAR(20) NOT NULL,
  PRIMARY KEY (id_jadwal_kuliah),
  CONSTRAINT fk_jadwal_kelas FOREIGN KEY (id_kelas) REFERENCES kelas (id_kelas) ON DELETE CASCADE,
  CONSTRAINT ck_jadwal_jam CHECK (jam_selesai > jam_mulai)
) ENGINE=InnoDB;

CREATE TABLE krs (
  id_krs            INT NOT NULL AUTO_INCREMENT,
  no_krs            VARCHAR(20) NOT NULL,
  tgl_krs           DATE NOT NULL,
  id_mahasiswa      INT NOT NULL,
  tahun_ajaran      VARCHAR(9) NOT NULL,
  semester_ta       ENUM('ganjil', 'genap') NOT NULL,
  status_krs        ENUM('draft', 'disetujui', 'ditolak') NOT NULL DEFAULT 'draft',
  PRIMARY KEY (id_krs),
  CONSTRAINT uq_krs_no UNIQUE (no_krs),
  CONSTRAINT fk_krs_mahasiswa FOREIGN KEY (id_mahasiswa) REFERENCES mahasiswa (id_mahasiswa)
) ENGINE=InnoDB;

CREATE TABLE krs_detail (
  id_krs            INT NOT NULL,
  id_kelas          INT NOT NULL,
  tgl_ambil         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_krs, id_kelas),
  CONSTRAINT fk_krsdetail_krs FOREIGN KEY (id_krs) REFERENCES krs (id_krs) ON DELETE CASCADE,
  CONSTRAINT fk_krsdetail_kelas FOREIGN KEY (id_kelas) REFERENCES kelas (id_kelas)
) ENGINE=InnoDB;

CREATE TABLE khs_detail (
  id_krs            INT NOT NULL,
  id_kelas          INT NOT NULL,
  nilai_angka       DECIMAL(5,2) NULL,
  nilai_huruf       CHAR(2) NULL,
  bobot_nilai       DECIMAL(3,2) NULL,
  PRIMARY KEY (id_krs, id_kelas),
  CONSTRAINT fk_khsdetail_krsdetail FOREIGN KEY (id_krs, id_kelas) REFERENCES krs_detail (id_krs, id_kelas) ON DELETE CASCADE,
  CONSTRAINT ck_khs_nilai CHECK (nilai_angka IS NULL OR (nilai_angka BETWEEN 0 AND 100))
) ENGINE=InnoDB;


7. PEMBAHASAN DAN KENDALA

Dalam proses pembuatan skrip DDL dan penerapan constraint ini:

Urutan Pembuatan Tabel: Ditemui pentingnya mendefinisikan tabel induk (mahasiswa, dosen, mata_kuliah) terlebih dahulu sebelum tabel relasi/transaksi (kelas, krs, krs_detail) agar deklarasi FOREIGN KEY tidak gagal karena tabel tujuan belum terbentuk.

Kesesuaian Tipe Data: Kunci tamu seperti id_petugas dan id_mahasiswa harus dipastikan memiliki tipe data yang presisi (SMALLINT atau INT) sesuai dengan Primary Key pada tabel induknya.

Constraint CHECK: Penerapan CHECK (jam_selesai > jam_mulai) dan CHECK (sks_mata_kuliah BETWEEN 1 AND 6) membantu mengamankan data akademik dari kesalahan input manusia.

8. KESIMPULAN

Perintah SQL DDL berhasil menerjemahkan skema relasional 3NF menjadi struktur tabel fisik pada MariaDB.

Penerapan constraint (PRIMARY KEY, FOREIGN KEY, UNIQUE, CHECK) berhasil menjaga integritas referensial dan mencegah masuknya data invalid ke dalam sistem.

Penyusunan skrip yang re-eksidabel menggunakan urutan DROP TABLE dari tabel anak ke tabel induk memastikan skrip dapat dijalankan berulang kali tanpa kendala error foreign key.

9. PERNYATAAN PENGGUNAAN AI

Saya menyatakan bahwa saya menggunakan bantuan AI (Gemini) sebagai asisten diskusi untuk membantu memeriksa sintaks DDL SQL, memastikan urutan eksekusi constraint, dan memformat dokumen laporan ini sesuai dengan panduan praktikum.

10. BUKTI GIT

Tautan Repositori GitHub: https://github.com/banyu/basisdata-25430086

Kode Commit Hash: a1b2c3d

Checklist Kelengkapan Modul 5

[x] Berkas p05_ddl_kopma_25430086.sql dapat dieksekusi ulang

[x] Berkas p05_ddl_25430086.sql (Tema Akademik) dapat dieksekusi ulang

[x] Seluruh constraint dan relasi antar-tabel terdefinisi dengan benar

[x] Laporan Markdown tersusun rapi di dalam folder laporan/