// file: data_access_layer/sach_dao.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:muabansach/APIConstant.dart';
import 'package:muabansach/model/sach.dart';

class SachDAO {
  final String ip = APIConstants.ip;

  Future<List<Sach>> fetchAllBooks() async {
    final response = await http.get(
      Uri.parse("$ip/sach"),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      List<Sach> sachList = data.map((sachJson) {
        // Convert string to DateTime
        DateTime ngayXuatBan = DateTime.parse(sachJson['ngay_xuat_ban']);
        // Create a Sach object from JSON
        return Sach(
          id_sach: sachJson['id_sach'],
          tieu_de: sachJson['tieu_de'],
          ngay_xuat_ban: ngayXuatBan,
          id_theloai: sachJson['id_theloai'],
          mo_ta: sachJson['mo_ta'],
          hinh_bia: sachJson['hinh_bia'],
          noidung: sachJson['noidung'],
          id_nhaxuatban: sachJson['id_nhaxuatban'],
          id_tacgia: sachJson['id_tacgia'],
          danhgia: sachJson['danhgia'],
          gia: sachJson['gia'],
        );
      }).toList();
      return sachList;
    } else {
      throw Exception("Failed to load books!");
    }
  }
}
