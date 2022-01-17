class BeaconEstimote {
  String? identifier;
  String? uuid;
  String? name;
  int? major;
  int? minor;
  String? pictureLink;
  bool? attendance;

  BeaconEstimote(
      {this.uuid,
      this.major,
      this.minor,
      this.name,
      this.identifier,
      this.pictureLink,
      this.attendance});

  factory BeaconEstimote.fromJson(Map json) {
    return BeaconEstimote(
        identifier: json['identifier'],
        uuid: json['uuid'],
        name: json['name'],
        major: json['major'],
        minor: json['minor'],
        pictureLink: json['pictureLink'],
        attendance: json['attendance']);
  }

  Map toJson() {
    return {
      'name': name,
      'uuid': uuid,
      'major': major,
      'minor': minor,
      'identifier': identifier,
      'pictureLink': pictureLink,
      'attendance': attendance
    };
  }
}
