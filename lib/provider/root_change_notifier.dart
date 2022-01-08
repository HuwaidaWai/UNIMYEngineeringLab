import 'package:flutter/material.dart';
import 'package:smart_engineering_lab/enum/view_state_enum.dart';

class RootChangeNotifier with ChangeNotifier {
  ViewState _viewState = ViewState.IDLE;
  Role? _role;
  bool _isPushedNotification = false;
  void setRole(Role role) {
    _role = role;
    notifyListeners();
  }

  void setPushedNotification(bool isPushed) {
    _isPushedNotification = isPushed;
    notifyListeners();
  }

  void setState(ViewState newState) {
    _viewState = newState;
    notifyListeners();
  }

  bool get getPushedNotification => _isPushedNotification;
  Role get getRoleState => _role!;
  ViewState get getViewState => _viewState;
}
