class GioHang {
  final int id;
  final int sachId; // Thêm trường sachId
  final int idNguoiDung;

  GioHang({
    required this.id,
    required this.sachId,
    required this.idNguoiDung,
  });

  factory GioHang.fromJson(Map<String, dynamic> json) {
    return GioHang(
      id: json['id'],
      sachId: json['id_sach'] ,
      idNguoiDung: json['id_nguoidung'],
    );
  }
}
