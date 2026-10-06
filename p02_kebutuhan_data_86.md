# Dokumen Kebutuhan Data - Sistem Informasi Akademik
**NIM:** 25430086 
**Tema Proyek:** Akademik  
**Nilai Parameter P:** 6  

---

## 1. Parameter Proyek
- **Batas Maksimal Mata Kuliah per KRS:** 8 mata kuliah ($P + 2$)
- **Besaran Denda Keterlambatan SPP:** 6% ($P$)
- **Target Volume Transaksi Harian:** 70 transaksi ($40 + 5 \times P$)

---

## 2. Deskripsi Proses Bisnis
1. **Pengelolaan Master Data Akademik:** Petugas administrasi mengelola data utama seperti data mahasiswa, dosen, dan mata kuliah yang ditawarkan.
2. **Pengisian dan Persetujuan KRS:** Mahasiswa memilih mata kuliah untuk semester aktif, kemudian Dosen Wali memeriksa dan menyetujui draf KRS tersebut.
3. **Pencatatan Presensi Perkuliahan:** Dosen mencatat kehadiran mahasiswa pada setiap pertemuan mata kuliah sesuai jadwal yang berlaku.
4. **Pembayaran SPP dan Pengenaan Denda:** Mahasiswa melakukan pembayaran tagihan SPP. Jika melampaui batas waktu, sistem mengenakan denda keterlambatan secara otomatis.

---

## 3. Entitas Kandidat
1. **Mahasiswa:** Menyimpan informasi identitas dan status akademik mahasiswa.
2. **Dosen:** Menyimpan data pengajar dan dosen pembimbing akademik.
3. **MataKuliah:** Menyimpan daftar mata kuliah beserta bobot SKS.
4. **KRS:** Menyimpan data induk rencana studi mahasiswa per semester.
5. **DetailKRS:** Menyimpan daftar mata kuliah spesifik yang diambil dalam satu KRS.
6. **Pembayaran:** Menyimpan riwayat transaksi pembayaran SPP beserta status dan denda.

---

## 4. Aturan Bisnis
1. Setiap Mahasiswa dibimbing oleh tepat 1 Dosen Wali, sedangkan 1 Dosen Wali dapat membimbing banyak Mahasiswa.
2. Mahasiswa hanya diperbolehkan mengambil maksimal **8 mata kuliah** dalam 1 KRS semester aktif.
3. KRS yang diajukan oleh Mahasiswa wajib mendapatkan persetujuan dari Dosen Wali sebelum status perkuliahan dianggap aktif.
4. Mahasiswa tidak dapat memilih mata kuliah yang memiliki bentrok jadwal pada hari dan jam yang sama.
5. Mahasiswa yang masih memiliki tunggakan SPP beserta dendanya tidak dapat memproses pengajuan KRS semester baru.
6. Pembayaran SPP yang melebihi tanggal jatuh tempo dikenakan denda keterlambatan sebesar **6%** dari total tagihan SPP.
7. Setiap transaksi pembayaran SPP menghasilkan nomor kuitansi unik dan mencatat tanggal transaksi secara otomatis.
8. Mahasiswa wajib memenuhi minimal 75% kehadiran dari total pertemuan kelas agar berhak mengikuti Ujian Akhir Semester.
9. Satu entitas KRS dapat memuat banyak entitas DetailKRS, namun setiap DetailKRS hanya terikat pada 1 KRS.

---

## 5. Kebutuhan Informasi
1. **Laporan Kartu Rencana Studi (KRS):** Menampilkan daftar mata kuliah, SKS, dan status persetujuan KRS mahasiswa per semester.
2. **Laporan Rekapitulasi Pembayaran SPP:** Menampilkan riwayat pembayaran, besaran denda keterlambatan 6%, dan status pelunasan.
3. **Laporan Presensi Perkuliahan:** Menampilkan persentase kehadiran mahasiswa pada setiap mata kuliah.
4. **Transkrip Nilai Sementara:** Menampilkan daftar mata kuliah yang telah diselesaikan beserta nilai dan IPK sementara.
5. **Daftar Bimbingan Dosen Wali:** Menampilkan rekapitulasi data mahasiswa yang berada di bawah bimbingan dosen tertentu.

---

## 6. Matriks CRUD (Create, Read, Update, Delete)

| Proses Bisnis | Mahasiswa | Dosen | MataKuliah | KRS | DetailKRS | Pembayaran |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| Pengelolaan Master Data | CRUD | CRUD | CRUD | - | - | - |
| Pengisian & Approval KRS | R | R | R | CRU | CRD | - |
| Pencatatan Presensi | R | R | R | R | R | - |
| Pembayaran SPP | R | - | - | R | - | CRU |

---

## 7. Kamus Data Awal

### a. Mahasiswa
- `nim` (VARCHAR(15), Primary Key) - Nomor Induk Mahasiswa
- `nama_mahasiswa` (VARCHAR(100)) - Nama lengkap mahasiswa
- `id_dosen_wali` (VARCHAR(15), Foreign Key) - ID dosen pembimbing
- `email` (VARCHAR(100)) - Email resmi mahasiswa

### b. Dosen
- `nip` (VARCHAR(15), Primary Key) - Nomor Induk Pegawai dosen
- `nama_dosen` (VARCHAR(100)) - Nama lengkap dosen
- `no_hp` (VARCHAR(15)) - Nomor telepon dosen

### c. MataKuliah
- `kode_mk` (VARCHAR(10), Primary Key) - Kode mata kuliah
- `nama_mk` (VARCHAR(100)) - Nama mata kuliah
- `sks` (INT) - Jumlah SKS mata kuliah

### d. KRS
- `id_krs` (VARCHAR(20), Primary Key) - Identifier unik KRS
- `nim` (VARCHAR(15), Foreign Key) - NIM mahasiswa pemilik KRS
- `semester` (VARCHAR(10)) - Semester berlangsung (misal: 2026/2027 Ganjil)
- `status_approval` (VARCHAR(20)) - Status persetujuan (Pending/Approved)

### e. DetailKRS
- `id_detail` (VARCHAR(20), Primary Key) - Identifier unik detail KRS
- `id_krs` (VARCHAR(20), Foreign Key) - ID KRS induk
- `kode_mk` (VARCHAR(10), Foreign Key) - Kode mata kuliah yang diambil

### f. Pembayaran
- `no_kuitansi` (VARCHAR(20), Primary Key) - Nomor transaksi pembayaran
- `nim` (VARCHAR(15), Foreign Key) - NIM mahasiswa
- `nominal_spp` (DECIMAL(10,2)) - Jumlah tagihan SPP
- `denda` (DECIMAL(10,2)) - Besaran denda keterlambatan (6%)
- `tanggal_bayar` (DATE) - Tanggal transaksi dilakukan

---

## 8. Batasan dan Asumsi Sistem
1. **Integrasi Pembayaran:** Sistem saat ini hanya mencatat transaksi pembayaran secara manual dari kasir/bank dan belum terintegrasi *gateway* pembayaran otomatis.
2. **Validasi Bentrok Jadwal:** Penjadwalan kelas diasumsikan diatur terpisah oleh bagian kurikulum, dan sistem hanya melakukan verifikasi jam bentrok saat mahasiswa menyimpan draf KRS.
3. **Pengarsipan Data:** Data KRS dan transaksi pembayaran lama diarsipkan secara berkala setiap pergantian tahun akademik tanpa menghapus riwayat utama mahasiswa.

---

## 9. Glosarium Istilah
1. **KRS (Kartu Rencana Studi):** Dokumen elektronik berisi daftar mata kuliah yang didaftarkan oleh mahasiswa untuk semester tertentu.
2. **SKS (Satuan Kredit Semester):** Bobot beban studi tiap mata kuliah yang membatasi total beban belajar mahasiswa.
3. **Dosen Wali:** Dosen yang bertugas membimbing akademik mahasiswa serta memverifikasi dan menyetujui pengajuan KRS.
4. **SPP (Sumbangan Pembinaan Pendidikan):** Kewajiban biaya operasional pendidikan rutin yang wajib dilunasi mahasiswa per semester.