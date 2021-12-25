part of flutter_beacon;

class Region{
  final String identifier;
  final String? proximityUUID; /// For iOS, this value can not be null.
  final int? major; /// For both Android and iOS, this value can be null.
  final int? minor; /// For both Android and iOS, this value can be null.

  Region({
    required this.identifier,
    this.proximityUUID,
    this.major,
    this.minor,
  }) {
    if (Platform.isIOS) {
      assert(
      proximityUUID != null,
      'Scanning beacon for iOS must provided proximityUUID',
      );
    }
  }
  // Constructor for deserialize json [Map] into [Region] object.
  Region.fromJson(dynamic json)
      : this(
    identifier: json['identifier'],
    proximityUUID: json['proximityUUID'],
    major: _parseMajorMinor(json['major']),
    minor: _parseMajorMinor(json['minor']),
  );

  // Return the serializable of this object into [Map].
  dynamic get toJson {
    final map = <String, dynamic>{
      'identifier': identifier,
    };

    if (proximityUUID != null) {
      map['proximityUUID'] = proximityUUID;
    }

    if (major != null) {
      map['major'] = major;
    }

    if (minor != null) {
      map['minor'] = minor;
    }

    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Region &&
              runtimeType == other.runtimeType &&
              identifier == other.identifier;

  @override
  int get hashCode => identifier.hashCode;

  static int? _parseMajorMinor(dynamic number) {
    if (number is num) {
      return number.toInt();
    }

    if (number is String) {
      return int.tryParse(number);
    }

    return null;
  }

  @override
  String toString() {
    return json.encode(toJson);
  }
}