import 'dart:convert';

import 'package:flutter/material.dart';
import '../APIConstant.dart';
import '../UserSingleton.dart';
import '../model/Sach.dart';
import 'package:http/http.dart' as http;

import 'GiohangPage.dart';
import 'ProfileInfo.dart';
import 'Trangchu.dart';

class SachDetail extends StatelessWidget {
  final Sach sach;

  SachDetail({required this.sach});

  Future<String> fetchCartItems(String userId) async {
    final response = await http.get(
      '${APIConstants.ip}/cart/$userId' as Uri,
    );
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON response
      return response.body;
    } else {
      // If the server returns an error response, throw an exception
      throw Exception('Failed to load cart items');
    }
  }

  Future<void> addToCart(int bookId, int quantityToAdd) async {
    try {
      // Gửi yêu cầu GET để kiểm tra xem mục đã tồn tại trong giỏ hàng chưa
      var response = await http.get(
        Uri.parse('${APIConstants.ip}/giohang'),
      );

      if (response.statusCode == 200) {
        // Nếu request thành công, tiếp tục xử lý dữ liệu
        var jsonData = jsonDecode(response.body);

        // Lặp qua từng phần tử trong danh sách giỏ hàng
        for (var cartItem in jsonData) {
          // Kiểm tra nếu id_nguoidung và id_sach trùng với tham số truyền vào
          if (cartItem['id_nguoidung'] == UserSingleton().getUserId() &&
              cartItem['id_sach'] == bookId) {
            // Nếu trùng, thực hiện cập nhật số lượng
            int currentQuantity = cartItem['soluong'];
            int newQuantity = currentQuantity + quantityToAdd;
            // Gửi yêu cầu PUT để cập nhật số lượng
            var updateResponse = await http.put(
              Uri.parse('${APIConstants.ip}/giohang_sl/${cartItem['id']}'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, dynamic>{
                'soluong': newQuantity,
              }),
            );
            if (updateResponse.statusCode == 200) {
              print('Quantity updated successfully');
            } else {
              print('Failed to update quantity: ${updateResponse.statusCode}');
            }
            // Kết thúc hàm nếu đã tìm thấy và cập nhật số lượng
            return;
          }
        }
      } else {
        print('Failed to check if item exists in cart: ${response.statusCode}');
      }

      // Nếu mục chưa tồn tại trong giỏ hàng, thêm mới
      var insertResponse = await http.post(
        Uri.parse('${APIConstants.ip}/giohangInsert'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id_sach': bookId,
          'id_nguoidung': UserSingleton().getUserId(),
          'soluong': quantityToAdd,
        }),
      );

      if (insertResponse.statusCode == 200) {
        print('Item added to cart successfully');
      } else {
        print('Failed to add item to cart: ${insertResponse.statusCode}');
      }
    } catch (e) {
      print('Error adding to cart: $e');
      // Xử lý bất kỳ lỗi nào
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
        body: SingleChildScrollView(
            child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.white],
          )),
              height: MediaQuery.of(context).size.height,
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
                        color: Colors.grey.withOpacity(0.5), // Màu đổ bón
                        spreadRadius: 5, // Độ lan rộng của đổ bóng
                        blurRadius: 7, // Độ mờ của đổ bóng
                        offset: Offset(0, 3), // Vị trí của đổ bóng
                      ),
                    ],
                    borderRadius: BorderRadius.circular(
                        10), // Bo tròn các góc của khung hình chữ nhật
                  ),
                  child: Image.network(
                    '${APIConstants.ip}/images/${sach.hinh_bia}',
                    fit: BoxFit
                        .cover, // Đảm bảo hình ảnh đổ đều trong kích thước của khung hình chữ nhật
                  ),
                ),
                SizedBox(height: 150),
                Text(
                  "Tựa đề: ${sach.tieu_de}",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                  textAlign: TextAlign.left,
                ),

                Text(
                  "Tác giả: ${sach.id_tacgia}",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  textAlign: TextAlign.left,
                ),
                Text(
                  "Mô tả: ${sach.mo_ta}",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  textAlign: TextAlign.left,
                ),

                Text(
                  "Nhà xuất bản: ${sach.id_nhaxuatban}",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  textAlign: TextAlign.left,
                ),
                Text(
                  "Giá: ${sach.gia} VNĐ",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  textAlign: TextAlign.left,
                ),
                // Thêm các thông tin khác của cocktail tại đây (nếu cần)
                ElevatedButton(
                  onPressed: () async {
                    // Gọi hàm thêm sản phẩm vào giỏ hàng
                    await addToCart(sach.id_sach, 1);
                    // Sau khi thêm vào giỏ hàng, gọi hàm fetchCartItems để lấy danh sách các mục trong giỏ hàng
                    fetchCartItems(UserSingleton().getUserId()! as String)
                        .then((cartItems) {
                      // Xử lý phản hồi từ máy chủ, cập nhật giao diện người dùng, hiển thị thông báo, vv
                      print('Cart items: $cartItems');
                    }).catchError((error) {
                      // Xử lý các lỗi, hiển thị thông báo lỗi cho người dùng
                      print('Error: $error');
                    });
                  },
                  child: Text('Thêm giỏ'),
                ),
              ],
            ),
          ),
        )));
  }
}
