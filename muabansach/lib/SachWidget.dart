import 'package:flutter/material.dart';
import 'Sach.dart';

class SachWidgets extends StatelessWidget{
  SachWidgets({super.key, required this.sachs});

  final List<Sach> sachs;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sachs.length,
      itemBuilder: (context, index) {
        final sach = sachs[index];
        return ListTile(
          // onTap: () {
          //   // Điều hướng sang trang chi tiết cocktail khi bấm vào một cocktail
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => CocktailDetail(cocktail: cocktail),
          //     ),
          //   );
          // }
          //,
        title: Row(
          children: [
            SizedBox(
              width: 100,
              child: ClipRRect(
                child: Image.network(
                  sach.hinh_bia,
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
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),



            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(sach.id_sach,style: TextStyle(color: Colors.white, fontSize: 15)), Text(sach.tieu_de, style: TextStyle(color: Colors.white, fontSize: 20))],
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