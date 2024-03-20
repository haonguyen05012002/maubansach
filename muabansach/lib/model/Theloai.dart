 class Theloai {
  final int  id_theloai;
  final String ten_theloai;



  Theloai({
    required this.id_theloai,
    required this.ten_theloai,

  });

  factory Theloai.fromJson(Map<String, dynamic> json) {
    return Theloai(
        id_theloai : json["id_theloai"],
        ten_theloai : json["ten_theloai"],
    );
  }
}
