class UserModel {
  String? uid;
  String? name;
  String? email;
  String? role;

  UserModel({this.uid, this.name, this.email, this.role});

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'name': name, 'email': email, 'role': role};
  }
}
