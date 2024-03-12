import 'dart:convert';

import 'package:flutter/material.dart';
import 'Trangchu.dart';
import 'package:http/http.dart' as http;
import 'model/nguoidung.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


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
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
TextEditingController emaildn=TextEditingController();
TextEditingController matkhaudn=TextEditingController();
static String tag = 'login-page';

final Color backgroundColor1 = Color(0xFF4aa0d5);
final Color backgroundColor2 = Color(0xFF4aa0d5);
final Color highlightColor = Color(0xfff65aa3);
final Color foregroundColor = Colors.white;

Future<bool> checkLogin(String email, String password) async {
  try {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/nguoidung'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> usersJson = json.decode(response.body);

      // Chuyển đổi danh sách đối tượng json thành danh sách đối tượng NguoiDung
      List<NguoiDung> users =
      usersJson.map((json) => NguoiDung.fromJson(json)).toList();

      // Kiểm tra đăng nhập với thông tin nhập từ người dùng
      bool isLoggedIn = users.any((user) =>
      user.email == email && user.mat_khau == password);

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
            begin: Alignment.centerLeft,
            end: Alignment(1.0, 0.0),
            colors: [backgroundColor1, backgroundColor2],
            tileMode: TileMode.repeated,
          ),
        ),
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 100.0, bottom: 10.0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 100.0,
                      width: 100.0,
                      child: Hero(
                        tag: 'hero',
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 48.0,
                          //child: Image.asset('assets/lock.png'),
                        ),
                      ),
                    ),
                  ],
                ),
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
                    padding: EdgeInsets.only(top: 20.0, bottom: 10.0, right: 0.0),
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
                        hintText: ' Your email',
                        hintStyle: TextStyle(color: foregroundColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
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
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 0.0),
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
                        hintText: ' Your password',
                        hintStyle: TextStyle(color: foregroundColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                        backgroundColor: Colors.lightBlue,
                      ),
                      onPressed: () async {
                        // Kiểm tra đăng nhập khi người dùng nhấn nút "Sign In"
                        bool result = await checkLogin(emaildn.text, matkhaudn.text);

                        // Nếu đăng nhập thành công, chuyển đến trang chủ
                        if (result) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Trangchu()),
                          );
                        } else {
                          // Hiển thị thông báo lỗi khi đăng nhập thất bại
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text( "tài khoản hoặc mật khẩu sai. vui lòng thử lại"),
                            ),
                          );
                        }
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(color: foregroundColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                      ),
                      onPressed: () => {},
                      child: Text(
                        "Forgot your password?",
                        style: TextStyle(color: foregroundColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                      ),
                      onPressed: () => {},
                      child: Text(
                        "Don't have an account? Sign Up",
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


