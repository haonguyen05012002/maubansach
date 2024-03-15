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
  List<Sach> sachList = [];

  @override
  void initState() {
    super.initState();
    loadCartItems();
  }

  Future<void> loadCartItems() async {
    try {
      final int userId = UserSingleton().getUserId() ?? 0;

      final response = await http.get(
        Uri.parse('http://localhost:3000/api/giohang/$userId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> gioHangJson = json.decode(response.body);
        final List<int> idSachList = gioHangJson.map((json) => json['id_sach'] as int).toList();

        // Load sách từ danh sách id_sach đã lọc
        final sachList = await fetchBooksInCart(idSachList);
        setState(() {
          this.sachList = sachList;
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<List<Sach>> fetchBooksInCart(List<int> idSachList) async {
    List<Sach> sachList = [];
    for (int idSach in idSachList) {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/sach/$idSach'),
      );

      if (response.statusCode == 200) {
        final sachJson = json.decode(response.body);
        final sach = Sach.fromJson(sachJson);
        sachList.add(sach);
      } else {
        print('Error fetching sach with id $idSach: ${response.statusCode}');
      }
    }
    return sachList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ hàng'),
      ),
      body: sachList.isNotEmpty
          ? ListView.builder(
        itemCount: sachList.length,
        itemBuilder: (context, index) {
          final sach = sachList[index];
          return ListTile(
            title: Text(sach.tieu_de),
            subtitle: Text('Giá: ${sach.gia} VNĐ'),
          );
        },
      )
          : Center(
        child: Text('Không có sản phẩm trong giỏ hàng'),
      ),
    );
  }
}
