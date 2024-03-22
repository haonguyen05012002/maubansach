import 'package:flutter/material.dart';
import '../APIConstant.dart';
import '../UserSingleton.dart';
import '../model/Sach.dart';
import 'package:http/http.dart' as http;

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
  Future<void> addToCart(String userId, String sachId) async {
    try {
      // Make a POST request to the server's endpoint to add the item to the cart
      final response = await http.post(
        '${APIConstants.ip}/api/giohang/' as Uri,
        body: {
          'id_nguoidung': userId,
          'id_sach': sachId,
          // Add any other parameters required by your server-side logic
        },
      );

      if (response.statusCode == 200) {
        // Item added to cart successfully, handle the response as needed
        print('Item added to cart successfully');
      } else {
        // Failed to add item to cart, handle the error
        print('Failed to add item to cart: ${response.reasonPhrase}');
      }
    } catch (error) {
      // An error occurred during the HTTP request, handle the error
      print('Error adding item to cart: $error');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(sach.tieu_de),
        ),
        body: Container(
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
                        color: Colors.grey.withOpacity(0.5), // Màu đổ bón
                        spreadRadius: 5, // Độ lan rộng của đổ bóng
                        blurRadius: 7, // Độ mờ của đổ bóng
                        offset: Offset(0, 3), // Vị trí của đổ bóng
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10), // Bo tròn các góc của khung hình chữ nhật
                  ),
                  child: Image.network(
                    '${APIConstants.ip}/images/${sach.hinh_bia}',
                    fit: BoxFit.cover, // Đảm bảo hình ảnh đổ đều trong kích thước của khung hình chữ nhật
                  ),
                ),
                SizedBox(height: 150),
                Text("Tựa đề: ${sach.tieu_de}", style: TextStyle(color: Colors.white, fontSize: 25), textAlign: TextAlign.left,),

                Text("Tác giả: ${sach.id_tacgia}", style: TextStyle(color: Colors.white, fontSize: 20),textAlign: TextAlign.left,),
                Text("Mô tả: ${sach.mo_ta}", style: TextStyle(color: Colors.white, fontSize: 20),textAlign: TextAlign.left,),

                Text("Nhà xuất bản: ${sach.id_nhaxuatban}", style: TextStyle(color: Colors.white, fontSize: 20),textAlign: TextAlign.left,),
                Text("Giá: ${sach.gia} VNĐ", style: TextStyle(color: Colors.white, fontSize: 20),textAlign: TextAlign.left,),
                // Thêm các thông tin khác của cocktail tại đây (nếu cần)
                ElevatedButton(
                  onPressed: () async {
                    // Gọi hàm thêm sản phẩm vào giỏ hàng
                    await addToCart(UserSingleton().getUserId()! as String, sach.id_sach! as String);
                    // Sau khi thêm vào giỏ hàng, gọi hàm fetchCartItems để lấy danh sách các mục trong giỏ hàng
                    fetchCartItems(UserSingleton().getUserId()! as String).then((cartItems) {
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
        )

    );
  }

}