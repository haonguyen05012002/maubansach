import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:muabansach/APIConstant.dart';
import 'package:muabansach/model/Sach.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
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
    _loadCartItems();
  }

  // Function to load cart items from SharedPreferences
  Future<void> _loadCartItems() async {
    Map<String, int>? cart = await _getCartItemsFromSharedPreferences();
    if (cart != null) {
      setState(() {
        _cartItems = cart;
      });
    }
  }

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
    return FutureBuilder<Map<String, int>>(
      future: _getCartItemsFromSharedPreferences(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // Extract cart items from snapshot
          Map<String, int>? cartItems = snapshot.data;
          if (cartItems != null && cartItems.isNotEmpty) {
            return ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                String sachId = cartItems.keys.elementAt(index);
                int quantity = cartItems.values.elementAt(index);
                return FutureBuilder<Sach?>(
                  future: fetchSach(int.parse(sachId)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
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
          ],
        ),
      ),
    );
  }


  Widget _buildQuantityAdjustmentButtons(Sach item, int sachid, int quantity) {
    return Container(
      width: 150,
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.remove, color: Colors.deepPurple),
            onPressed: () {
              _updateItemQuantity(sachid, quantity - 1);
              print(_cartItems.toString());
            },
          ),
          Text(
            '$quantity', // Display the quantity dynamically
            style: TextStyle(fontSize: 16, color: Colors.deepPurple),
          ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.deepPurple),
            onPressed: () {
              _updateItemQuantity(sachid, quantity + 1);
              print(_cartItems.toString());
            },
          ),
        ],
      ),
    );
  }

  Future<void> _updateItemQuantity(int sachid, int quantity) async {
    try {
      const String _cartKey = 'cart';
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Get the current cart items from shared preferences
      Map<String, int>? cartItems = await _getCartItemsFromSharedPreferences();

      // Update the quantity of the item in the cart
      if (cartItems != null && cartItems.containsKey(sachid.toString())) {
        // If the item exists in the cart, update its quantity
        cartItems[sachid.toString()] = quantity;

        // Convert the cart map back to a list of strings and save it to shared preferences
        List<String> cartList = cartItems.entries
            .map((entry) => '${entry.key}:${entry.value}')
            .toList();
        await prefs.setStringList(_cartKey, cartList);

        // Reload the cart items
        await _loadCartItems();
      }
    } catch (e) {
      print('Error updating item quantity: $e');
      // Handle error
    }
  }

  Future<Map<String, int>> _getCartItemsFromSharedPreferences() async {
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

      print('Retrieved Cart: $cart');

      return cart;
    } catch (e) {
      print('Error retrieving cart items: $e');
      // Handle error
      return {};
    }
  }

  double _calculateTotal(Map<String, int> cart) {
    double total = 0;
    for (String sachId in cart.keys) {
      Sach item = Sach.getTestSach();// edit
      int quantity = cart[sachId] ?? 0;
      total += item.gia * quantity;
    }
    return total;
  }

  Widget _buildCheckoutBar() {
    return FutureBuilder<Map<String, int>>(
      future: _getCartItemsFromSharedPreferences(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          Map<String, int>? cartItems = snapshot.data;
          double total = _calculateTotal(cartItems ?? {});
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
                      // // Navigate to CheckoutPage
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(builder: (context) => CheckoutPage()),
                      // );
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

  Future<Sach?> fetchSach(int id) async {
    print("ooooooooooooooooooooooooooooo");
    print(id.toString());
    try {
      final response = await http.get(Uri.parse('${APIConstants.ip}/getsach/$id'));
      if (response.statusCode == 200) {
        print("ooooooooooooooooooooooooooooo");
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

}
