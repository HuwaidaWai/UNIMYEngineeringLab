class UserModel {
  String? uid;
  String? name;
  String? id;
  String? email;
  String? role;

  UserModel({this.uid, this.name, this.email, this.role, this.id});
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        uid: json['uid'],
        name: json['name'],
        email: json['email'],
        role: json['role'],
        id: json['id']);
  }
  Map<String, dynamic> toJson() {
    return {'uid': uid, 'name': name, 'email': email, 'role': role, 'id': id};
  }
}
