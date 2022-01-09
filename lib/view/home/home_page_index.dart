import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart'
    as firebaseMessaging;
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_engineering_lab/model/beacons_model.dart';
import 'package:smart_engineering_lab/model/beacons_view_model.dart';
import 'package:smart_engineering_lab/provider/root_change_notifier.dart';
import 'package:smart_engineering_lab/services/database_services.dart';
import 'package:smart_engineering_lab/services/local_notification_services.dart';
import 'package:smart_engineering_lab/view/home/beacons_screen.dart';
import 'package:smart_engineering_lab/view/home/home_screen.dart';
import 'package:smart_engineering_lab/view/home/lab_booking_screen.dart';
import 'package:smart_engineering_lab/view/home/profile_screen.dart';
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
  var beacons = <BeaconViewModel>[];
  var regions = <Region>[];

  bool _isLoading = true;
  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);

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
        if (changeNotifier.getPushedNotification == false) {
          var remoteNotificationLaporJumlah =
              firebaseMessaging.RemoteNotification(
                  title: 'New beacons detected!',
                  body: 'There are ${listBeacons.length} nearest');
          NotificationService().showNotification(
            remoteNotificationLaporJumlah,
          );
          changeNotifier.setPushedNotification(true);
        }

        setState(() {
          listBeaconsGlobal = listBeacons;
        });

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

    controller.regionList.listen((event) {
      if (event.isNotEmpty) {
        streamRanging =
            flutterBeacon.ranging(event).listen((RangingResult result) {
          print('Ranging Result $result');
          if (mounted) {
            setState(() {
              print('Changes $listBeaconsGlobal');
              var _name = listBeaconsGlobal
                  .firstWhere(
                      (element) =>
                          element.identifier == result.region.identifier,
                      orElse: () => BeaconEstimote(name: null))
                  .name;
              //Found Name
              print('Name : $_name');
              if (_name != null) {
                beacons = result.beacons
                    .map((e) => BeaconViewModel(beacon: e, name: _name))
                    .toList();
                regionBeacons[result.region] = beacons;
                print('Map Region beacons $regionBeacons');
                _name = null;
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
    if (beacons.isNotEmpty) {
      setState(() {
        beacons.clear();
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
    final changeNotifier = context.read<RootChangeNotifier>();
    return Scaffold(
      body: PageView(
        onPageChanged: (index) {
          pageChanged(index);
          //_selectBottomBar(pageKeys[index], index);
        },
        scrollDirection: Axis.horizontal,
        controller: pageController,
        children: [
          const HomeScreen(),
          StreamBuilder<List<BeaconEstimote>>(
              stream: null,
              builder: (context, snapshot) {
                return BeaconScreen(
                    isLoading: _isLoading, regionBeacons: regionBeacons);
              }),
          const LabBookingScreen(),
          const ProfileScreen()
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
          FloatingNavbarItem(icon: Icons.account_circle),
        ],
      ),
    );
  }
}
