import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_engineering_lab/model/beacons_model.dart';
import 'package:smart_engineering_lab/model/user_model.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  final CollectionReference userUELDataCollection =
      FirebaseFirestore.instance.collection('usersUEL');

  final CollectionReference beaconsDataCollection =
      FirebaseFirestore.instance.collection('beacons');

//USER DATA
  Future createUserData({
    required String name,
    required String email,
    required String role,
  }) async {
    await userUELDataCollection.doc(uid).set({
      'name': name,
      'email': email,
      'uid': uid,
      'role': role,
      'lastSeen': DateTime.now().toUtc(),
    });
  }

  Stream<UserModel> get readUserName {
    return userUELDataCollection
        .doc(uid)
        .snapshots()
        .map((DocumentSnapshot snapshot) {
      return _userName(snapshot);
    });
  }

//MAPPING TO USER MODEL
  UserModel _userName(DocumentSnapshot snapshot) {
    final data = snapshot.data();
    log("User Data; $data");
    //log('User exist : ${snapshot.data().}');
    return UserModel(
        // userId: data['uid'],
        // name: data['name'],
        // email: data['email'],
        // descrption: data['description']
        );
  }

  Future createBeacon(BeaconEstimote beaconEstimote) async {
    await beaconsDataCollection.doc(beaconEstimote.identifier).set({
      'name': beaconEstimote.name,
      'identifier': beaconEstimote.identifier,
      'major': beaconEstimote.major,
      'minor': beaconEstimote.minor,
      'uuid': beaconEstimote.uuid
    });
  }

  Stream<List<BeaconEstimote>> get listOfBeacons {
    return beaconsDataCollection
        .snapshots()
        .map((event) => _listBeacons(event));
  }

  List<BeaconEstimote> _listBeacons(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((e) => BeaconEstimote(
            identifier: e['identifier'],
            name: e['name'],
            uuid: e['uuid'],
            major: e['major'],
            minor: e['minor']))
        .toList();
  }
}
