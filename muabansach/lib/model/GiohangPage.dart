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
  Future<void> _removeItemFromCart(int sachId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:3000/api/giohang'), // Thay đổi đường dẫn API
        body: json.encode({
          'id_nguoidung': UserSingleton().getUserId(),
          'id_sach': sachId,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Xóa sản phẩm khỏi danh sách khi xóa thành công
        setState(() {
          sachList.removeWhere((sach) => sach.id_sach == sachId);
        });
        // Hiển thị thông báo khi xóa thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã xóa sản phẩm khỏi giỏ hàng'),
          ),
        );
      } else {
        print('Error removing item from cart: ${response.statusCode}');
        // Hiển thị thông báo khi xóa thất bại
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Xóa sản phẩm khỏi giỏ hàng thất bại'),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      // Hiển thị thông báo khi xóa thất bại
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Xóa sản phẩm khỏi giỏ hàng thất bại'),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ hàng'),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.white, Colors.blue, ]
            )
        ),
        child: sachList.isNotEmpty
            ? ListView.builder(
          itemCount: sachList.length,
          itemBuilder: (context, index) {
            final sach = sachList[index];
            return ListTile(
              title: Text(sach.tieu_de),
              subtitle: Text('Giá: ${sach.gia} VNĐ'),
              trailing: IconButton( // Thêm nút xóa vào phần trailing của ListTile
                icon: Icon(Icons.delete),
                onPressed: () {
                  _removeItemFromCart(sach.id_sach);
                },
              ),
            );
          },
        )
            : Center(
          child: Text('Không có sản phẩm trong giỏ hàng'),
        ),
      ),
    );
  }
}