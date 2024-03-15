class UserSingleton {
  static final UserSingleton _singleton = UserSingleton._internal();
  factory UserSingleton() {
    return _singleton;
  }

  UserSingleton._internal();

  int? userId;

  void setUserId(int id) {
    userId = id;
  }

  int? getUserId() {
    return userId;
  }
}
