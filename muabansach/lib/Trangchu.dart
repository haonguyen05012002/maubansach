import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'SachWidget.dart';
import 'Sach.dart';

class Trangchu extends StatefulWidget {
  const Trangchu({Key? key}) : super(key: key);

  @override
  _TrangchuState createState() => _TrangchuState();
}

class _TrangchuState extends State<Trangchu> {
  List<Sach> _sachs = [];

  @override
  void initState() {
    super.initState();
    _populateAllBooks();
  }

  Future<void> _populateAllBooks() async {
    try {
      final sach = await _fetchAllBooks();
      setState(() {
        _sachs = sach;
      });
    } catch (error) {
      // Handle error, e.g., show an error message
      print('Error loading books: $error');
    }
  }

  Future<List<Sach>> _fetchAllBooks() async {
    final response = await http.get(
      Uri.parse("http://localhost:3000/api/sach"),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      List<Sach> sachList = data.map((sachJson) => Sach.fromJson(sachJson)).toList();
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
        ),
        body: Container(
          child: _sachs.isNotEmpty
              ? SachWidgets(sachs: _sachs)
              : const Center(
            child: Text("No books found"),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.orange],
            ),
          ),
        ),
      ),
    );
  }
}