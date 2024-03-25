import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:muabansach/APIConstant.dart';
import 'package:muabansach/UserSingleton.dart';
import 'package:muabansach/model/Sach.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'ThanhToanPage.dart';
class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Define a variable to store the cart items
  Map<String, int> _cartItems = {};

  @override
  void initState() {
    super.initState();
    // Load cart items when the page initializes
    // _loadCartItems();
  }

  // Function to load cart items from SharedPreferences
  // Future<void> _loadCartItems() async {
  //   Map<String, int>? cart = await _getCartItemsFromSharedPreferences();
  //   if (cart != null) {
  //     setState(() {
  //       _cartItems = cart;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: _buildCartList(),
      bottomNavigationBar: _buildCheckoutBar(),
    );
  }

  Widget _buildCartList() {
    return FutureBuilder<List<dynamic>>(
      future: fetchCartItemsFromAPI(), // Gọi API để lấy danh sách các mặt hàng trong giỏ hàng
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<dynamic> cartItems = snapshot.data!;
          if (cartItems.isNotEmpty) {
            return ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> cartItem = cartItems[index];
                String sachId = cartItem['id_sach'].toString();
                int quantity = int.parse(cartItem['soluong'].toString());
                return FutureBuilder<Sach?>(
                  future: fetchSach(int.parse(sachId)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error loading Sach');
                    } else {
                      Sach? item = snapshot.data;
                      if (item != null) {
                        return _buildCartItem(item, int.parse(sachId), quantity);
                      } else {
                        return Text('Sach not found');
                      }
                    }
                  },
                );
              },
            );
          } else {
            return Center(child: Text('No items in cart'));
          }
        }
      },
    );
  }


  Future<List<dynamic>> fetchCartItemsFromAPI() async {
    final response = await http.get(Uri.parse('${APIConstants.ip}/giohang'));

    if (response.statusCode == 200) {
      // Nếu request thành công, parse JSON response
      List<dynamic> cartItems = jsonDecode(response.body);

      // Lọc các mục trong giỏ hàng để chỉ lấy những mục của người dùng hiện tại
      List<dynamic> userCartItems = cartItems.where((item) => item['id_nguoidung'] == UserSingleton().getUserId()).toList();

      return userCartItems;
    } else {
      // Nếu request thất bại, throw error
      throw Exception('Failed to load cart items');
    }
  }



  Widget _buildCartItem(Sach item, int sachid, int soluong) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.purple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    '${APIConstants.ip}/images/${item.hinh_bia ?? ''}',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(width: 10), // Add some spacing between avatar and text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.tieu_de,

                    style: TextStyle(color: Colors.deepPurple, fontSize: 16),
                    maxLines: 2, // Limit title to 2 lines
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Giá: ${item.gia}',
                    style: TextStyle(color: Colors.red),
                  ),
                  Text(
                    'Số lượng: $soluong',
                    style: TextStyle(color: Colors.deepPurpleAccent),
                  ),
                ],
              ),
            ),
            _buildQuantityAdjustmentButtons(item, sachid, soluong),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _removeItemFromCart(UserSingleton().getUserId()!, sachid).then((success) {
                  if (success) {
                    setState(() {
                      _cartItems.remove(sachid.toString()); // Xóa mặt hàng khỏi danh sách cartItems
                    });
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _removeItemFromCart(int userId, int bookId) async {
    try {
      // Gửi yêu cầu GET để kiểm tra xem mục đã tồn tại trong giỏ hàng chưa
      var response = await http.get(
        Uri.parse('${APIConstants.ip}/giohang'),
      );

      if (response.statusCode == 200) {
        // Nếu request thành công, tiếp tục xử lý dữ liệu
        var jsonData = jsonDecode(response.body);

        // Lọc danh sách các mục trong giỏ hàng của người dùng hiện tại
        var userCartItems = jsonData.where((item) => item['id_nguoidung'] == userId).toList();

        // Tìm id của mục trong giỏ hàng có id_sach là bookId
        var cartItem = userCartItems.firstWhere((item) => item['id_sach'] == bookId, orElse: () => null);

        if (cartItem != null) {
          // Nếu tìm thấy mục trong giỏ hàng, lấy id của giỏ hàng tương ứng
          var cartId = cartItem['id'];

          // Gửi yêu cầu DELETE để xóa mặt hàng khỏi giỏ hàng
          var deleteResponse = await http.delete(
            Uri.parse('${APIConstants.ip}/giohang/$cartId'),
          );

          if (deleteResponse.statusCode == 200) {
            print('Item removed from cart successfully');
            return true; // Trả về true nếu xóa thành công
          } else {
            print('Failed to remove item from cart: ${deleteResponse.statusCode}');
            return false; // Trả về false nếu xóa thất bại
          }
        } else {
          print('Item not found in cart');
          return false; // Trả về false nếu mặt hàng không tồn tại trong giỏ hàng
        }
      } else {
        print('Failed to fetch cart items: ${response.statusCode}');
        return false; // Trả về false nếu không thể lấy danh sách giỏ hàng
      }
    } catch (e) {
      print('Error removing item from cart: $e');
      return false; // Trả về false nếu có lỗi xảy ra
    }}


  Widget _buildQuantityAdjustmentButtons(Sach item, int sachid, int soluong) {
    return Container(
      width: 150,
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.remove, color: Colors.deepPurple),
            onPressed: () {

                // Giảm số lượng chỉ khi soluong > 1
                _updateItemQuantity(UserSingleton().getUserId()!, sachid, soluong - 1).then((success) {
                  if (success) {
                    setState(() {
                      soluong--; // Cập nhật giá trị soluong
                    });
                  }
                });

            },
          ),
          Text(
            '$soluong', // Display the quantity dynamically
            style: TextStyle(fontSize: 16, color: Colors.deepPurple),
          ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.deepPurple),
            onPressed: () {
              _updateItemQuantity(UserSingleton().getUserId()!, sachid, soluong + 1).then((success) {
                if (success) {
                  setState(() {
                    soluong++; // Cập nhật giá trị soluong
                  });
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Future<bool> _updateItemQuantity(int userId, int bookId, int newQuantity) async {
    try {
      // Gửi yêu cầu GET để kiểm tra xem mục đã tồn tại trong giỏ hàng chưa
      var response = await http.get(
        Uri.parse('${APIConstants.ip}/giohang'),
      );

      if (response.statusCode == 200) {
        // Nếu request thành công, tiếp tục xử lý dữ liệu
        var jsonData = jsonDecode(response.body);

        // Lọc danh sách các mục trong giỏ hàng của người dùng hiện tại
        var userCartItems = jsonData.where((item) => item['id_nguoidung'] == userId).toList();

        // Tìm id của mục trong giỏ hàng có id_sach là bookId
        var cartItem = userCartItems.firstWhere((item) => item['id_sach'] == bookId, orElse: () => null);

        if (cartItem != null) {
          // Nếu tìm thấy mục trong giỏ hàng, lấy id của giỏ hàng tương ứng
          var cartId = cartItem['id'];

          if (newQuantity <= 0) {
            // Nếu số lượng mới <= 0, gửi yêu cầu DELETE để xóa mặt hàng khỏi giỏ hàng
            var deleteResponse = await http.delete(
              Uri.parse('${APIConstants.ip}/giohang/$cartId'),
            );

            if (deleteResponse.statusCode == 200) {
              print('Item removed from cart successfully');
              return true; // Trả về true nếu xóa thành công
            } else {
              print('Failed to remove item from cart: ${deleteResponse.statusCode}');
              return false; // Trả về false nếu xóa thất bại
            }
          } else {
            // Nếu số lượng mới > 0, gửi yêu cầu PUT để cập nhật số lượng của mặt hàng trong giỏ hàng
            var updateResponse = await http.put(
              Uri.parse('${APIConstants.ip}/giohang_sl/$cartId'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, dynamic>{
                'soluong': newQuantity,
              }),
            );

            if (updateResponse.statusCode == 200) {
              print('Quantity updated successfully');
              return true; // Trả về true nếu cập nhật thành công
            } else {
              print('Failed to update quantity: ${updateResponse.statusCode}');
              return false; // Trả về false nếu cập nhật thất bại
            }
          }
        } else {
          print('Item not found in cart');
          return false; // Trả về false nếu mặt hàng không tồn tại trong giỏ hàng
        }
      } else {
        print('Failed to fetch cart items: ${response.statusCode}');
        return false; // Trả về false nếu không thể lấy danh sách giỏ hàng
      }
    } catch (e) {
      print('Error updating quantity: $e');
      return false; // Trả về false nếu có lỗi xảy ra
    }
  }


  // Future<Map<String, int>> _getCartItemsFromSharedPreferences() async {
  //   try {
  //     const String _cartKey = 'cart';
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //     // Get the current cart items from shared preferences
  //     List<String>? cartItems = prefs.getStringList(_cartKey);
  //     Map<String, int> cart = {};
  //
  //     // Convert the list of strings to a map
  //     if (cartItems != null) {
  //       cartItems.forEach((item) {
  //         List<String> parts = item.split(':');
  //         cart[parts[0]] = int.parse(parts[1]);
  //       });
  //     }
  //
  //     print('Retrieved Cart: $cart');
  //
  //     return cart;
  //   } catch (e) {
  //     print('Error retrieving cart items: $e');
  //     // Handle error
  //     return {};
  //   }
  // }

  Future<double> _calculateTotal() async {
    try {
      final cartItems = await fetchCartItemsFromAPI();
      double total = 0;

      // Duyệt qua từng sản phẩm trong giỏ hàng
      for (var cartItem in cartItems) {
        // Lấy thông tin của sách từ API
        final sachId = cartItem['id_sach'];
        final sach = await fetchSach(int.parse(sachId.toString()));

        // Tính tổng giá sản phẩm nhân với số lượng
        if (sach != null) {
          int quantity = int.parse(cartItem['soluong'].toString());
          total += sach.gia * quantity;
        }
      }
      return total;
    } catch (e) {
      print('Error calculating total: $e');
      return 0;
    }
  }


  Widget _buildCheckoutBar() {
    return FutureBuilder<double>(
      future: _calculateTotal(),
      builder: (context, snapshot)  {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          double total = snapshot.data ?? 0;
          return BottomAppBar(
            color: Colors.deepPurple,
            child: Container(
              height: 55,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Tổng: ${total.toStringAsFixed(0)} VNĐ',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ThanhtoanPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purpleAccent,
                    ),
                    child: Text('Thanh toán'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

}

  Future<Sach?> fetchSach(int id) async {
    print("oooo");
    print(id.toString());
    try {
      final response = await http.get(Uri.parse('${APIConstants.ip}/getsach/$id'));
      if (response.statusCode == 200) {
        print("o");
        print(jsonDecode(response.body).toString());
        return Sach.fromJson(jsonDecode(response.body));
      } else {
        // Nếu yêu cầu thất bại, in thông báo lỗi và trả về null
        print('Failed to load Sach: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Handle exception and return null
      print('Error loading Sach: $e');
      return null;
    }
  }


