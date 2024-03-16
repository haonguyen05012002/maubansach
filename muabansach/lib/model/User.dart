import 'dart:convert';

class User {
  final int idNguoiDung;
  final String email;
  final String matKhau;
  final bool isAdmin;

  User({
    required this.idNguoiDung,
    required this.email,
    required this.matKhau,
    required this.isAdmin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idNguoiDung: json['id_nguoidung'],
      email: json['email'],
      matKhau: json['mat_khau'],
      isAdmin: json['admin'] != null ? _parseAdmin(json['admin']) : false,
    );
  }

  static bool _parseAdmin(Map<String, dynamic> adminData) {
    final bufferData = adminData['data'];
    if (bufferData is List) {
      // Giả sử admin là true nếu bufferData không trống
      return bufferData.isNotEmpty;
    }
    return false;
  }
}
