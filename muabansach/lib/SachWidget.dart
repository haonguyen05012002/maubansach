import 'package:flutter/material.dart';
import 'package:muabansach/SachDetail.dart';
import 'package:muabansach/model/Giohang.dart';
import 'Sach.dart';
import 'dart:convert';

class SachWidgets extends StatelessWidget {
  SachWidgets({Key? key, required this.sachs, required this.addToCart}) : super(key: key);

  final List<Sach> sachs;
  final Function(Sach) addToCart; // Hàm thêm sản phẩm vào giỏ hàng

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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SachDetail(sach: sach),
                ),
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
                            // Gọi hàm thêm sản phẩm vào giỏ hàng và truyền đối tượng sách tương ứng
                            addToCart(sach);
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


