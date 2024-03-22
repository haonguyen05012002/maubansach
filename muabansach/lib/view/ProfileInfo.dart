import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:muabansach/main.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../APIConstant.dart';
import '../model/User.dart';
import '../UserSingleton.dart';
String ip =APIConstants.ip;
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User _user;
  bool _isLoading = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchUserById();
  }
  Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }
  Future<void> _fetchUserById() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Lấy userId từ SharedPreferences
      final userId = await UserSingleton().getUserId();
      if (userId != null) {
        final response = await http.get(
          Uri.parse('$ip/nguoidung/$userId'),
        );
        if (response.statusCode == 200) {
          final userData = jsonDecode(response.body);
          if (userData is List) {
            // Xử lý danh sách người dùng nếu cần thiết
            if (userData.isNotEmpty) {
              setState(() {
                _user = User.fromJson(userData[0]);
                _hasError = false;// xem coi có lỗi sảy ra hay không
              });
            } else {
              setState(() {
                _hasError = true;
              });
              print('Error: Empty user list');
            }
          } else if (userData is Map<String, dynamic>) {
            // Xử lý người dùng duy nhất
            setState(() {
              _user = User.fromJson(userData);
              _hasError = false;
            });
          } else {
            setState(() {
              _hasError = true;
            });
            print('Error: Invalid user data format');
          }
        } else {
          setState(() {
            _hasError = true;
          });
          print('Error loading user: ${response.statusCode}');
        }
      } else {
        setState(() {
          _hasError = true;
        });
        print('Error: UserId is null');
      }
    } catch (error) {
      setState(() {
        _hasError = true;
      });
      print('Error loading user: $error');
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
        title: Text('Profile'),
      ),
       body:
       Container(
         decoration: BoxDecoration(
             gradient: LinearGradient(
               begin: Alignment.topLeft,
               end: Alignment.bottomRight,
               colors: [Colors.blue, Colors.white],)),
         child: Center(


           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Container(
                 width: 150,
                 height: 200,
                 decoration: BoxDecoration(
                   color: Colors.white, // Màu nền của khung hình chữ nhật
                   boxShadow: [
                     BoxShadow(
                       color: Colors.grey.withOpacity(0.5), // Màu đổ bóng
                       spreadRadius: 5, // Độ lan rộng của đổ bóng
                       blurRadius: 7, // Độ mờ của đổ bóng
                       offset: Offset(0, 3), // Vị trí của đổ bóng
                     ),
                   ],
                   borderRadius: BorderRadius.circular(10), // Bo tròn các góc của khung hình chữ nhật
                 ),
                 // child: Image.network(
                 //  //,
                 // //  fit: BoxFit.cover, // Đảm bảo hình ảnh đổ đều trong kích thước của khung hình chữ nhật
                 // ),
               ),
               SizedBox(height: 150),
               Text("ID Người dùng: ${_user.idNguoiDung}", style: TextStyle(color: Colors.white, fontSize: 25), textAlign: TextAlign.left,),

               Text("Email: ${_user.email}", style: TextStyle(color: Colors.white, fontSize: 20),textAlign: TextAlign.left,),
               TextButton(
                 onPressed: ()
                 {
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>MyApp()));
               },
                 style: TextButton.styleFrom(
                   padding: const EdgeInsets.symmetric(
                       vertical: 20.0, horizontal: 15.0),
                   backgroundColor: Colors.lightBlue,
                 ), child: Text("Đăng xuất"),)

               // Thêm các thông tin khác của cocktail tại đây (nếu cần)
             ],
           ),


         ),
       )

    );
  }
}
