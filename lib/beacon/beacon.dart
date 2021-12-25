part of '../flutter_beacon.dart';

enum Proximity { unknown, immediate, near, far }

class Beacon {
  final String proximityUUID;
  final String? macAddress;

  /// From iOS this value will be null
  final int major;
  final int minor;
  final int rssi;
  final int? txPower;

  /// From iOS this value will be null
  final double accuracy;
  final Proximity? _proximity;

  const Beacon({
    required this.proximityUUID,
    this.macAddress,
    required this.major,
    required this.minor,
    int? rssi,
    this.txPower,
    required this.accuracy,
    Proximity? proximity,
  })
      : this.rssi = rssi ?? -1,
        this._proximity = proximity;

  ///Create beacon object from json
  Beacon.fromJson(dynamic json)
      : this(
    proximityUUID: json['proximityUUIS'],
    macAddress: json['macAddress'],
    major: json['major'],
    minor: json['minor'],
    rssi: _parseInt(json['rssi']),
    txPower: _parseInt(json['accuracy']),
    accuracy: _parseDouble(json['accuracy']),
    proximity: _parseProximity(json['proximity']),
  );

  //Parsing dynamic data into double

  static double _parseDouble(dynamic data) {
    if (data is num) {
      return data.toDouble();
    } else if (data is String) {
      return double.tryParse(data) ?? 0.0;
    }
    return 0.0;
  }

  //Parsing dynamic data into integer
  static int? _parseInt(dynamic data) {
    if (data is num) {
      return data.toInt();
    } else if (data is String) {
      return int.tryParse(data) ?? 0;
    }
    return null;
  }

  //Parsing dynamic proximity into enum [Proximity]
  static dynamic _parseProximity(dynamic proximity) {
    if (proximity == 'unknown') {
      return Proximity.unknown;
    }

    if (proximity == 'immediate') {
      return Proximity.immediate;
    }

    if (proximity == 'near') {
      return Proximity.near;
    }

    if (proximity == 'far') {
      return Proximity.far;
    }

    return null;
  }

  //Parsing array of [Map] into [List] of [Beacon]

  static List<Beacon> beaconFromArray(dynamic beacons) {
    if (beacons is List) {
      return beacons.map((json) {
        return Beacon.fromJson(json);
      }).toList();
    }
    return [];
  }

  //Parsing [List] of [Beacon] into array of [Map]
  static dynamic beaconArrayToJson(List<Beacon> beacons) {
    return beacons.map((beacon) {
      return beacon.toJson;
    }).toList();
  }

  //Serialize current instance object into [Map]
  dynamic get toJson{
    final map = <String, dynamic>{
      'proximityUUIS': proximityUUID,
      'major': major,
      'minor': minor,
      'rssi': rssi,
      'accuracy': accuracy,
      'proximity': proximity.toString().split('.').last
    };
    if(txPower != null){
      map['txPower'] = txPower;
    }
    if(macAddress != null){
      map['macAddress'] = macAddress;
    }

    return map;
  }

  //Return [Proximity] of beacon
  Proximity get proximity{
    if(_proximity != null){
      return _proximity!;
    }
    if(accuracy == 0.0){
      return Proximity.unknown;
    }
    if(accuracy <= 0.5){
      return Proximity.immediate;
    }
    if(accuracy < 3.0){
      return Proximity.near;
    }
    return Proximity.far;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Beacon &&
          runtimeType == other.runtimeType &&
          proximityUUID == other.proximityUUID &&
          major == other.major &&
          minor == other.minor &&
          (macAddress != null ? macAddress == other.macAddress: true);
  @override
  int get hashCode{
    int hashCode = proximityUUID.hashCode ^ major.hashCode ^ minor.hashCode;
    if(macAddress != null){
      hashCode = hashCode ^ macAddress.hashCode;
    }
    return hashCode;
  }
  @override
  String toString(){
    return json.encode(toJson);
  }
}
