import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_engineering_lab/enum/view_state_enum.dart';
import 'package:smart_engineering_lab/model/attendance_model.dart';
import 'package:smart_engineering_lab/model/user_model.dart';

class RootChangeNotifier with ChangeNotifier {
  ViewState _viewState = ViewState.IDLE;
  Role? _role;
  File? _imageFood;
  UserModel? _userModel;
  bool _isPushedAttendance = false;
  AttendanceModel? _attendanceModel;
  // ignore: prefer_final_fields
  Map<String, bool> _isPushedNotification = {};
  void setAttendanceModel(AttendanceModel attendanceModel) {
    _attendanceModel = attendanceModel;
    notifyListeners();
  }

  AttendanceModel get getAttendanceModel => _attendanceModel!;
  void setUser(UserModel userModel) {
    _userModel = userModel;
    notifyListeners();
  }

  UserModel get getUserModel => _userModel!;

  void setRole(Role role) {
    _role = role;
    notifyListeners();
  }

  void setAttendance(bool pushed) {
    _isPushedAttendance = pushed;
    notifyListeners();
  }

  void setPushedNotification(String identifier, bool pushed) {
    _isPushedNotification[identifier] = pushed;
    notifyListeners();
  }

  void setState(ViewState newState) {
    _viewState = newState;
    notifyListeners();
  }

  void setBeaconsImage(File user) {
    _imageFood = user;
    notifyListeners();
  }

  bool get getAttendance => _isPushedAttendance;
  File? get getBeacons => _imageFood;
  Map<String, bool> get getPushedNotification => _isPushedNotification;
  Role get getRoleState => _role!;
  ViewState get getViewState => _viewState;
}
