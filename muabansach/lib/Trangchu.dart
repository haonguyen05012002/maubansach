import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:muabansach/ProfileInfo.dart';
import 'package:muabansach/UserSingleton.dart';
import 'package:muabansach/main.dart';
import 'dart:async';
import 'dart:convert';
import 'SachWidget.dart';
import 'Sach.dart';
import 'model/GiohangPage.dart';

// void main() {
//   runApp(const Trangchu());
// }

class Trangchu extends StatefulWidget {
  const Trangchu({Key? key}) : super(key: key);

  @override
  _TrangchuState createState() => _TrangchuState();
}

class _TrangchuState extends State<Trangchu> {
  List<Sach> _sachs = [];
  List<Map<String, dynamic>> _cartItems = [];

  bool _isLoading = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _populateAllBooks();
    print(UserSingleton().getUserId());
  }

  Future<void> _populateAllBooks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final sach = await _fetchAllBooks();
      setState(() {
        _sachs = sach;
        _hasError = false;
      });
    } catch (error) {
      setState(() {
        _hasError = true;
      });
      // Handle error, e.g., show an error message
      print('Error loading books: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<Sach>> _fetchAllBooks() async {
    final response = await http.get(
      Uri.parse("http://localhost:3000/api/sach"),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      List<Sach> sachList = data.map((sachJson) {
        // Chuyển đổi chuỗi thành DateTime
        DateTime ngayXuatBan = DateTime.parse(sachJson['ngay_xuat_ban']);
        // Tạo một đối tượng Sach từ JSON
        return Sach(
          id_sach: sachJson['id_sach'],
          tieu_de: sachJson['tieu_de'],
          ngay_xuat_ban: ngayXuatBan,
          id_theloai: sachJson['id_theloai'],
          mo_ta: sachJson['mo_ta'],
          hinh_bia: sachJson['hinh_bia'],
          noidung: sachJson['noidung'],
          id_nhaxuatban: sachJson['id_nhaxuatban'],
          id_tacgia: sachJson['id_tacgia'],
          danhgia: sachJson['danhgia'],
          gia: sachJson['gia'],
        );
      }).toList();
      return sachList;
    } else {
      throw Exception("Failed to load books!");
    }
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Smart Books",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Smart Books"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Giohang()),
                );
              },
              icon: Icon(Icons.shopping_cart),
            ),
            SizedBox(width: 10),
            IconButton(
              onPressed: () {
                print('Button 2 pressed');
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage())
                );
              },
              icon: Icon(Icons.person_off_rounded),
            ),
          ],
        ),
        body: Container(
          child: _sachs.isNotEmpty
              ? SachWidgets(sachs: _sachs) // Truyền hàm addToCart vào SachWidgets
              : const Center(
            child: Text("No books found"),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.white],
            ),
          ),
        ),
      ),
    );
  }
}
