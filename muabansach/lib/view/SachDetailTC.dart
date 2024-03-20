import 'package:flutter/material.dart';
import '../model/Sach.dart';

class SachDetailTC extends StatelessWidget {
  final Sach sach;

  SachDetailTC({required this.sach});

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
            colors: [Colors.blue, Colors.white],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 150,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.network(
                  sach.hinh_bia!,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Tựa đề: ${sach.tieu_de}",
                style: TextStyle(color: Colors.white, fontSize: 25),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 10),
              Text(
                "Tác giả: ${sach.id_tacgia}",
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 10),
              Text(
                "Mô tả: ${sach.mo_ta}",
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 10),
              Text(
                "Nhà xuất bản: ${sach.id_nhaxuatban}",
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 10),
              Text(
                "Giá: ${sach.gia} VNĐ",
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.left,
              ),
              // Thêm các thông tin khác của sách tại đây (nếu cần)
            ],
          ),
        ),
      ),
    );
  }
}
