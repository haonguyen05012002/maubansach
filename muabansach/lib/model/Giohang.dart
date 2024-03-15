import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:muabansach/UserSingleton.dart';
import 'package:muabansach/model/Sach.dart';

class Giohang extends StatefulWidget {
  @override
  _GioHangPageState createState() => _GioHangPageState();
}

class _GioHangPageState extends State<Giohang> {
  List<GioHang> gioHangItems = [];

  @override
  void initState() {
    super.initState();
    loadCartItems();
  }

  Future<void> loadCartItems() async {
    try {
      final int userId = UserSingleton().getUserId() ?? 0; // Sử dụng `?? 0` để tránh lỗi null nếu userId không có giá trị

      final response = await http.get(
        Uri.parse('http://localhost:3000/api/giohang/$userId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> gioHangJson = json.decode(response.body);
        setState(() {
          gioHangItems = gioHangJson.map((json) => GioHang.fromJson(json)).toList();
        });
      } else {
        // Xử lý lỗi nếu không thể kết nối được với API hoặc không tìm thấy sản phẩm
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Xử lý lỗi nếu có bất kỳ lỗi nào khác xảy ra
      print('Error: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ hàng'),
      ),
      body: ListView.builder(
        itemCount: gioHangItems.length,
        itemBuilder: (context, index) {
          final gioHangItem = gioHangItems[index];
          return ListTile(
            title: Text(gioHangItem.sach.tieu_de ?? ''),
            subtitle: Text('Giá: ${gioHangItem.sach.gia} VNĐ'),
            // Thêm các thuộc tính khác của sản phẩm vào đây nếu cần
          );
        },
      ),
    );
  }
}

class GioHang {
  final int id; // ID của mục giỏ hàng
  final Sach sach; // Sản phẩm trong giỏ hàng
  final int id_nguoidung; // ID của người dùng

  GioHang({
    required this.id,
    required this.sach,
    required this.id_nguoidung,
  });

  // factory GioHang.fromJson(Map<String, dynamic> json) {
  //   return GioHang(
  //     id: json['id'] as int,
  //     sach: Sach.fromJson(json['sach'] as Map<String, dynamic>),
  //     id_nguoidung: json['id_nguoidung'] as int,
  //   );
  // }
  factory GioHang.fromJson(Map<String, dynamic> json) {
    return GioHang(
      id: json['id'] as int,
      sach: json['sach'] != null ? Sach.fromJson(json['sach'] as Map<String, dynamic>) : Sach(
        id_sach: 0, // Giá trị mặc định cho id_sach nếu không có dữ liệu
        tieu_de: '', // Giá trị mặc định cho tieu_de nếu không có dữ liệu
        ngay_xuat_ban: DateTime.now(), // Giá trị mặc định cho ngay_xuat_ban nếu không có dữ liệu
        id_theloai: 0, // Giá trị mặc định cho id_theloai nếu không có dữ liệu
        mo_ta: '', // Giá trị mặc định cho mo_ta nếu không có dữ liệu
        hinh_bia: null, // Giá trị mặc định cho hinh_bia nếu không có dữ liệu
        id_nhaxuatban: 0, // Giá trị mặc định cho id_nhaxuatban nếu không có dữ liệu
        id_tacgia: 0, // Giá trị mặc định cho id_tacgia nếu không có dữ liệu
        danhgia: 0, // Giá trị mặc định cho danhgia nếu không có dữ liệu
        gia: 0, // Giá trị mặc định cho gia nếu không có dữ liệu
      ),
      id_nguoidung: json['id_nguoidung'] as int,
    );
  }



}
