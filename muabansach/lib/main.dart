import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:muabansach/UserSingleton.dart';
import 'package:muabansach/view/TrangchuWidget.dart';
import 'APIConstant.dart';
import 'view/Dangki.dart';
import 'view/Trangchu.dart';
import 'package:http/http.dart' as http;
import 'model/nguoidung.dart';

String ip = APIConstants.ip;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Book',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Smart Book'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController emaildn = TextEditingController();
  TextEditingController matkhaudn = TextEditingController();

  final Color backgroundColor1 = Color(0xFF4aa0d5);
  final Color backgroundColor2 = Color(0xFF4aa0d5);
  final Color foregroundColor = Colors.white;

  Future<void> saveUserId(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('userId', userId);
  }

  Future<bool> checkLogin(String email, String password) async {
    try {
      final response = await http.get(
        Uri.parse('$ip/nguoidung'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> usersJson = json.decode(response.body);

        // Chuyển đổi danh sách đối tượng json thành danh sách đối tượng NguoiDung
        List<NguoiDung> users =
            usersJson.map((json) => NguoiDung.fromJson(json)).toList();

        // Kiểm tra đăng nhập với thông tin nhập từ người dùng
        bool isLoggedIn = users
            .any((user) => user.email == email && user.mat_khau == password);

        return isLoggedIn;
      } else {
        // Xử lý lỗi nếu không thể kết nối được với API
        return false;
      }
    } catch (e) {
      // Xử lý lỗi nếu có bất kỳ lỗi nào khác xảy ra
      print('Error: $e');
      return false;
    }
  }

  Future<int?> findUserIdByEmail(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$ip/nguoidung'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> usersJson = json.decode(response.body);

        // Chuyển đổi danh sách đối tượng json thành danh sách đối tượng NguoiDung
        List<NguoiDung> users =
            usersJson.map((json) => NguoiDung.fromJson(json)).toList();

        // Tìm id của người dùng dựa trên email
        int? userId;
        users.forEach((user) {
          if (user.email == email) {
            userId = user.id_nguoidung as int?;
          }
        });
        return userId;
      } else {
        // Xử lý lỗi nếu không thể kết nối được với API
        return null;
      }
    } catch (e) {
      // Xử lý lỗi nếu có bất kỳ lỗi nào khác xảy ra
      print('Error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Smart Book"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.white],
          ),
        ),
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 40),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[

            Container(
              width: MediaQuery.of(context).size.width,
              margin:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "ĐĂNG NHẬP",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 40.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: foregroundColor,
                    width: 0.5,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              padding: const EdgeInsets.only(left: 0.0, right: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, bottom: 10.0, right: 0.0),
                    child: Icon(
                      Icons.email,
                      color: foregroundColor,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: emaildn,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: ' Nhập email của bạn',
                        hintStyle: TextStyle(color: foregroundColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: foregroundColor,
                    width: 0.5,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              padding: const EdgeInsets.only(left: 0.0, right: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 10.0, right: 0.0),
                    child: Icon(
                      Icons.lock_open,
                      color: foregroundColor,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: matkhaudn,
                      obscureText: true,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: ' Mật khẩu',
                        hintStyle: TextStyle(color: foregroundColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 15.0),
                        backgroundColor: Colors.lightBlue,
                      ),
                      onPressed: () async {
                        bool result =
                            await checkLogin(emaildn.text, matkhaudn.text);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => TrangChuWidget()),
                        //);

                        // Nếu đăng nhập thành công, chuyển đến trang chủ
                        if (result) {
                          int? userID = await findUserIdByEmail(emaildn.text);
                          UserSingleton().setUserId(userID!);
                          saveUserId(userID);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TrangChuWidget()),
                          );
                        } else {
                          // Hiển thị thông báo lỗi khi đăng nhập thất bại
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Tài khoản hoặc mật khẩu bị sai. Vui lòng thử lại!"),
                            ),
                          );
                        }
                      },
                      child: Text(
                        "Đăng nhập",
                        style: TextStyle(color: foregroundColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 20.0),
                      ),
                      onPressed: () => {},
                      child: Text(
                        "Quên mật khẩu?",
                        style: TextStyle(color: foregroundColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                      ),
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Dangki()),
                        )
                      },
                      child: Text(
                        "Chưa có tài khoản? Đăng Ký!",
                        style: TextStyle(color: foregroundColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
