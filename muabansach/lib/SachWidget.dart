import 'package:flutter/material.dart';
import 'package:muabansach/SachDetail.dart';
import 'Sach.dart';
import 'dart:convert';

class SachWidgets extends StatelessWidget {
  SachWidgets({Key? key, required this.sachs}) : super(key: key);

  final List<Sach> sachs;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sachs.length,
      itemBuilder: (context, index) {
        final sach = sachs[index];
        return ListTile(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SachDetail(sach: sach),
              ),
            );
          },
          title: Row(
            children: [
              SizedBox(
                width: 100,
                child: ClipRRect(
                  child: sach.hinh_bia != null
                      ? Image.network(
                    sach.hinh_bia!,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      }
                    },
                  )
                      : Container(), // Nếu hinhBia là null, trả về một container trống
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sach.id_sach.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      Text(
                        sach.tieu_de ?? '', // Kiểm tra null cho tieu_de
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

