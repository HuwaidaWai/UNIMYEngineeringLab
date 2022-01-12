import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:smart_engineering_lab/enum/view_state_enum.dart';
import 'package:smart_engineering_lab/model/beacons_model.dart';
import 'package:smart_engineering_lab/model/lab_module_model.dart';
import 'package:smart_engineering_lab/model/user_model.dart';
import 'package:smart_engineering_lab/provider/root_change_notifier.dart';
import 'package:smart_engineering_lab/services/storage_services.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  final CollectionReference userUELDataCollection =
      FirebaseFirestore.instance.collection('usersUEL');

  final CollectionReference beaconsDataCollection =
      FirebaseFirestore.instance.collection('beacons');

  final CollectionReference labModuleCollection =
      FirebaseFirestore.instance.collection('labModules');

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
    // print('Snapshot $snapshot');
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    log("User Data; $data");
    //log('User exist : ${snapshot.data().}');
    return UserModel(
        uid: data['uid'],
        name: data['name'],
        email: data['email'],
        role: data['role']);
  }

  Future createBeacon(BeaconEstimote beaconEstimote,
      RootChangeNotifier changeNotifier, File imageFile) async {
    changeNotifier.setState(ViewState.BUSY);
    final task = await StorageService.uploadFile(
        destination:
            'beaconsimage/${beaconEstimote.identifier}/${basename(imageFile.path)}',
        file: imageFile);
    beaconEstimote.pictureLink = await task.ref.getDownloadURL();
    await beaconsDataCollection.doc(beaconEstimote.identifier).set({
      'name': beaconEstimote.name,
      'identifier': beaconEstimote.identifier,
      'major': beaconEstimote.major,
      'minor': beaconEstimote.minor,
      'uuid': beaconEstimote.uuid,
      'pictureLink': beaconEstimote.pictureLink
    });
    changeNotifier.setState(ViewState.IDLE);
  }

  Future updateBeacon(Map<String, dynamic> dataToUpdate,
      BeaconEstimote beaconEstimote, RootChangeNotifier rootChangeNotifier,
      {File? imageFile}) async {
    rootChangeNotifier.setState(ViewState.BUSY);
    if (imageFile != null) {
      final task = await StorageService.uploadFile(
          destination:
              'beaconsimage/${beaconEstimote.identifier}/${basename(imageFile.path)}',
          file: imageFile);
      dataToUpdate['pictureLink'] = await task.ref.getDownloadURL();
    }
    await beaconsDataCollection
        .doc(beaconEstimote.uuid)
        .update(dataToUpdate)
        .catchError((e) {
      log('Error : $e');
      rootChangeNotifier.setState(ViewState.IDLE);
    }).whenComplete(() => rootChangeNotifier.setState(ViewState.IDLE));
  }

  Future createLabModule(LabModuleViewModel labModuleViewModel) async {
    for (var section in labModuleViewModel.sections!) {
      for (var description in section.description!) {
        if (description.path != null) {
          final task = await StorageService.uploadFile(
              destination:
                  'labModuleImage/${labModuleViewModel.beaconId}/${basename(description.path!)}',
              file: File(description.path!));
          description.path = await task.ref.getDownloadURL();
        }
      }
    }
    await labModuleCollection
        .doc(
            '${labModuleViewModel.nameModule!.text}.${DateTime.now().toIso8601String()}')
        .set(labModuleViewModel.toJson());
  }

  Future deleteLabModule(String labModuleId) async {
    await labModuleCollection.doc(labModuleId).delete();
  }

  Stream<List<LabModuleViewModel>> listLabModules(String beaconId) {
    return labModuleCollection
        .where('beaconId', isEqualTo: beaconId)
        .snapshots()
        .map((event) => _listModuleViewModel(event));
  }

  List<LabModuleViewModel> _listModuleViewModel(QuerySnapshot snapshot) {
    return snapshot.docs.map((e1) {
      print('Identifier please : ${e1.id}');
      var section = e1['sections'] as List;
      return LabModuleViewModel(
          labModuleId: e1.id,
          nameModule: TextEditingController(text: e1['nameModule']),
          titleModule: TextEditingController(text: e1['titleModule']),
          sections: section.map<SectionViewModel>((e2) {
            var descriptionSection = e2['description'] as List;
            // print('Identifier please : ${e2['description']}');
            return SectionViewModel(
                titleSection: TextEditingController(text: e2['titleSection']),
                description: descriptionSection.map<Description>((e3) {
                  return Description(
                      path: e3['path'],
                      type: e3['type'],
                      description:
                          TextEditingController(text: e3['description']));
                }).toList());
          }).toList());
    }).toList();
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
            minor: e['minor'],
            pictureLink: e['pictureLink']))
        .toList();
  }
}
