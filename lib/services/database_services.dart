import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_engineering_lab/model/user_model.dart';

class DatabaseService {
  final String uid;

  DatabaseService(this.uid);

  final CollectionReference userUELDataCollection =
      FirebaseFirestore.instance.collection('usersUEL');

  final CollectionReference beaconsDataCollection =
      FirebaseFirestore.instance.collection('beacons');

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
}
