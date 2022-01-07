class BeaconEstimote {
  String? identifier;
  String? uuid;
  String? name;
  int? major;
  int? minor;

  BeaconEstimote(
      {this.uuid, this.major, this.minor, this.name, this.identifier});

  factory BeaconEstimote.fromJson(Map json) {
    return BeaconEstimote(
        identifier: json['identifier'],
        uuid: json['uuid'],
        name: json['name'],
        major: json['major'],
        minor: json['minor']);
  }

  Map toJson() {
    return {
      'name': name,
      'uuid': uuid,
      'major': major,
      'minor': minor,
      'identifier': identifier
    };
  }
}
