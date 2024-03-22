class Sach {
  final int id_sach;
  final String tieu_de;
  final DateTime ngay_xuat_ban;
  final int id_theloai;
  final String mo_ta;
  final String? hinh_bia;
  final String noidung;
  final int id_nhaxuatban;
  final int id_tacgia;
  final int danhgia;
  final int gia;

  static Sach getTestSach() {
    return Sach(
      id_sach: 1,
      tieu_de: 'Test Sach',
      ngay_xuat_ban: DateTime.now(),
      id_theloai: 1,
      mo_ta: 'This is a test sach',
      hinh_bia: 'test_image.png',
      noidung: 'Test content',
      id_nhaxuatban: 1,
      id_tacgia: 1,
      danhgia: 5,
      gia: 100,
    );
  }

  Sach(
      {required this.id_sach,
      required this.tieu_de,
      required this.ngay_xuat_ban,
      required this.id_theloai,
      required this.mo_ta,
      required this.hinh_bia,
      required this.noidung,
      required this.id_nhaxuatban,
      required this.id_tacgia,
      required this.danhgia,
      required this.gia});

  @override
  String toString() {
    return 'Sach{id_sach: $id_sach, tieu_de: $tieu_de, ngay_xuat_ban: $ngay_xuat_ban, id_theloai: $id_theloai, mo_ta: $mo_ta, hinh_bia: $hinh_bia, noidung: $noidung, id_nhaxuatban: $id_nhaxuatban, id_tacgia: $id_tacgia, danhgia: $danhgia, gia: $gia}';
  }

  factory Sach.fromJson(Map<String, dynamic> json) {
    return Sach(
      id_sach: json["id_sach"],
      tieu_de: json["tieu_de"],
      ngay_xuat_ban: DateTime.parse(json["ngay_xuat_ban"]),
      // Parsing the date string to DateTime
      id_theloai: json["id_theloai"],
      mo_ta: json["mo_ta"],
      hinh_bia: json["hinh_bia"],
      noidung: json["noidung"],
      id_nhaxuatban: json["id_nhaxuatban"],
      id_tacgia: json["id_tacgia"],
      danhgia: json["danhgia"],
      gia: json["gia"],
    );
  }
}
