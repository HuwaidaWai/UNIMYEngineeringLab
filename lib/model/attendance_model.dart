import 'package:smart_engineering_lab/model/user_model.dart';

class AttendanceModel {
  String? date;
  String? time;
  UserModel? user;
  String? id;
  bool? isAttend;

  AttendanceModel({this.date, this.time, this.user, this.id, this.isAttend});

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'time': time,
      'user': user!.toJson(),
      'id': id,
      'isAttend': isAttend
    };
  }
}
