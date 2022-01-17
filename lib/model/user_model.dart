class UserModel {
  String? uid;
  String? name;
  String? id;
  String? email;
  String? role;

  UserModel({this.uid, this.name, this.email, this.role, this.id});

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'name': name, 'email': email, 'role': role, 'id': id};
  }
}
