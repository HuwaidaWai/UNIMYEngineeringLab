import 'package:flutter_beacon/flutter_beacon.dart';

class BeaconViewModel {
  String? name;
  String? pictureLink;
  Beacon? beacon;

  BeaconViewModel({this.beacon, this.name, this.pictureLink});

  factory BeaconViewModel.fromJson(Map data) {
    return BeaconViewModel(
        beacon: data['beacon'],
        name: data['name'],
        pictureLink: data['pictureLink']);
  }
}
