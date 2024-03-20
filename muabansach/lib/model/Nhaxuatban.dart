class Nhaxuatban {
  final int  id_nhaxuatban;
  final String ten_nhaxuatban;



  Nhaxuatban({
    required this.id_nhaxuatban,
    required this.ten_nhaxuatban,

  });

  factory Nhaxuatban.fromJson(Map<String, dynamic> json) {
    return Nhaxuatban(
      id_nhaxuatban : json["id_nhaxuatban"],
      ten_nhaxuatban : json["ten_nhaxuatban"],
    );
  }
}