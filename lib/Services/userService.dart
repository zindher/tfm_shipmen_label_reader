import 'dart:convert';
import 'dart:io';
import '../Helpers/alert.dart';
import '../Providers/appConfig.dart';
import '../Models/UserModel.dart';
import 'package:http/http.dart' as http;

class UserService {
  static Future<UserModel> userLogin(String userName, String password) async {
    UserModel user = UserModel(idUser: 0, userName: "", name: "", lastName: "", password: "", isActive: false);
    try {
      String url = "${AppConfig.host}/User/UserLogin";

      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'UserName': userName,
            'Password': password,
          }));
      var responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        user = UserModel(
            idUser: responseData["idUser"] ?? 0,
            userName: responseData["userName"],
            name: responseData["name"],
            lastName: responseData["lastName"],
            password: responseData["password"],
            isActive: responseData["isActive"]);
      }
    } on SocketException {
      AlertHelper.showErrorToast("Error de conexión!!");
    } on HttpException {
      AlertHelper.showErrorToast("Error de servidor!!");
    } on FormatException {
      AlertHelper.showErrorToast("Error en el formato de salida!!");
    }
    catch(e) {
      AlertHelper.showErrorToast("Error de servidor!!");
    }
    finally {
      return user;
    }
  }
}
