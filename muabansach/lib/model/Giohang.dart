import 'package:flutter/material.dart';

class Giohang extends StatefulWidget {
  const Giohang({Key? key}) : super(key: key);

  @override
  _GiohangState createState() => _GiohangState();
}

class _GiohangState extends State<Giohang> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ hàng'),
      ),
      body: ListView.builder(
        itemCount: 3, // Số lượng sản phẩm trong giỏ hàng
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/product_image.png'), // Ảnh sản phẩm
            ),
            title: Text('Tên sản phẩm $index'), // Tên sản phẩm
            subtitle: Text('Giá: \$20'), // Giá sản phẩm
            trailing: IconButton(
              icon: Icon(Icons.delete), // Icon xóa sản phẩm
              onPressed: () {
                // Xử lý khi nhấn nút xóa sản phẩm
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tổng cộng: \$60', // Tổng giá trị giỏ hàng
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
}
