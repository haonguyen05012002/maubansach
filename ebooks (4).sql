-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Mar 09, 2024 at 08:46 AM
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `giohang`
--

INSERT INTO `giohang` (`id`, `id_sach`) VALUES
(1, 11),
(2, 2),
(3, 3);

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
  `id_giohang` int NOT NULL,
  PRIMARY KEY (`id_nguoidung`),
  KEY `id_giohang` (`id_giohang`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nguoidung`
--

INSERT INTO `nguoidung` (`id_nguoidung`, `email`, `mat_khau`, `admin`, `id_giohang`) VALUES
(44, '1@gmail.com', '1', b'0', 1),
(45, 'user2@example.com', 'password2', b'1', 2);

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

--
-- Dumping data for table `sach`
--

INSERT INTO `sach` (`id_sach`, `tieu_de`, `ngay_xuat_ban`, `id_theloai`, `mo_ta`, `hinh_bia`, `noidung`, `id_nhaxuatban`, `id_tacgia`, `danhgia`, `gia`) VALUES
(25, 'Nhà Giả Kim', '1988-04-25', 9, 'Một cuốn tiểu thuyết triết học', 'alchemist.jpg', 'Hành trình tìm kiếm chân lý bản thân', 1, 2, 4, 250000),
(26, 'Doraemon', '1969-12-23', 10, 'Một bộ truyện tranh Nhật Bản nổi tiếng', 'doraemon.jpg', 'Những cuộc phiêu lưu của một chú mèo robot', 2, 1, 5, 120000),
(27, 'Mã Da Vinci', '2003-03-18', 13, 'Một cuốn tiểu thuyết huyền bí hồi hộp', 'davinci.jpg', 'Âm mưu và câu đố', 3, 3, 4, 300000),
(28, 'Người Hành Tinh Đỏ', '2011-09-27', 11, 'Một cuốn tiểu thuyết khoa học viễn tưởng', 'martian.jpg', 'Chuyến phiêu lưu sống còn trên Sao Hỏa', 1, 4, 4, 280000);

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

--
-- Dumping data for table `tacgia`
--

INSERT INTO `tacgia` (`id_tacgia`, `ten_tacgia`, `ngay_sinh`) VALUES
(1, 'Nguyễn Nhật Ánh', '1990-01-15'),
(2, 'Thiên Tàm Thổ', '1985-05-20'),
(3, 'T.A Ilina', '1978-12-10'),
(4, 'Elon Musk', '2013-12-03'),
(5, 'Thành Nhân', '2002-07-27'),
(7, 'Nguyễn Nhật Ánh', '1990-01-15'),
(8, 'Thiên Tàm Thổ', '1985-05-20'),
(9, 'T.A Ilina', '1978-12-10'),
(10, 'Elon Musk', '2013-12-03'),
(11, 'Thành Nhân', '2002-07-27');

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

--
-- Dumping data for table `theloai`
--

INSERT INTO `theloai` (`id_theloai`, `ten_theloai`) VALUES
(9, 'Khoa Học Viễn Tưởng'),
(10, 'Lãng Mạn'),
(11, 'Bí Mật'),
(12, 'Tiểu Sử'),
(13, 'Fantasy'),
(14, 'Hồi Hộp'),
(15, 'Kịch Tính'),
(16, 'Phiêu Lưu'),
(17, 'Lịch Sử');

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
-- Constraints for table `hoadon`
--
ALTER TABLE `hoadon`
  ADD CONSTRAINT `hoadon_ibfk_1` FOREIGN KEY (`id_nguoidung`) REFERENCES `nguoidung` (`id_nguoidung`);

--
-- Constraints for table `nguoidung`
--
ALTER TABLE `nguoidung`
  ADD CONSTRAINT `nguoidung_ibfk_1` FOREIGN KEY (`id_giohang`) REFERENCES `giohang` (`id`);

--
-- Constraints for table `sach`
--
ALTER TABLE `sach`
  ADD CONSTRAINT `sach_ibfk_1` FOREIGN KEY (`id_theloai`) REFERENCES `theloai` (`id_theloai`),
  ADD CONSTRAINT `sach_ibfk_2` FOREIGN KEY (`id_tacgia`) REFERENCES `tacgia` (`id_tacgia`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sach_ibfk_3` FOREIGN KEY (`id_nhaxuatban`) REFERENCES `nhaxuatban` (`id_nhaxuatban`);

--
-- Constraints for table `voucher`
--
ALTER TABLE `voucher`
  ADD CONSTRAINT `voucher_ibfk_1` FOREIGN KEY (`dieukien`) REFERENCES `theloai` (`id_theloai`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
