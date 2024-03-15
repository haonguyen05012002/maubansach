import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:muabansach/Trangchu.dart';
import 'Dangki.dart';
import 'main.dart';
import 'model/nguoidung.dart';

Future<bool> signup(String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/addnguoidung'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'mat_khau': password}),
    );

    if (response.statusCode == 200) {
      // Đăng ký thành công
      return true;
    } else {
      // Xử lý lỗi khi đăng ký không thành công
      final responseBody = json.decode(response.body);

      if (responseBody.containsKey('error')) {
        // Lỗi từ phía server, hiển thị thông báo lỗi
        print('Server error: ${responseBody['error']}');
      } else {
        // Lỗi không xác định, hiển thị thông báo mặc định
        print('Unknown error occurred');
      }

      return false;
    }
  } catch (e) {
    // Xử lý lỗi nếu có bất kỳ lỗi nào khác xảy ra
    print('Error: $e');
    return false;
  }
}
Future<bool> checkTK(String email, ) async {
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
      user.email == email );

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



class Dangki extends StatefulWidget {
  const Dangki({Key? key}) : super(key: key);

  @override
  _DangkiState createState() => _DangkiState();
}

class _DangkiState extends State<Dangki> {
  TextEditingController emaildk = TextEditingController();
  TextEditingController matkhaudk = TextEditingController();
  TextEditingController confirmmatkhaudk = TextEditingController();
  static String tag = 'Signup-page';

  final Color backgroundColor1 = Color(0xFF4aa0d5);
  final Color backgroundColor2 = Color(0xFF4aa0d5);
  final Color foregroundColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text("Sign Up"),
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
                      controller: emaildk,
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
                      controller: matkhaudk,
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
                      controller: confirmmatkhaudk,
                      obscureText: true,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: ' Confirm password',
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
                    child: ElevatedButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                        backgroundColor: Colors.lightBlue,
                      ),

                      onPressed: () async {
                        bool result1 = await checkTK(emaildk.text);
                        if (result1) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(emaildk.text +
                                    " đã được đăng ki. vui lòng chọn email khác !"),
                              )
                          );
                        } else {
                          if (matkhaudk.text == confirmmatkhaudk.text) {
                            // Kiểm tra đăng ký khi người dùng nhấn nút "Sign Up"
                            bool result = await signup(
                                emaildk.text, matkhaudk.text);

                            // Nếu đăng ký thành công, chuyển đến trang chủ
                            if (result) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyApp()),
                              );
                            } else {
                              // Hiển thị thông báo lỗi khi đăng ký thất bại
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Đăng kí thất bại . vui lòng thử lại $result" +
                                          emaildk.text + matkhaudk.text),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Mật khẩu nhập lại không trùng"),
                                )
                            );
                          }
                        }

                      },
                      child: Text(
                        "Sign Up",
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
                        "Đã có tài khoảng? Sign In",
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
