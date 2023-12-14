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
    user = await UserService.userLogin(userName, password);
  }

  Future<void> userLogoff() async {
    user = UserModel(
        idUser: 0,
        userName: "",
        name: "",
        lastName: "",
        password: "",
        isActive: false);
  }
}
