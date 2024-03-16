import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:muabansach/SachDetail.dart';
import 'dart:async';
import 'dart:convert';
import 'Sach.dart';
import 'UserSingleton.dart';

class SachWidgets extends StatelessWidget {
  final List<Sach> sachs;

  const SachWidgets({Key? key, required this.sachs}) : super(key: key);

  Future<void> addToCart(int userId, int sachId) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/giohang'),
        body: {
          'id_nguoidung': userId.toString(),
          'id_sach': sachId.toString(),
        },
      );

      if (response.statusCode == 200) {
        // Đã thêm sản phẩm vào giỏ hàng thành công
        print('Sản phẩm đã được thêm vào giỏ hàng.');
      } else {
        // Xử lý lỗi từ phía server
        print('Lỗi khi thêm sản phẩm vào giỏ hàng: ${response.statusCode}');
      }
    } catch (e) {
      // Xử lý lỗi nếu có lỗi kết nối hoặc lỗi khác
      print('Error: $e');
    }
  }

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
                      image: NetworkImage(sach.hinh_bia!),
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
                            addToCart(UserSingleton().getUserId()!, sach.id_sach);
                          },
                          child: Text('Mua'),
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
}
