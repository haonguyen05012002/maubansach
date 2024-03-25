import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:muabansach/view/SachDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../APIConstant.dart';
import '../model/Sach.dart';
import '../UserSingleton.dart';

String ip = APIConstants.ip;

class SachWidgets extends StatelessWidget {
  final List<Sach> sachs;

  const SachWidgets({Key? key, required this.sachs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sachs.length,
      itemBuilder: (context, index) {
        final sach = sachs[index];

        return Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            onTap: () {
              // Hiển thị chi tiết sách khi người dùng nhấn vào
              print('Đang hiển thị chi tiết sách...');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SachDetail(sach: sach)),
              );
            },
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(
                        '${APIConstants.ip}/images/${sach.hinh_bia}',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sach.tieu_de ?? '',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Giá: ${sach.gia} VNĐ',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            // Gọi hàm thêm sản phẩm vào giỏ hàng
                            addToCart(sach.id_sach,
                                1); // Adding one quantity of the specific sach to the cart
                          },
                          child: Text('Thêm giỏ'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
}
