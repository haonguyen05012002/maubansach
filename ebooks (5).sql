-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Mar 13, 2024 at 03:04 AM
-- Server version: 8.0.31
-- PHP Version: 8.0.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ebooks`
--

-- --------------------------------------------------------

--
-- Table structure for table `binhluan`
--

DROP TABLE IF EXISTS `binhluan`;
CREATE TABLE IF NOT EXISTS `binhluan` (
  `id_binhluan` int NOT NULL AUTO_INCREMENT,
  `id_sach` int DEFAULT NULL,
  `id_nguoidung` int DEFAULT NULL,
  `binh_luan` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_binhluan`),
  KEY `id_sach` (`id_sach`),
  KEY `id_nguoidung` (`id_nguoidung`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `giohang`
--

DROP TABLE IF EXISTS `giohang`;
CREATE TABLE IF NOT EXISTS `giohang` (
  `id` int NOT NULL,
  `id_sach` int NOT NULL,
  `id_nguoidung` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_nguoidung` (`id_nguoidung`),
  KEY `id_sach` (`id_sach`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hoadon`
--

DROP TABLE IF EXISTS `hoadon`;
CREATE TABLE IF NOT EXISTS `hoadon` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_nguoidung` int NOT NULL,
  `tienthanhtoan` int NOT NULL,
  `trangthai` int NOT NULL,
  `hinhthuctt` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_nguoidung` (`id_nguoidung`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nguoidung`
--

DROP TABLE IF EXISTS `nguoidung`;
CREATE TABLE IF NOT EXISTS `nguoidung` (
  `id_nguoidung` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mat_khau` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `admin` bit(1) NOT NULL,
  PRIMARY KEY (`id_nguoidung`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nguoidung`
--

INSERT INTO `nguoidung` (`id_nguoidung`, `email`, `mat_khau`, `admin`) VALUES
(46, '1@gmail.com', '1', b'0');

-- --------------------------------------------------------

--
-- Table structure for table `nhaxuatban`
--

DROP TABLE IF EXISTS `nhaxuatban`;
CREATE TABLE IF NOT EXISTS `nhaxuatban` (
  `id_nhaxuatban` int NOT NULL AUTO_INCREMENT,
  `ten_nhaxuatban` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_nhaxuatban`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nhaxuatban`
--

INSERT INTO `nhaxuatban` (`id_nhaxuatban`, `ten_nhaxuatban`) VALUES
(1, 'Kim Đồng'),
(2, 'Trẻ'),
(3, 'NXB Giáo Dục'),
(7, 'STU'),
(8, 'Kim Đồng'),
(9, 'Trẻ'),
(10, 'NXB Giáo Dục'),
(11, 'STU');

-- --------------------------------------------------------

--
-- Table structure for table `sach`
--

DROP TABLE IF EXISTS `sach`;
CREATE TABLE IF NOT EXISTS `sach` (
  `id_sach` int NOT NULL AUTO_INCREMENT,
  `tieu_de` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ngay_xuat_ban` date DEFAULT NULL,
  `id_theloai` int DEFAULT NULL,
  `mo_ta` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `hinh_bia` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `noidung` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `id_nhaxuatban` int NOT NULL,
  `id_tacgia` int NOT NULL,
  `danhgia` int NOT NULL,
  `gia` int NOT NULL,
  PRIMARY KEY (`id_sach`),
  KEY `id_theloai` (`id_theloai`),
  KEY `id_tacgia` (`id_tacgia`),
  KEY `id_nhaxuatban` (`id_nhaxuatban`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tacgia`
--

DROP TABLE IF EXISTS `tacgia`;
CREATE TABLE IF NOT EXISTS `tacgia` (
  `id_tacgia` int NOT NULL AUTO_INCREMENT,
  `ten_tacgia` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ngay_sinh` date DEFAULT NULL,
  PRIMARY KEY (`id_tacgia`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `theloai`
--

DROP TABLE IF EXISTS `theloai`;
CREATE TABLE IF NOT EXISTS `theloai` (
  `id_theloai` int NOT NULL AUTO_INCREMENT,
  `ten_theloai` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_theloai`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `voucher`
--

DROP TABLE IF EXISTS `voucher`;
CREATE TABLE IF NOT EXISTS `voucher` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ten` int NOT NULL,
  `dieukien` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dieukien` (`dieukien`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `binhluan`
--
ALTER TABLE `binhluan`
  ADD CONSTRAINT `binhluan_ibfk_1` FOREIGN KEY (`id_sach`) REFERENCES `sach` (`id_sach`) ON DELETE CASCADE ON UPDATE RESTRICT,
  ADD CONSTRAINT `binhluan_ibfk_2` FOREIGN KEY (`id_nguoidung`) REFERENCES `nguoidung` (`id_nguoidung`);

--
-- Constraints for table `giohang`
--
ALTER TABLE `giohang`
  ADD CONSTRAINT `giohang_ibfk_1` FOREIGN KEY (`id_nguoidung`) REFERENCES `nguoidung` (`id_nguoidung`),
  ADD CONSTRAINT `giohang_ibfk_2` FOREIGN KEY (`id_sach`) REFERENCES `sach` (`id_sach`);

--
-- Constraints for table `hoadon`
--
ALTER TABLE `hoadon`
  ADD CONSTRAINT `hoadon_ibfk_1` FOREIGN KEY (`id_nguoidung`) REFERENCES `nguoidung` (`id_nguoidung`);

--
-- Constraints for table `sach`
--
ALTER TABLE `sach`
  ADD CONSTRAINT `sach_ibfk_1` FOREIGN KEY (`id_tacgia`) REFERENCES `tacgia` (`id_tacgia`),
  ADD CONSTRAINT `sach_ibfk_2` FOREIGN KEY (`id_nhaxuatban`) REFERENCES `nhaxuatban` (`id_nhaxuatban`),
  ADD CONSTRAINT `sach_ibfk_3` FOREIGN KEY (`id_theloai`) REFERENCES `theloai` (`id_theloai`);

--
-- Constraints for table `voucher`
--
ALTER TABLE `voucher`
  ADD CONSTRAINT `voucher_ibfk_1` FOREIGN KEY (`dieukien`) REFERENCES `theloai` (`id_theloai`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
