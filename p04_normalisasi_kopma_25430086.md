Dokumen Normalisasi dan Skema Relasional - Proyek Koperasi Mahasiswa (Kopma)
Nama: Adella Putri Yasminne

NIM: 25430086

Tema Proyek: Koperasi Mahasiswa (kopma_086)

1. Titik Awal UNF (Unnormalized Form)
Berdasarkan dokumen sumber Nota Transaksi Penjualan & Daftar Inventaris Barang Kopma, bentuk data mentah sebelum dinormalisasi adalah sebagai berikut:

TRANSAKSI_UNF (id_transaksi, tanggal_transaksi, id_kasir, nama_kasir, 
               id_anggota, nama_anggota, diskon_anggota,
               { kode_barang, nama_barang, kategori_barang, harga_satuan, jumlah_beli }, 
               total_transaksi)
2. Tahapan Normalisasi
A. 1NF (First Normal Form)
Menghilangkan repeating group (grup berulang) pada daftar barang yang dibeli dalam satu transaksi sehingga setiap sel bernilai atomik. Kunci primernya menjadi kunci komposit (id_transaksi, kode_barang):

Plaintext
TRANSAKSI_1NF (id_transaksi, tanggal_transaksi, id_kasir, nama_kasir, 
               id_anggota, nama_anggota, diskon_anggota, 
               kode_barang, nama_barang, kategori_barang, harga_satuan, jumlah_beli, total_transaksi)
B. 2NF (Second Normal Form)
Memisahkan ketergantungan parsial (partial dependency) di mana atribut bukan kunci hanya bergantung pada sebagian dari kunci komposit:

KASIR: (id_kasir, nama_kasir)

ANGGOTA: (id_anggota, nama_anggota, diskon_anggota)

BARANG: (kode_barang, nama_barang, kategori_barang, harga_satuan)

TRANSAKSI_HEADER: (id_transaksi, tanggal_transaksi, id_kasir, id_anggota)

TRANSAKSI_DETAIL: (id_transaksi*, kode_barang*, jumlah_beli)

C. 3NF (Third Normal Form)
Memisahkan ketergantungan transitif (transitive dependency) di mana atribut bukan kunci menentukan atribut bukan kunci lain (tidak ada dependensi transitif antar atribut non-kunci yang tersisa pada skema di atas):

KASIR: (id_kasir, nama_kasir)

ANGGOTA: (id_anggota, nama_anggota, diskon_anggota)

BARANG: (kode_barang, nama_barang, kategori_barang, harga_satuan)

TRANSAKSI: (id_transaksi, tanggal_transaksi, id_kasir*, id_anggota*)

DETAIL_TRANSAKSI: (id_transaksi*, kode_barang*, jumlah_beli)

(Garis bawah = Primary Key, * = Foreign Key)

3. Dependensi Fungsional (FD)
Dependensi Fungsional diturunkan dari Aturan Bisnis (Business Rules) sistem Koperasi Mahasiswa:

FD1 (Transaksi): id_transaksi -> tanggal_transaksi, id_kasir, id_anggota

(Aturan Bisnis: Setiap ID transaksi mencatat waktu kejadian, kasir yang melayani, dan anggota yang berbelanja)

FD2 (Kasir): id_kasir -> nama_kasir

(Aturan Bisnis: Setiap kasir diidentifikasi oleh kode kasir yang unik)

FD3 (Anggota): id_anggota -> nama_anggota, diskon_anggota

(Aturan Bisnis: Setiap anggota koperasi memiliki nama dan hak besar diskon khusus)

FD4 (Barang): kode_barang -> nama_barang, kategori_barang, harga_satuan

(Aturan Bisnis: Setiap produk barang memiliki kode, nama, kategori, dan harga jual tetap)

FD5 (Detail Transaksi): (id_transaksi, kode_barang) -> jumlah_beli

(Aturan Bisnis: Kombinasi transaksi dan barang menentukan kuantitas produk yang dibeli)

4. Pemeriksaan BCNF (Boyce-Codd Normal Form)
Pada seluruh relasi tabel hasil 3NF di atas, setiap penentu (determinan) pada dependensi fungsional (id_transaksi, id_kasir, id_anggota, kode_barang, serta kunci komposit (id_transaksi, kode_barang)) merupakan candidate key (kunci kandidat). Oleh karena itu, seluruh skema relasional sistem Kopma ini sudah memenuhi syarat Boyce-Codd Normal Form (BCNF).

5. Keputusan Nilai Turunan (Derived Attribute)
Atribut: total_transaksi (Nilai Turunan berupa total harga keseluruhan pembelian)

Keputusan: TIDAK DISIMPAN secara permanen di dalam tabel operasional transaksi harian.

Alasan: Total transaksi dapat dihitung secara dinamis (on-the-fly) menggunakan fungsi agregat SQL (SUM(harga_satuan * jumlah_beli)) saat pembuatan struk atau laporan keuangan kasir. Hal ini mencegah terjadinya anomali pembaruan (update anomaly) jika terjadi perubahan harga satuan barang di masa mendatang dan menjaga konsistensi integritas data.

6. Catatan Pembaruan ERD Proyek Kopma
Hasil normalisasi ini memisahkan entitas master Kasir, Anggota, dan Barang dari entitas transaksional (Transaksi dan Detail Transaksi). Oleh karena itu, pada rancangan ERD proyek Kopma dibuat relasi:

Entitas Kasir berelasi 1-to-Many dengan Transaksi (Satu kasir dapat melayani banyak transaksi).

Entitas Anggota berelasi 1-to-Many dengan Transaksi (Satu anggota dapat melakukan banyak transaksi).

Entitas Transaksi dan Barang berelasi Many-to-Many yang dihubungkan melalui tabel entitas asosiatif Detail Transaksi.