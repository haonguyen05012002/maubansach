import 'package:flutter/material.dart';
import 'Sach.dart';

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
                colors: [Colors.blue, Colors.orange],)),
          child: Center(


            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(sach.hinh_bia!),
                  radius: 150,
                ),
                SizedBox(height: 150),
                Text("ID: ${sach.tieu_de}", style: TextStyle(color: Colors.white, fontSize: 15),),

                Text("Name: ${sach.mo_ta}", style: TextStyle(color: Colors.white, fontSize: 20),),
                // Thêm các thông tin khác của cocktail tại đây (nếu cần)
              ],
            ),


          ),
        )

    );
  }
}