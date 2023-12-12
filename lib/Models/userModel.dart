class UserModel {
  int? idUser;
  String? userName;
  String? name;
  String? lastName;
  String? password;
  bool? isActive;

  UserModel({
    required this.idUser,
    required this.userName,
    required this.name,
    required this.lastName,
    required this.password,
    required this.isActive
  });
}