import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:smart_engineering_lab/enum/view_state_enum.dart';
import 'package:smart_engineering_lab/model/attendance_model.dart';
import 'package:smart_engineering_lab/model/beacons_model.dart';
import 'package:smart_engineering_lab/model/lab_booking_model.dart';
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

  final CollectionReference labBookingCollection =
      FirebaseFirestore.instance.collection('labBooking');

  final CollectionReference attendanceCollection =
      FirebaseFirestore.instance.collection('attendaces');

//USER DATA
  Future createUserData({
    required String name,
    required String email,
    required String role,
    required String id,
  }) async {
    await userUELDataCollection.doc(uid).set({
      'name': name,
      'email': email,
      'id': id,
      'uid': uid,
      'role': role,
      'lastSeen': DateTime.now().toUtc(),
    });
  }

  Future updateUserData({required Map<String, dynamic> data}) async {
    await userUELDataCollection.doc(uid).update(data);
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
        role: data['role'],
        id: data['id']);
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

  Future createLabModule(LabModuleViewModel labModuleViewModel,
      RootChangeNotifier changeNotifier) async {
    try {
      changeNotifier.setState(ViewState.BUSY);
      for (var section in labModuleViewModel.sections!) {
        await Future.forEach<Description>(section.description!,
            (description) async {
          if (description.path != null) {
            final task = await StorageService.uploadFile(
                destination:
                    'labModuleImage/${labModuleViewModel.beaconId}/${basename(description.path!)}',
                file: File(description.path!));
            description.pictureLink = await task.ref.getDownloadURL();
          }
        });
      }
      await labModuleCollection
          .doc(
              '${labModuleViewModel.nameModule!.text}.${DateTime.now().toIso8601String()}')
          .set(labModuleViewModel.toJson());
      changeNotifier.setState(ViewState.IDLE);
    } catch (e) {
      changeNotifier.setState(ViewState.IDLE);
      rethrow;
    }
  }

  Future updateLabModule(LabModuleViewModel labModuleViewModel,
      RootChangeNotifier changeNotifier) async {
    try {
      changeNotifier.setState(ViewState.BUSY);
      // for (var section in labModuleViewModel.sections!) {
      //   await Future.forEach<Description>(section.description!,
      //       (description) async {
      //     if (description.path != null) {
      //       final task = await StorageService.uploadFile(
      //           destination:
      //               'labModuleImage/${labModuleViewModel.beaconId}/${basename(description.path!)}',
      //           file: File(description.path!));
      //       description.pictureLink = await task.ref.getDownloadURL();
      //     }
      //   });
      // }
      await labModuleCollection
          .doc(labModuleViewModel.labModuleId)
          .update(labModuleViewModel.toJson());
      changeNotifier.setState(ViewState.IDLE);
    } catch (e) {
      changeNotifier.setState(ViewState.IDLE);
      rethrow;
    }
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
      var preparedBys = e1['userPreparedBy'] as List;
      return LabModuleViewModel(
          userPreparedBy: preparedBys
              .map((user) => UserModel(id: user['id'], name: user['name']))
              .toList(),
          userPreparedFor: e1['userPreparedFor'],
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
                      pictureLink: e3['pictureLink'],
                      description:
                          TextEditingController(text: e3['description']));
                }).toList());
          }).toList());
    }).toList();
  }

  Future createAttendance(AttendanceModel attendanceModel) async {
    try {
      var docs = await attendanceCollection
          .where('id', isEqualTo: attendanceModel.id)
          .get();
      if (docs.docs.isEmpty) {
        await attendanceCollection
            .doc(attendanceModel.id)
            .set(attendanceModel.toJson());
      }
    } catch (e) {
      print('error create attendance : ${e.toString()}');
    }
  }

  Future updateAttendance(AttendanceModel attendanceModel) async {
    try {
      await attendanceCollection
          .doc(attendanceModel.id)
          .update(attendanceModel.toJson());
    } catch (e) {
      print('error update attendance : ${e.toString()}');
    }
  }

  Stream<List<AttendanceModel>> get listOfAttendace {
    return attendanceCollection.snapshots().map((event) => event.docs
        .map((e) => AttendanceModel(
            date: e['date'],
            time: e['time'],
            user: UserModel.fromJson(e['user']),
            id: e['id']))
        .toList());
  }

  Future createLabBooking(LabBookingModel labBookingModel,
      RootChangeNotifier changeNotifier) async {
    try {
      changeNotifier.setState(ViewState.BUSY);
      var id =
          '${labBookingModel.date.toString()}.${labBookingModel.room}.${labBookingModel.slot}';
      var docs = await labBookingCollection.where('id', isEqualTo: id).get();
      var docEmpty = docs.docs.isEmpty;

      if (docEmpty) {
        labBookingModel.id = id;

        await labBookingCollection
            .doc(labBookingModel.id)
            .set(labBookingModel.toJson());
        changeNotifier.setState(ViewState.IDLE);
      } else {
        changeNotifier.setState(ViewState.IDLE);
        throw Exception('Slot already booked');
      }
    } catch (e) {
      changeNotifier.setState(ViewState.IDLE);
      rethrow;
    }
  }

  Stream<List<LabBookingModel>> listOfLabBookingForADay(DateTime day) {
    print('DAY : ${day.toString()}');
    return labBookingCollection
        .where('date', isEqualTo: day.toString())
        .snapshots()
        .map((event) => event.docs
            .map((e) => LabBookingModel(
                id: e['id'], room: e['room'], date: e['date'], slot: e['slot']))
            .toList());
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
            pictureLink: e['pictureLink'],
            attendance: e['attendance']))
        .toList();
  }
}
