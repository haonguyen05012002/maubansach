import 'package:muabansach/DAO/Sach_DAO.dart';
import 'package:muabansach/model/sach.dart';
import 'package:muabansach/UserSingleton.dart';

class TrangChuBUS {
  final _sachDAO = SachDAO();
  final _userId = UserSingleton().getUserId();
  late List<Sach> sachs;

  int? getUserId() => _userId;

  Future<void> populateAllBooks() async {
    try {
      sachs = await _sachDAO.fetchAllBooks();
    } catch (error) {
      // Xử lý lỗi nếu cần
      print('Error: $error');
      sachs = []; // Gán danh sách rỗng để tránh null
    }
  }

  List<Sach> getBooksList() {
    return sachs;
  }

  void dispose() {
    // Không cần thực hiện gì trong phương thức dispose vì không còn sử dụng StreamController nữa
  }
}
