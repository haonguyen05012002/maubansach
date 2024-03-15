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
      final sachList = await fetchBooksInCart(userId);
      setState(() {
        this.sachList = sachList;
      });
    } catch (e) {
      print('Error: $e');
    }
  }




  Future<List<Sach>> fetchBooksInCart(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/sach/$userId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> sachJsonList = json.decode(response.body);
        List<Sach> sachList = [];
        for (var sachJson in sachJsonList) {
          final sach = Sach.fromJson(sachJson);
          sachList.add(sach);
        }
        return sachList;
      } else {
        print('Error fetching books for user $userId: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
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
