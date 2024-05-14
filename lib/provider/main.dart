import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  late String userName;
  late String role;

  void setUserName(String email) {
    this.userName = email;
    notifyListeners();
  }

  void setRole(String role) {
    this.role = role;
    notifyListeners();
  }
}
