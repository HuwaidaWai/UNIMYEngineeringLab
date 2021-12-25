part of '../flutter_beacon.dart';

class AuthorizationStatus{
  final String value;
  final bool isAndroid;
  final bool isIOS;

  @visibleForTesting
  const AuthorizationStatus.init(
      this.value, {
        this.isAndroid = false,
        this.isIOS = false,
      });
  @visibleForTesting
  factory AuthorizationStatus.parse(String value){
    switch (value) {
      case 'ALLOWED':
        return allowed;
      case 'ALWAYS':
        return always;
      case 'WHEN_IN_USE':
        return whenInUse;
      case 'DENIED':
        return denied;
      case 'RESTRICTED':
        return restricted;
      case 'NOT_DETERMINED':
        return notDetermined;
    }

    throw Exception('invalid authorization status $value');
  }
  //ONLY FOR ANDROID
  static const AuthorizationStatus allowed = AuthorizationStatus.init(
    'ALLOWED',
    isAndroid: true,
    isIOS: false,
  );
  //ONLY FOR IOS
  static const AuthorizationStatus always = AuthorizationStatus.init(
    'ALWAYS',
    isAndroid: false,
    isIOS: true,
  );
  //ONLY FOR IOS
  static const AuthorizationStatus whenInUse = AuthorizationStatus.init(
    'WHEN_IN_USE',
    isAndroid: false,
    isIOS: true,
  );
  static const AuthorizationStatus denied = AuthorizationStatus.init(
    'DENIED',
    isAndroid: true,
    isIOS: true,
  );
  //ONLY FOR IOS
  static const AuthorizationStatus restricted = AuthorizationStatus.init(
    'RESTRICTED',
    isAndroid: false,
    isIOS: true,
  );
  static const AuthorizationStatus notDetermined = AuthorizationStatus.init(
    'NOT_DETERMINED',
    isAndroid: true,
    isIOS: true,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AuthorizationStatus &&
              runtimeType == other.runtimeType &&
              value == other.value &&
              isAndroid == other.isAndroid &&
              isIOS == other.isIOS;
  @override
  int get hashCode => value.hashCode ^ isAndroid.hashCode ^ isIOS.hashCode;

  @override
  String toString(){
    return value;
  }
}