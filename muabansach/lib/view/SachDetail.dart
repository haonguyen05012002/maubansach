import 'package:flutter/material.dart';
import '../model/Sach.dart';

class SachDetail extends StatelessWidget {
  final Sach sach;

  SachDetail({required this.sach});

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
                    sach.hinh_bia!,
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
              ],
            ),


          ),
        )

    );
  }
}