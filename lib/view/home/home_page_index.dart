import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart'
    as firebaseMessaging;
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_engineering_lab/model/attendance_model.dart';
import 'package:smart_engineering_lab/model/beacons_model.dart';
import 'package:smart_engineering_lab/model/beacons_view_model.dart';
import 'package:smart_engineering_lab/model/user_model.dart';
import 'package:smart_engineering_lab/provider/root_change_notifier.dart';
import 'package:smart_engineering_lab/services/database_services.dart';
import 'package:smart_engineering_lab/services/local_notification_services.dart';
import 'package:smart_engineering_lab/view/home/beacons_screen.dart';
import 'package:smart_engineering_lab/view/home/home_screen.dart';
import 'package:smart_engineering_lab/view/home/lab_booking_screen.dart';
import 'package:smart_engineering_lab/view/home/settings_screen.dart';
import 'package:smart_engineering_lab/view/old/requirement_state_controller.dart';

class HomePageIndex extends StatefulWidget {
  const HomePageIndex({Key? key}) : super(key: key);

  @override
  _HomePageIndexState createState() => _HomePageIndexState();
}

class _HomePageIndexState extends State<HomePageIndex>
    with WidgetsBindingObserver {
  int _difference = 0;
  int _bottomSelectedIndex = 0;
  final pageController = PageController(initialPage: 0, keepPage: true);
  var listBeaconsGlobal = <BeaconEstimote>[];
  final controller = Get.find<RequirementStateController>();
  StreamSubscription<BluetoothState>? streamBluetooth;
  StreamSubscription<RangingResult>? streamRanging;
  final regionBeacons = <Region, List<BeaconViewModel>>{};
  var beaconsViewModels = <BeaconViewModel>[];
  var resultRegion = <Region>[];
  var regions = <Region>[];

  bool _isLoading = true;

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    // if (widget.userModel != null) {
    //   changeNotifier.setUser(widget.userModel!);
    // }
    listeningBluetoothState();
    controller.startStream.listen((flag) {
      printInfo(info: 'start stream $flag');
      if (flag == true) {
        initScanBeacon();
      }
    });

    controller.pauseStream.listen((flag) {
      printInfo(info: 'pause stream $flag');
      if (flag == true) {
        pauseScanBeacon();
      }
    });
    super.initState();
  }

  getFromDatabase() {
    final changeNotifier = context.read<RootChangeNotifier>();
    DatabaseService().listOfBeacons.listen((listBeacons) {
      print('listBeacons $listBeacons');
      if (listBeacons.isNotEmpty) {
        // if (changeNotifier.getPushedNotification == false) {
        //   var remoteNotificationLaporJumlah =
        //       firebaseMessaging.RemoteNotification(
        //           title: 'New beacons detected!',
        //           body: 'There are ${listBeacons.length} nearest');
        //   NotificationService().showNotification(
        //     remoteNotificationLaporJumlah,
        //   );
        //   changeNotifier.setPushedNotification(true);
        // }

        setState(() {
          listBeaconsGlobal = listBeacons;
        });
        regions.clear();
        for (var e in listBeacons) {
          regions.add(Region(
              identifier: e.identifier!,
              proximityUUID: e.uuid,
              major: e.major,
              minor: e.minor));
        }
        controller.updateRegionsList(regions);
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  initScanBeacon() async {
    print('INITSCANNING');
    await flutterBeacon.initializeScanning;
    print('Test: '
        'RETURNED, authorizationStatusOk=${controller.authorizationStatusOk}, '
        'locationServiceEnabled=${controller.locationServiceEnabled}, '
        'bluetoothEnabled=${controller.bluetoothEnabled}');
    if (!controller.authorizationStatusOk ||
        !controller.locationServiceEnabled ||
        !controller.bluetoothEnabled) {
      printError(info: 'Permission error');
      print('authorizationStatusOk=${controller.authorizationStatusOk}, '
          'locationServiceEnabled=${controller.locationServiceEnabled}, '
          'bluetoothEnabled=${controller.bluetoothEnabled}');
      return;
    }

    if (streamRanging != null) {
      if (streamRanging!.isPaused) {
        streamRanging?.resume();
        return;
      }
    }

    controller.regionList.listen((eventRegion) {
      print('Region beacons $eventRegion');
      if (eventRegion.isNotEmpty) {
        streamRanging =
            flutterBeacon.ranging(eventRegion).listen((RangingResult result) {
          print('Ranging Result $result');
          if (mounted) {
            setState(() {
              for (var rangingBeaconsGlobal in listBeaconsGlobal) {
                var _major = rangingBeaconsGlobal.toJson()["major"];
                if (result.beacons.isNotEmpty &&
                    (_major == result.beacons.first.major)) {
                  print('link: ${rangingBeaconsGlobal.pictureLink}');
                  var _beaconsViewModels = BeaconViewModel(
                      attendance: rangingBeaconsGlobal.attendance,
                      beacon: result.beacons.firstWhere((element) =>
                          element.major == rangingBeaconsGlobal.major! &&
                          element.minor == rangingBeaconsGlobal.minor!),
                      name: rangingBeaconsGlobal.name,
                      pictureLink: rangingBeaconsGlobal.pictureLink);

                  ///
                  /// Show notification if nearby
                  ///
                  ///

                  final changeNotifier = context.read<RootChangeNotifier>();

                  beaconsViewModels.addIf(
                      beaconsViewModels.firstWhereOrNull((element) =>
                              _beaconsViewModels.beacon?.major ==
                              element.beacon?.major) ==
                          null,
                      _beaconsViewModels);
                  resultRegion.addIf(
                      resultRegion.firstWhereOrNull((element) =>
                              result.region.major == element.major) ==
                          null,
                      result.region);
                  // regionBeacons.update(result.region, (value) => null);

                  regionBeacons[result.region] = [_beaconsViewModels];
                  if (_beaconsViewModels.beacon != null) {
                    if (_beaconsViewModels.beacon!.accuracy <= 1.0 &&
                        changeNotifier.getPushedNotification[
                                result.region.identifier] ==
                            null &&
                        regionBeacons[result.region] != null) {
                      print('NOTIFICATION!');
                      var remoteNotificationLaporJumlah =
                          firebaseMessaging.RemoteNotification(
                              title: 'New beacons detected!',
                              body: '${_beaconsViewModels.name} is nearest');
                      NotificationService().showNotification(
                          remoteNotificationLaporJumlah,
                          payloadNamaBeacon: jsonEncode({
                            'beacons': regionBeacons[result.region],
                            'region': result.region.toJson
                          }));
                      changeNotifier.setPushedNotification(
                          result.region.identifier, true);
                    } else if (_beaconsViewModels.attendance! &&
                        _beaconsViewModels.beacon!.accuracy <= 30.0 &&
                        !changeNotifier.getAttendance &&
                        regionBeacons[result.region] != null) {
                      /**
                           * Show notification and createAttendance
                           */
                      var remoteNotificationLaporJumlah =
                          const firebaseMessaging.RemoteNotification(
                              title: 'Attendace Marked',
                              body: 'You have attend lab 1');
                      changeNotifier.setAttendance(true);
                      var attendanceModel = AttendanceModel(
                          date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                          time: DateFormat('jm').format(DateTime.now()),
                          user: changeNotifier.getUserModel,
                          id: '${DateFormat('yyyy-MM-dd').format(DateTime.now())}.${changeNotifier.getUserModel.name}',
                          isAttend: true);
                      DatabaseService()
                          .createAttendance(attendanceModel)
                          .whenComplete(() => changeNotifier
                              .setAttendanceModel(attendanceModel));

                      NotificationService().showNotification(
                        remoteNotificationLaporJumlah,
                      );
                    } else if (_beaconsViewModels.attendance! &&
                        _beaconsViewModels.beacon!.accuracy >= 30.0 &&
                        changeNotifier.getAttendance &&
                        regionBeacons[result.region] != null) {
                      var remoteNotificationLaporJumlah =
                          const firebaseMessaging.RemoteNotification(
                              title: 'Attendace Marked',
                              body: 'You have left lab 1');
                      changeNotifier.setAttendance(false);
                      // var attendanceModel = AttendanceModel(
                      //     date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                      //     time: DateFormat('jm').format(DateTime.now()),
                      //     user: changeNotifier.getUserModel,
                      //     id: '${DateFormat('yyyy-MM-dd').format(DateTime.now())}.${changeNotifier.getUserModel.name}',
                      //     isAttend: false);
                      DatabaseService()
                          .updateAttendance(changeNotifier.getAttendanceModel);
                      NotificationService().showNotification(
                        remoteNotificationLaporJumlah,
                      );
                    }
                  }
                }

                regionBeacons.removeWhere((key, value) =>
                    listBeaconsGlobal.firstWhereOrNull(
                        (element) => element.identifier == key.identifier) ==
                    null);

                print('beacons view model: $beaconsViewModels');
                print('Map Region beacons $regionBeacons');
                // var _name = listBeaconsGlobal
                //     .firstWhere(
                //         (element) =>
                //             element.identifier == result.region.identifier,
                //         orElse: () => BeaconEstimote(name: null))
                //     .name;

                // print('Name get from global beacons var $_name');
                // if (_name != null) {
                //   beacons = result.beacons
                //       .map((e) => BeaconViewModel(beacon: e, name: _name))
                //       .toList();
                //   regionBeacons.removeWhere((key, value) =>
                //       (beacons.isEmpty) && beacons.first.name == null);
                //   regionBeacons[result.region] = beacons;

                //   if (beacons.isNotEmpty) {
                //     printInfo(
                //         info:
                //             'Name first beacons detected : ${beacons.first.name}');
                //   }
                //   print('Map Region beacons $regionBeacons');
                // }
              }
            });
          }
        }, onError: (e) {
          printError(info: 'Error listening to region list $e');
        }, cancelOnError: true);
      }
    });

    getFromDatabase();
  }

  pauseScanBeacon() async {
    streamRanging?.pause();
    if (beaconsViewModels.isNotEmpty) {
      setState(() {
        beaconsViewModels.clear();
      });
    }
  }

  @override
  void dispose() {
    // await flutterBeacon.close;
    WidgetsBinding.instance?.removeObserver(this);
    streamBluetooth?.cancel();
    streamRanging?.cancel();
    print('DISPOSE');
    super.dispose();
  }

  listeningBluetoothState() async {
    print('Listening to bluetooth state');
    streamBluetooth = flutterBeacon
        .bluetoothStateChanged()
        .listen((BluetoothState state) async {
      print('Bluetooth state ${state.toString()}');
      controller.updateBluetoothState(state);
      await checkAllRequirements();
    });
  }

  checkAllRequirements() async {
    final bluetoothState = await flutterBeacon.bluetoothState;
    controller.updateBluetoothState(bluetoothState);
    print('BLUETOOTH $bluetoothState');
    if (bluetoothState == BluetoothState.stateOff) {
      handleOpenBluetooth();
    }

    final authorizationStatus = await flutterBeacon.authorizationStatus;
    controller.updateAuthorizationStatus(authorizationStatus);
    print('AUTHORIZATION $authorizationStatus');
    if (authorizationStatus == AuthorizationStatus.notDetermined) {
      await flutterBeacon.requestAuthorization;
    }

    final locationServiceEnabled =
        await flutterBeacon.checkLocationServicesIfEnabled;
    controller.updateLocationService(locationServiceEnabled);
    print('LOCATION SERVICE $locationServiceEnabled');
    if (!locationServiceEnabled) {
      handleOpenLocationSettings();
    }
    if (controller.bluetoothEnabled &&
        controller.authorizationStatusOk &&
        controller.locationServiceEnabled) {
      print('STATE READY');

      print('SCANNING');
      controller.startScanning();

      //var first = await controller.startStream.length;
      initScanBeacon();
      printInfo(info: 'Get start stream value ${controller.getStartScanning}');
    } else {
      print('STATE NOT READY');
      controller.pauseScanning();
      printInfo(info: 'Get pause stream value ${controller.getPauseScanning}');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print('AppLifecycleState = $state');
    if (state == AppLifecycleState.resumed) {
      if (streamBluetooth != null) {
        if (streamBluetooth!.isPaused) {
          streamBluetooth?.resume();
        }
      }
      await checkAllRequirements();
    } else if (state == AppLifecycleState.paused) {
      streamBluetooth?.pause();
    }
  }

  handleOpenBluetooth() async {
    if (Platform.isAndroid) {
      try {
        await flutterBeacon.openBluetoothSettings;
      } on PlatformException catch (e) {
        print(e);
      }
    } else if (Platform.isIOS) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Bluetooth is Off'),
            content:
                const Text('Please enable Bluetooth on Settings > Bluetooth.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  handleOpenLocationSettings() async {
    if (Platform.isAndroid) {
      await flutterBeacon.openLocationSettings;
    } else if (Platform.isIOS) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Location Services Off'),
            content: const Text(
              'Please enable Location Services on Settings > Privacy > Location Services.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void pageChanged(int index) {
    setState(() {
      _bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    print('Current index : $_bottomSelectedIndex');
    print('Previous index : $index');
    _difference = (index - _bottomSelectedIndex).abs();
    print('Difference : $_difference');
    setState(() {
      _bottomSelectedIndex = index;
      if (_difference == 1) {
        print('Animate sikit');
        pageController.animateToPage(index,
            duration: const Duration(milliseconds: 600), curve: Curves.easeOut);
      } else {
        print('JUMP TERUS');
        pageController.jumpToPage(
          index,
        );
      }
    });
  }

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UNIMY ENGINEERING LAB'),
        // centerTitle: true,
      ),
      body: PageView(
        onPageChanged: (index) {
          pageChanged(index);
          //_selectBottomBar(pageKeys[index], index);
        },
        scrollDirection: Axis.horizontal,
        controller: pageController,
        children: [
          HomeScreen(),
          BeaconScreen(isLoading: _isLoading, regionBeacons: regionBeacons),
          const LabBookingScreen(),
          const SettingScreen()
        ],
      ),
      bottomNavigationBar: FloatingNavbar(
        onTap: (int val) {
          bottomTapped(val);
        },
        selectedBackgroundColor: Colors.black,
        backgroundColor: Colors.grey[300],
        currentIndex: _bottomSelectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        items: [
          FloatingNavbarItem(icon: Icons.home),
          FloatingNavbarItem(icon: Icons.list),
          FloatingNavbarItem(icon: Icons.calendar_today),
          FloatingNavbarItem(icon: Icons.settings),
        ],
      ),
    );
  }
}
