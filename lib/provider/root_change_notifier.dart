import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_engineering_lab/enum/view_state_enum.dart';

class RootChangeNotifier with ChangeNotifier {
  ViewState _viewState = ViewState.IDLE;
  Role? _role;
  File? _imageFood;
  // ignore: prefer_final_fields
  Map<String, bool> _isPushedNotification = {};
  void setRole(Role role) {
    _role = role;
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

  File? get getBeacons => _imageFood;
  Map<String, bool> get getPushedNotification => _isPushedNotification;
  Role get getRoleState => _role!;
  ViewState get getViewState => _viewState;
}
