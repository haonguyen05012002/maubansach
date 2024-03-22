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
      const String _cartKey = 'cart';
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Get the current cart items from shared preferences
      List<String>? cartItems = prefs.getStringList(_cartKey);
      Map<String, int> cart = {};

      // Convert the list of strings to a map
      if (cartItems != null) {
        cartItems.forEach((item) {
          List<String> parts = item.split(':');
          cart[parts[0]] = int.parse(parts[1]);
        });
      }

      // Check if the book already exists in the cart
      if (cart.containsKey(bookId.toString())) {
        // If the book already exists in the cart, increment its quantity
        cart[bookId.toString()] = cart[bookId.toString()]! + quantityToAdd;
      } else {
        // If the book doesn't exist in the cart, add it with the specified quantity
        cart[bookId.toString()] = quantityToAdd;
      }

      // Convert the cart map back to a list of strings and save it to shared preferences
      List<String> cartList =
          cart.entries.map((entry) => '${entry.key}:${entry.value}').toList();
      await prefs.setStringList(_cartKey, cartList);

      // Print the updated cart
      print('Updated Cart: $cart');
    } catch (e) {
      print('Error adding to cart: $e');
      // Handle error
    }
  }
}
