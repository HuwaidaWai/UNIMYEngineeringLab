import 'package:flutter_beacon/flutter_beacon.dart';

class BeaconViewModel {
  String? name;
  Beacon? beacon;

  BeaconViewModel({this.beacon, this.name});

  factory BeaconViewModel.fromJson(Map data) {
    return BeaconViewModel(beacon: data['beacon'], name: data['name']);
  }
}
