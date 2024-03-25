import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:muabansach/APIConstant.dart';
import 'package:muabansach/view/ProfileInfo.dart';
import 'package:muabansach/UserSingleton.dart';
import 'SachWidget.dart';
import '../model/Sach.dart';
import 'GiohangPage.dart';

class Trangchu extends StatefulWidget {
  const Trangchu({Key? key}) : super(key: key);

  @override
  _TrangchuState createState() => _TrangchuState();
}

class _TrangchuState extends State<Trangchu> {
  List<Sach> _sachs = [];
  List<Map<String, dynamic>> _cartItems = [];
  List<Sach> _searchResults = [];
  bool _isLoading = false;
  bool _hasError = false;


  @override
  void initState() {
    super.initState();
    _getAllBooks();
  }

  Future<void> _getAllBooks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse("${APIConstants.ip}/sach"),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<Sach> allBooks = data.map((sachJson) {
          DateTime ngayXuatBan = DateTime.parse(sachJson['ngay_xuat_ban']);
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
          _sachs = allBooks;
          _isLoading = false;
        });
      } else {
        throw Exception("Failed to fetch all books!");
      }
    } catch (error) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
      print('Error fetching all books: $error');
    }
  }
  Future<void> _searchBooks(String searchText) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(

        Uri.parse("${APIConstants.ip}/timsach?ten_sach=$searchText"),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<Sach> searchResults = data.map((sachJson) {
          DateTime ngayXuatBan = DateTime.parse(sachJson['ngay_xuat_ban']);
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
      print('Error searching books: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Books"),
        centerTitle: false,
        flexibleSpace: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 150.0),
          child: Row(
            children: [
              Expanded(

                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
            icon: Icon(Icons.shopping_cart),
          ),
          SizedBox(width: 10),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
            icon: Icon(Icons.person),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.white],
          ),
        ),
        child: Column(
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
                    ? Center(child: CircularProgressIndicator())
                    : (_searchResults.isNotEmpty || _hasError)
                    ? SachWidgets(sachs: _searchResults)

                    : _sachs.isNotEmpty || _isLoading
                    ? SachWidgets(sachs: _sachs)
                    : Center(
                  child: Text("No books found"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
