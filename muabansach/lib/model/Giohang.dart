import 'package:flutter/material.dart';

import '../Sach.dart';

class Giohang extends StatefulWidget {
  final void Function(Sach) addToCart;

  const Giohang({Key? key, required this.addToCart}) : super(key: key);

  @override
  _GiohangState createState() => _GiohangState();
}

class _GiohangState extends State<Giohang> {
  List<Map<String, dynamic>> _cartItems = [];

  @override
  Widget build(BuildContext context) {
    int total = _cartItems.fold(
        0, (previousValue, item) => previousValue + (item["price"] * item["quantity"] as int));

    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ hàng'),
      ),
      body: _cartItems.isEmpty ? _buildEmptyCart() : _buildCartList(total),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tổng cộng: \$${total}', // Tổng giá trị giỏ hàng
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {
                  // Xử lý khi nhấn nút thanh toán
                },
                child: Text('Thanh toán'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Text("Giỏ hàng trống"),
    );
  }

  Widget _buildCartList(int total) {
    print(_cartItems.length);
    return ListView.builder(

      itemCount: _cartItems.length,
      itemBuilder: (context, index) {
        final item = _cartItems[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/product_image.png'),
          ),
          title: Text(item["name"]),
          subtitle: Text('Giá: \$${item["price"] * item["quantity"]}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    if (item["quantity"] > 1) {
                      item["quantity"]--;
                    } else {
                      _cartItems.removeAt(index);
                    }
                  });
                },
              ),
              Text('${item["quantity"]}'),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    item["quantity"]++;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void addToCart(Sach sach) {
    widget.addToCart(sach);
  }
}
