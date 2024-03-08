
import 'package:flutter/material.dart';
import 'model/Sach.dart';


class CocktailWidget extends StatelessWidget {
  CocktailWidget({Key? key, required this.sachs}) : super(key: key);
  late final List<Sach> sachs;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sachs.length,
      itemBuilder: (context, index) {
        final sach = sachs[index];
        return ListTile(
          onTap: () {
            // Điều hướng sang trang chi tiết cocktail khi bấm vào một cocktail
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => tail(cocktail: cocktail),
            //   ),
            // );
          }
          ,
          title: Row(
            children: [
              SizedBox(
                width: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
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
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(sach.tieu_de), Text(String.fromCharCode(sach.gia))],
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
