import 'package:flutter_beacon/flutter_beacon.dart';

class BeaconViewModel {
  String? name;
  String? pictureLink;
  Beacon? beacon;
  bool? attendance;
  BeaconViewModel({this.beacon, this.name, this.pictureLink, this.attendance});

  factory BeaconViewModel.fromJson(Map<String, dynamic> data) {
    return BeaconViewModel(
        beacon: Beacon(
            proximityUUID: data['beacon']['proximityUUID'],
            major: data['beacon']['major'],
            minor: data['beacon']['minor'],
            accuracy: data['beacon']['accuracy']),
        name: data['name'],
        pictureLink: data['pictureLink'],
        attendance: data['attendance']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'pictureLink': pictureLink,
      'beacon': beacon!.toJson,
      'attendance': attendance
    };
  }
}
