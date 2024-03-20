import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:muabansach/APIConstant.dart';
import 'package:muabansach/model/Nhaxuatban.dart';
import 'package:muabansach/view/SachDetailTC.dart';
import '../main.dart';
import '../model/Sach.dart';
import '../model/Theloai.dart';
import 'GiohangPage.dart';
import 'ProfileInfo.dart';
import 'Trangchu.dart';
import 'package:muabansach/APIConstant.dart';

class TrangChuWidget extends StatefulWidget {
  const TrangChuWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TrangChuWidget();
  }
}

class _TrangChuWidget extends State<TrangChuWidget> {
  List<Theloai> listtheloai = <Theloai>[];
  List<Sach> listsach = <Sach>[];
  List<Nhaxuatban> listnhaxuatban = <Nhaxuatban>[];
  String? selectvalue;

  @override
  void initState() {
    super.initState();
    _getTheLoai();
    _getLimitSach();
    _getNhaxuatban();
  }

  void _getTheLoai() async {
    final list = await getTitle();
    setState(() {
      listtheloai = list;
    });
  }

  void _getLimitSach() async {
    try {
      final list = await getSach();
      setState(() {
        listsach = list;
      });
    } catch (e) {
      // Handle error
      print("Error: $e");
    }
  }

  void _getNhaxuatban() async {
    try {
      final list = await getnhaxuatban();
      setState(() {
        listnhaxuatban = list;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("HOME"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Trangchu()),
                );
              },
              icon: Icon(Icons.search),
            ),
            SizedBox(width: 10),
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
        body: Container(
          height: MediaQuery.of(context).size.height * 1,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue, Colors.white],

              )),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 30,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: listtheloai.length,
                    itemBuilder: (context, index) {
                      final theloai = listtheloai[index];
                      return GestureDetector(
                        onTap: () {
                          // Action when user taps on a category
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            theloai.ten_theloai,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Text("Sách mới nhất"),
                SizedBox(height: 10),
                Container(
                  height: 200,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 200,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      viewportFraction: 0.4,
                      enlargeCenterPage: false,
                    ),
                    items: listsach.map((sach) {
                      return Builder(
                        builder: (BuildContext context) {
                          return GestureDetector(
                            onTap: () {
                              // Action when user taps on a book
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  '${APIConstants.ip}/images/${sach.hinh_bia}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                _buildCombobox(context),
                //_GDnhaxuatban(),
              ],
            ),
          ),
        ));
  }

  Widget _buildCombobox(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            child: ListView(
              shrinkWrap: true,
              children: [
                DropdownButton<String>(
                  value: selectvalue,
                  onChanged: (value) {
                    setState(() {
                      _GDnhaxuatban(value!);
                      selectvalue = value!;

                    });
                    // Call _GDnhaxuatban with selected value
                  },
                  items: listnhaxuatban
                      .asMap()
                      .entries
                      .map<DropdownMenuItem<String>>(
                        (entry) => DropdownMenuItem<String>(
                      value: '${entry.value.ten_nhaxuatban}_${entry.key}',
                      child: Text(entry.value.ten_nhaxuatban),
                    ),
                  )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _GDnhaxuatban(String id) {

    print('Selected ID: $id');
    final filteredBooks = listsach.where((sach) {
      // Convert sach.id_nhaxuatban to a string, split it, and get the part after the underscore
      String sachIdNhaxuatban = sach.id_nhaxuatban.toString().split('_')[0];

      return sachIdNhaxuatban == id;

    }).toList();
    print('Filtered Books: $filteredBooks');

    return Container(
      height: 200,
      child: CarouselSlider(
        options: CarouselOptions(

          height: 200,
          enableInfiniteScroll: true,
          autoPlay: false,
          viewportFraction: 0.4,
          enlargeCenterPage: true,
        ),
        items: filteredBooks.map((sach) {
          return Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () {
                  // Action when user taps on a book
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 3,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      '${APIConstants.ip}/images/${sach.hinh_bia}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }


  Future<List<Theloai>> getTitle() async {
    final response = await http.get(
      Uri.parse('${APIConstants.ip}/theloai'),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result;
      return list.map((theloai) => Theloai.fromJson(theloai)).toList();
    } else {
      throw Exception("lỗi rồi");
    }
  }

  Future<List<Sach>> getSach() async {
    final response = await http.get(
      Uri.parse('${APIConstants.ip}/limitsach'),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result;
      //print((list.map((sach) => Sach.fromJson(sach)).toList())[0].toString());
      return list.map((sach) => Sach.fromJson(sach)).toList();
    } else {
      throw Exception("lỗi rồi");
    }
  }

  Future<List<Nhaxuatban>> getnhaxuatban() async {
    final response = await http.get(
      Uri.parse('${APIConstants.ip}/nhaxuatban'),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result;

      return list.map((nhaxuatban) => Nhaxuatban.fromJson(nhaxuatban)).toList();
    } else {
      throw Exception("lỗi rồi");
    }
  }
}