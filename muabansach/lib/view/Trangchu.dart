import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:muabansach/APIConstant.dart';
import 'package:muabansach/view/ProfileInfo.dart';
import 'package:muabansach/UserSingleton.dart';
import '../model/Sach.dart';
import 'GiohangPage.dart';
import 'SachWidget.dart';

String ip = APIConstants.ip;

class Trangchu extends StatefulWidget {
  const Trangchu({Key? key}) : super(key: key);

  @override
  _TrangchuState createState() => _TrangchuState();
}

class _TrangchuState extends State<Trangchu> {
  List<Sach> _sachs = [];
  List<Sach> _searchResults = [];
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
      Uri.parse("$ip/sach"),
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

  Future<void> _searchBooks(String searchText) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse("$ip/timsach?ten_sach=$searchText"),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<Sach> searchResults = data.map((sachJson) {
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
        setState(() {
          _searchResults = searchResults;
          _hasError = false;
        });
      } else {
        throw Exception("Failed to search books!");
      }
    } catch (error) {
      setState(() {
        _hasError = true;
      });
      // Handle error, e.g., show an error message
      print('Error searching books: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
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
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              icon: Icon(Icons.person_off_rounded),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              color: Colors.grey[200],
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: TextField(
                        onChanged: _searchBooks,
                        decoration: InputDecoration(
                          hintText: "Search...",
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: _isLoading
                    ? Center(child: CircularProgressIndicator()) // Nếu đang tải, hiển thị biểu tượng tiến trình
                    : _searchResults.isNotEmpty // Nếu có kết quả tìm kiếm
                    ? SachWidgets(sachs: _searchResults) // Hiển thị kết quả tìm kiếm
                    : _sachs.isNotEmpty // Nếu không có kết quả tìm kiếm, nhưng danh sách sách không rỗng
                    ? SachWidgets(sachs: _sachs) // Hiển thị danh sách sách
                    : const Center( // Nếu cả hai danh sách đều rỗng
                  child: Text("No books found"), // Hiển thị thông báo "No books found"
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
          ],
        ),
      ),
    );
  }
}
