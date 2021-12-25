part of flutter_beacon;

class RangingResult{
  final Region region;
  final List<Beacon> beacons;

  RangingResult.from(dynamic json)
      : region = Region.fromJson(json['region']),
        beacons = Beacon.beaconFromArray(json['beacons']);
  dynamic get toJson => <String, dynamic>{
    'region': region.toJson,
    'beacons': Beacon.beaconArrayToJson(beacons),
  };
  @override
  String toString() {
    return json.encode(toJson);
  }
}