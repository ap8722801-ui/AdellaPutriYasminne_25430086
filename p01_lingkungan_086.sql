-- Skrip Lingkungan Modul 1
CREATE DATABASE IF NOT EXISTS kopma_123
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'mhs_086'@'localhost' IDENTIFIED BY '<password_kerja>';

GRANT ALL PRIVILEGES ON kopma_086.* TO 'mhs_086'@'localhost';
FLUSH PRIVILEGES;