import 'package:flutter/material.dart';
import 'package:smart_engineering_lab/enum/view_state_enum.dart';

class RootChangeNotifier with ChangeNotifier {
  ViewState? _viewState;

  void setState(ViewState newState) {
    _viewState = newState;
    notifyListeners();
  }

  ViewState get getViewState => _viewState!;
}
