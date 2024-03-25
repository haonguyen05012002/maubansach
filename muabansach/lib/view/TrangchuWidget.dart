import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:muabansach/APIConstant.dart';
import 'package:muabansach/model/Nhaxuatban.dart';
import 'package:muabansach/view/SachDetail.dart';
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
  Nhaxuatban? selectedNhaxuatban;
  List<Sach> sachList = [];
  Theloai? selectedTheloai;
  List<Sach> sachListTL = [];

  @override
  void initState() {
    _getSachNXBnull();
    _getSachTLnull();
    _getTheLoai();
    _getLimitSach();
    _getNhaxuatban();
    _getsachbynhaxuatban();
    _getsachbytheloai();
    if (listnhaxuatban.isNotEmpty) {
      selectedNhaxuatban = listnhaxuatban.first;
    }
    if (listtheloai.isNotEmpty) {
      selectedTheloai = listtheloai.first;
    }
    super.initState();
  }

  void _getSachNXBnull() async {
    sachList = await getSachByNhaxuatban(1.toString());
    setState(() {});
  }
  void _getSachTLnull() async {
    sachListTL = await getSachByTheloai(18.toString());
    setState(() {});
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
  void _getsachbynhaxuatban() async {
    try {
      final list = await getSachByNhaxuatban(selectvalue!);
      setState(() {
        listsach = list;
      });
    } catch (e) {
      print("Error: $e");
    }
  }
  void _getsachbytheloai() async{
    try{
      final list = await getSachByTheloai(selectvalue!);
      setState(() {
        listsach=list;
      });
    }catch(e){
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
                  MaterialPageRoute(builder: (context) => CartPage()),
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
              icon: Icon(Icons.person),
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
                SizedBox(
                  height: 10,
                ),
                _buildLimitSach5(),
                SizedBox(
                  height: 10,
                ),
                _buildComboboxNXB(),

                _GDnhaxuatban(),
                SizedBox(
                  height: 10,
                ),
                _buildComboboxTL(),

                _GDTheloai(),
                SizedBox(
                  height: 20,
                ),
                _buildBottomNavigationBar()
              ],
            ),
          ),
        ));
  }


  Widget _buildLimitSach5(){
    return Container(
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SachDetail(sach: sach)),
                  );
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
  Widget _buildComboboxNXB() {
    if (selectedNhaxuatban == null && listnhaxuatban.isNotEmpty) {
      selectedNhaxuatban = listnhaxuatban[0];
    }

    return DropdownButton<Nhaxuatban>(
      value: selectedNhaxuatban,
      onChanged: (Nhaxuatban? value) async {
        setState(() {
          selectedNhaxuatban = value;
        });
        print('Selected value: ${value?.toString()}');
        if (value != null) {
          try {
            sachList =
            await getSachByNhaxuatban(value.id_nhaxuatban.toString());
            setState(() {});
          } catch (e) {
            print('Error fetching sach: $e');
          }
        }
      },
      items: listnhaxuatban.map((nhaxuatban) {
        return DropdownMenuItem<Nhaxuatban>(
          value: nhaxuatban,
          child: Text(nhaxuatban.ten_nhaxuatban),
        );
      }).toList(),
    );
  }
  Widget _GDnhaxuatban() {
    print(sachList.toString());
    if (sachList.isEmpty) {
      // Placeholder widget when listsach is empty
      return Center(
        child: Text(
          'No books available',
          style: TextStyle(fontSize: 18),
        ),
      );
    } else {
      // Carousel of listsach
      return Container(
        height: 180,
        child: CarouselSlider(
          options: CarouselOptions(
            height: 180,
            enableInfiniteScroll: false,
            autoPlay: false,
            viewportFraction: 0.4,
            enlargeCenterPage: true,
          ),
          items: sachList.map((sach) {
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SachDetail(sach: sach)),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 4,
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
  }

  Widget _buildComboboxTL() {
    // Set the initial value to the first Nhaxuatban when the widget is initialized
    if (selectedTheloai == null && listtheloai.isNotEmpty) {
      selectedTheloai = listtheloai[0];
    }

    return DropdownButton<Theloai>(
      value: selectedTheloai,
      onChanged: (Theloai? value) async {
        setState(() {
          selectedTheloai = value;
        });
        print('Selected value: ${value?.toString()}');
        if (value != null) {
          try {
            sachListTL =
            await getSachByTheloai(value.id_theloai.toString());
            setState(() {});
          } catch (e) {
            print('Error fetching sach: $e');
          }
        }
      },
      items: listtheloai.map((theloai) {
        return DropdownMenuItem<Theloai>(
          value: theloai,
          child: Text(theloai.ten_theloai),
        );
      }).toList(),
    );
  }
  Widget _GDTheloai() {
    print(sachList.toString());
    if (sachList.isEmpty) {
      // Placeholder widget when listsach is empty
      return Center(
        child: Text(
          'No books available',
          style: TextStyle(fontSize: 18),
        ),
      );
    } else {
      // Carousel of listsach
      return Container(
        height: 180,
        child: CarouselSlider(
          options: CarouselOptions(
            height: 180,
            enableInfiniteScroll: false,
            autoPlay: false,
            viewportFraction: 0.4,
            enlargeCenterPage: true,
          ),
          items: sachListTL.map((sach) {
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SachDetail(sach: sach)),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 4,
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
  }
  Widget _buildBottomNavigationBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white, // Màu nền của BottomNavigationBar
      child: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        onTap: (int index) {
          // index là chỉ số của mục được nhấn
          // Thực hiện hành động tương ứng với mục được nhấn
          switch (index) {
            case 0:
              print('Home icon tapped');
              // Thêm hành động cho Home icon ở đây
              break;
            case 1:
              print('Library icon tapped');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Trangchu()),
              );
              break;
              // Thêm hành động cho Library icon ở đây
              break;
            case 2:
              print('Profile icon tapped');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
              break;
          }
        },
      ),
    );
  }


  Future<void> _getNhaxuatban() async {
    try {
      final response =
      await http.get(Uri.parse('${APIConstants.ip}/nhaxuatban'));

      print(response.toString());
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        Iterable list = result;
        setState(() {
          listnhaxuatban = list
              .map((nhaxuatban) => Nhaxuatban.fromJson(nhaxuatban))
              .toList();
        });
      } else {
        throw Exception("Lỗi khi lấy danh sách nhà xuất bản từ API");
      }
    } catch (e) {
      print("Error: $e");
    }
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
      throw Exception("lỗi rồi:getSach");
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
      throw Exception("lỗi rồi:getnhaxuatban");
    }
  }
  Future<List<Sach>> getSachByNhaxuatban(String idNhaxuatban) async {
    final response =
    await http.get(Uri.parse('${APIConstants.ip}/nxbsach/$idNhaxuatban'));
    print(response.body);
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result;
      return list.map((sach) => Sach.fromJson(sach)).toList();
    } else {
      throw Exception("lỗi rồi:getSachByNhaxuatban");
    }
  }
  Future<List<Sach>> getSachByTheloai(String idTheloai) async {
    final response = await http.get(
        Uri.parse('${APIConstants.ip}/sach/$idTheloai'));
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result;
      return list.map((sach) => Sach.fromJson(sach)).toList();
    } else {
      throw Exception("lỗi rồi:getSachByTheloai");

    }
  }
}
