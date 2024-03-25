-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Mar 22, 2024 at 05:18 PM
-- Server version: 8.2.0
-- PHP Version: 8.0.30

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
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `giohang`
--

DROP TABLE IF EXISTS `giohang`;
CREATE TABLE IF NOT EXISTS `giohang` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_sach` int NOT NULL,
  `id_nguoidung` int NOT NULL,
  `soluong` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_nguoidung` (`id_nguoidung`),
  KEY `id_sach` (`id_sach`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `giohang`
--

INSERT INTO `giohang` (`id`, `id_sach`, `id_nguoidung`, `soluong`) VALUES
(23, 67, 46, 1),
(25, 47, 1, 2),
(26, 64, 1, 2);

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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `hoadon`
--

INSERT INTO `hoadon` (`id`, `id_nguoidung`, `tienthanhtoan`, `trangthai`, `hinhthuctt`) VALUES
(5, 48, 200000, 1, 'MOMO'),
(6, 49, 150000, 1, 'ZALOPAY');

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
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nguoidung`
--

INSERT INTO `nguoidung` (`id_nguoidung`, `email`, `mat_khau`, `admin`) VALUES
(1, '1', '1', b'0'),
(46, '1@gmail.com', '1', b'0'),
(47, 'admin@example.com', 'adminpass', b'1'),
(48, 'user1@example.com', 'user1pass', b'0'),
(49, 'user2@example.com', 'user2pass', b'0'),
(50, 'admin@example.com', 'adminpass', b'1'),
(51, 'user1@example.com', 'user1pass', b'0'),
(52, 'user2@example.com', 'user2pass', b'0');

-- --------------------------------------------------------

--
-- Table structure for table `nhaxuatban`
--

DROP TABLE IF EXISTS `nhaxuatban`;
CREATE TABLE IF NOT EXISTS `nhaxuatban` (
  `id_nhaxuatban` int NOT NULL AUTO_INCREMENT,
  `ten_nhaxuatban` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_nhaxuatban`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nhaxuatban`
--

INSERT INTO `nhaxuatban` (`id_nhaxuatban`, `ten_nhaxuatban`) VALUES
(1, 'Kim Đồng'),
(2, 'Trẻ'),
(3, 'NXB Giáo Dục'),
(7, 'STU'),
(10, 'NXB Giáo Dục');

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
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sach`
--

INSERT INTO `sach` (`id_sach`, `tieu_de`, `ngay_xuat_ban`, `id_theloai`, `mo_ta`, `hinh_bia`, `noidung`, `id_nhaxuatban`, `id_tacgia`, `danhgia`, `gia`) VALUES
(47, 'Tắt đèn', '2005-09-10', 18, 'Tiểu thuyết tâm lý', 'tat-den.jpg', 'Nội dung của cuốn sách Tắt đèn...', 1, 12, 4, 80000),
(48, 'Harry Potter và Hòn đá Phù thủy', '1997-06-26', 19, 'Tiểu thuyết phép thuật', 'harry-potter.jpg', 'Nội dung của cuốn sách Harry Potter...', 2, 13, 5, 120000),
(49, 'Bác Hồ và Hà Nội', '2020-01-01', 20, 'Sách lịch sử', 'bac-ho.jpg', 'Nội dung của cuốn sách Bác Hồ và Hà Nội...', 3, 14, 5, 100000),
(62, 'Dấu Chân Trên Cát', '2010-01-15', 18, 'Cuốn sách tâm linh viết về hành trình tìm kiếm ý nghĩa của cuộc sống.', 'dau_chan_tren_cat.jpg', 'Nội dung cuốn sách Dấu Chân Trên Cát...', 2, 14, 4, 120000),
(63, 'Cuộc Phiêu Lưu Của Alice Ở Xứ Sở Thần Tiên', '1865-11-26', 18, 'Một trong những cuốn sách kinh điển của văn học thiếu nhi.', 'alice_oo_xu_so_than_tien.jpg', 'Nội dung cuốn sách Cuộc Phiêu Lưu Của Alice Ở Xứ Sở Thần Tiên...', 3, 12, 5, 150000),
(64, 'Người Tìm Hạnh Phúc', '2017-08-08', 20, 'Cuốn sách tự truyện của tác giả Laurent Gounelle, chia sẻ về hành trình tìm kiếm hạnh phúc.', 'nguoi_tim_hanh_phuc.jpg', 'Nội dung cuốn sách Người Tìm Hạnh Phúc...', 1, 12, 4, 135000),
(65, 'Thiên Long Bát Bộ', '1994-01-01', 19, 'Một trong những tác phẩm tiên hiệp nổi tiếng của Kim Dung, kể về cuộc phiêu lưu của Thiên Long Bát Bộ.', 'thien_long_bat_bo.jpg', 'Nội dung cuốn sách Thiên Long Bát Bộ...', 1, 14, 5, 200000),
(66, 'Đấu La Đại Lục', '2000-05-01', 19, 'Cuốn tiểu thuyết tiên hiệp của Dương Thất Thất, một trong những tác phẩm nổi tiếng của văn học Trung Quốc.', 'dau_la_dai_luc.jpg', 'Nội dung cuốn sách Đấu La Đại Lục...', 7, 13, 4, 180000),
(67, 'Tam Quốc Diễn Nghĩa', '0000-00-00', 18, 'Một trong những tác phẩm lịch sử võ hiệp nổi tiếng của Trung Quốc, kể về thời kỳ Tam Quốc.', 'tam_quoc_dien_nghia.jpg', 'Nội dung cuốn sách Tam Quốc Diễn Nghĩa...', 10, 12, 5, 250000);

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
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tacgia`
--

INSERT INTO `tacgia` (`id_tacgia`, `ten_tacgia`, `ngay_sinh`) VALUES
(12, 'Nguyễn Nhật Ánh', '1971-05-15'),
(13, 'J.K. Rowling', '1965-07-31'),
(14, 'Hồ Chí Minh', '1890-05-19');

-- --------------------------------------------------------

--
-- Table structure for table `theloai`
--

DROP TABLE IF EXISTS `theloai`;
CREATE TABLE IF NOT EXISTS `theloai` (
  `id_theloai` int NOT NULL AUTO_INCREMENT,
  `ten_theloai` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_theloai`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `theloai`
--

INSERT INTO `theloai` (`id_theloai`, `ten_theloai`) VALUES
(18, 'Tiểu thuyết'),
(19, 'Khoa học'),
(20, 'Lịch sử');

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
