class NguoiDung {
  final int id_nguoidung;
  final String email;
  final String mat_khau;
  final int id_giohang;

  NguoiDung({
    required this.id_nguoidung,
    required this.email,
    required this.mat_khau,
    required this.id_giohang,

  });

  factory NguoiDung.fromJson(Map<String, dynamic> json) {
    return NguoiDung(
      id_nguoidung: json["id_nguoidung"],
      email: json["email"],
      mat_khau: json["mat_khau"],
      id_giohang: json["id_giohang"],
    );
  }
}