part of flutter_beacon;

class BeaconBroadcast {
  final String? identifier;
  final String proximityUUID;
  final int major;
  final int minor;
  final int? txPower;
  final AdvertisingMode? advertisingMode;
  final AdvertisingTxPowerLevel? advertisingTxPowerLevel;

  BeaconBroadcast({
    this.identifier = 'com.flutterBeacon',
    required this.proximityUUID,
    required this.major,
    required this.minor,
    this.txPower,
    this.advertisingMode = AdvertisingMode.low,
    this.advertisingTxPowerLevel = AdvertisingTxPowerLevel.high,
  }) {
    if (Platform.isAndroid) {
      assert(advertisingMode != null);
      assert(advertisingTxPowerLevel != null);
    } else if (Platform.isIOS) {
      assert(identifier != null);
    }
  }

  //Serialize current instance object into [Map]
  dynamic get toJson {
    final map = <String, dynamic>{
      'proximityUUID': proximityUUID,
      'major': major,
      'minor': minor,
      'txPower': txPower,
    };

    if (advertisingMode != null) {
      map['advertisingMode'] = advertisingMode!.index;
    }
    if (advertisingTxPowerLevel != null) {
      map['advertisingTxPowerLevel'] = advertisingTxPowerLevel!.index;
    }
    if (identifier != null) {
      map['identifier'] = identifier!;
    }
    return map;
  }
}

enum AdvertisingMode{low, mid, high}
enum AdvertisingTxPowerLevel{ultralow, low, mid, high}