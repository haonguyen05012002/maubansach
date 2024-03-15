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
      id: json['id'] as int,
      sachId: json['id_sach'] as int, // Sử dụng id_sach để lấy thông tin của sách
      idNguoiDung: json['id_nguoidung'] as int,
    );
  }
}
