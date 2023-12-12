//import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';

import '../Models/UserModel.dart';
import '../Services/userService.dart';

class CurrentUser {
  CurrentUser._internal();

  static final CurrentUser _instance = CurrentUser._internal();

  static CurrentUser get instance => _instance;
  UserModel user = UserModel(
      idUser: 0,
      userName: "",
      name: "",
      lastName: "",
      password: "",
      isActive: false);

  Future<void> userLogin(String userName, String password) async {
    //SVProgressHUD.show();
    user = await UserService.userLogin(userName, password);
    //SVProgressHUD.dismiss();
  }

  Future<void> userLogoff() async {
    //SVProgressHUD.show();
    user = UserModel(
        idUser: 0,
        userName: "",
        name: "",
        lastName: "",
        password: "",
        isActive: false);
    //SVProgressHUD.dismiss();
  }
}
