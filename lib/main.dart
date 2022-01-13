import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:smart_engineering_lab/constant/color_constant.dart';
import 'package:smart_engineering_lab/services/database_services.dart';
import 'package:smart_engineering_lab/services/local_notification_services.dart';
import 'package:smart_engineering_lab/view/home/home_page_index.dart';
import 'package:smart_engineering_lab/login_screens.dart';
import 'package:smart_engineering_lab/helper/rssi_signal_helper.dart';
import 'package:smart_engineering_lab/model/beacons_model.dart';
import 'package:smart_engineering_lab/model/beacons_view_model.dart';
import 'package:smart_engineering_lab/provider/root_change_notifier.dart';
import 'package:smart_engineering_lab/view/old/requirement_state_controller.dart';
import 'package:smart_engineering_lab/services/auth_service.dart';
import 'package:smart_engineering_lab/view/old/admin_page.dart';
import 'package:smart_engineering_lab/view/old/app_scanning.dart';
import 'package:smart_engineering_lab/view/old/collapsing_navigation_drawer.dart';
import 'package:smart_engineering_lab/view/old/home_page.dart';
import 'package:smart_engineering_lab/view/old/custom_navigation_drawer.dart';
import 'package:smart_engineering_lab/view/old/lab_module_views.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(RequirementStateController());
    final themeData = Theme.of(context);
    const primary = Color(0xffd10e48);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RootChangeNotifier()),
        Provider(
          create: (_) => AuthService(FirebaseAuth.instance),
        ),
        StreamProvider(
            create: (context) => context.read<AuthService>().authStateChanges,
            initialData: null)
      ],
      child: MaterialApp(
        title: 'UNIMY ENGINEERING LAB',
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: colorCustom,
          appBarTheme: themeData.appBarTheme.copyWith(
            elevation: 0.5,
            color: const Color(0xffd10e48),
            actionsIconTheme: themeData.primaryIconTheme.copyWith(
              color: primary,
            ),
            iconTheme: themeData.primaryIconTheme.copyWith(
              color: primary,
            ),
            textTheme: themeData.primaryTextTheme.copyWith(
              headline6: themeData.textTheme.headline6?.copyWith(
                color: primary,
              ),
            ),
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
        ),
        home: const AuthWrapper(),
        // home: HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    print('This is firebase user : $firebaseUser');
    if (firebaseUser != null) {
      DatabaseService(uid: firebaseUser.uid).readUserName;
      return const HomePageIndex();
    }
    return const LoginScreen();
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
//   final storage = GetStorage('iBeacons');
//   var listBeacons = <BeaconEstimote>[];
//   final controller = Get.find<RequirementStateController>();
//   StreamSubscription<BluetoothState>? _streamBluetooth;

//   StreamSubscription<RangingResult>? _streamRanging;
//   final _regionBeacons = <Region, List<BeaconViewModel>>{};
//   var _beacons = <BeaconViewModel>[];
//   var regions = <Region>[];

//   bool _isLoading = true;
//   @override
//   void initState() {
//     WidgetsBinding.instance?.addObserver(this);

//     listeningState();
//     super.initState();

//     controller.startStream.listen((flag) {
//       printInfo(info: 'startstream $flag');
//       if (flag == true) {
//         initScanBeacon();
//       }
//     });

//     controller.pauseStream.listen((flag) {
//       if (flag == true) {
//         pauseScanBeacon();
//       }
//     });
//   }

//   initStorage() async {
//     await GetStorage.init('iBeacons');

//     var beacons = storage.read('beacons');
//     print('List Beacons $beacons');
//     if (beacons != null) {
//       for (var element in beacons) {
//         listBeacons.add(BeaconEstimote.fromJson(element));
//       }
//       // listBeacons = beacons.map((e) => BeaconEstimote.fromJson(e)).toList();
//       for (var e in listBeacons) {
//         regions.add(Region(
//             identifier: e.identifier!,
//             proximityUUID: e.uuid,
//             major: e.major,
//             minor: e.minor));
//       }
//       controller.updateRegionsList(regions);
//     } else {
//       setState(() {
//         _isLoading = false;
//       });
//     }

//     // <Region>[
//     //   //  Region( ///Mint
//     //   //     identifier: 'b4aa8223b45d32ad90204da9b2adef1d',
//     //   //     proximityUUID: 'b9407f30-f5f8-466e-aff9-25556b57fe7d',
//     //   //     major: 44515,
//     //   //     minor: 60728,
//     //   //   ),
//     //   Region(
//     //     ///Sky123
//     //     identifier: '90531162000f5deb643c5a7de2539b02',
//     //     proximityUUID: 'b9407f30-f5f8-466e-aff9-25556b57fe6d',
//     //     major: 8925,
//     //     minor: 10345,
//     //   ),
//     //   // Region( ///Blueberry
//     //   //   identifier: '1599f9a4e04485eae967c17c6b940510',
//     //   //   proximityUUID: 'b9407f30-f5f8-466e-aff9-25556b57fe7d',
//     //   //   major: 27698,
//     //   //   minor: 53676,
//     //   // ),
//     // ];

//     storage.listen(() {
//       var list = storage.read('beacons') as List;
//       if (list != null) {
//         for (var e in listBeacons) {
//           regions.add(Region(
//               identifier: e.identifier!,
//               proximityUUID: e.uuid,
//               major: e.major,
//               minor: e.minor));
//         }
//         print('In listen callback $list');
//         listBeacons = list.map((e) => BeaconEstimote.fromJson(e)).toList();
//         print('listBeacons listen $listBeacons');
//       }
//     });
//   }

//   initScanBeacon() async {
//     await flutterBeacon.initializeScanning;
//     print('Test: '
//         'RETURNED, authorizationStatusOk=${controller.authorizationStatusOk}, '
//         'locationServiceEnabled=${controller.locationServiceEnabled}, '
//         'bluetoothEnabled=${controller.bluetoothEnabled}');
//     if (!controller.authorizationStatusOk ||
//         !controller.locationServiceEnabled ||
//         !controller.bluetoothEnabled) {
//       print(
//           'RETURNED, authorizationStatusOk=${controller.authorizationStatusOk}, '
//           'locationServiceEnabled=${controller.locationServiceEnabled}, '
//           'bluetoothEnabled=${controller.bluetoothEnabled}');
//       return;
//     }

//     if (_streamRanging != null) {
//       if (_streamRanging!.isPaused) {
//         _streamRanging?.resume();
//         return;
//       }
//     }

//     controller.regionList.listen((event) {
//       printInfo(info: '$event');
//       if (event.isNotEmpty) {
//         _streamRanging =
//             flutterBeacon.ranging(event).listen((RangingResult result) {
//           print('Ranging Result $result');
//           if (mounted) {
//             setState(() {
//               var _name = listBeacons
//                   .firstWhere(
//                       (element) =>
//                           element.identifier == result.region.identifier,
//                       orElse: () => BeaconEstimote(name: null))
//                   .name;
//               if (_name != null) {
//                 _beacons = result.beacons
//                     .map((e) => BeaconViewModel(beacon: e, name: _name))
//                     .toList();
//                 _regionBeacons[result.region] = _beacons;
//                 print('Map Region beacons $_regionBeacons');
//               }

//               // _regionBeacons.values.forEach((list) {
//               //   list.forEach((element) {
//               //     var beaconEstimate = listBeacons.firstWhere(
//               //       (beacon) => beacon.identifier == result.region.identifier,
//               //     );
//               //     log('FOR BEACON ${beaconEstimate.identifier}, NAME: ${beaconEstimate.name}');
//               //     _beacons.add(BeaconViewModel(
//               //         beacon: element, name: beaconEstimate.name));
//               //   });
//               //   // _beacons.addAll(list);
//               // });
//               // _beacons.sort(_compareParameters);
//             });
//           }
//         });
//       }
//     });

//     await initStorage();

    // _streamMonitor =
    
    //     flutterBeacon.monitoring(regions).listen((MonitoringResult event) {
    //       event.monitoringState
    //   print('Monitoring Result ${event.monitoringState.toString()}');
    // });
//   }

//   pauseScanBeacon() async {
//     _streamRanging?.pause();
//     if (_beacons.isNotEmpty) {
//       setState(() {
//         _beacons.clear();
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _streamBluetooth?.cancel();
//     _streamRanging?.cancel();
//     super.dispose();
//   }

//   listeningState() async {
//     print('Listening to bluetooth state');
//     _streamBluetooth = flutterBeacon
//         .bluetoothStateChanged()
//         .listen((BluetoothState state) async {
//       controller.updateBluetoothState(state);
//       await checkAllRequirements();
//     });
//   }

//   checkAllRequirements() async {
//     final bluetoothState = await flutterBeacon.bluetoothState;
//     controller.updateBluetoothState(bluetoothState);
//     print('BLUETOOTH $bluetoothState');
//     if (bluetoothState == BluetoothState.stateOff) {
//       handleOpenBluetooth();
//     }

//     final authorizationStatus = await flutterBeacon.authorizationStatus;
//     controller.updateAuthorizationStatus(authorizationStatus);
//     print('AUTHORIZATION $authorizationStatus');
//     if (authorizationStatus == AuthorizationStatus.notDetermined) {
//       await flutterBeacon.requestAuthorization;
//     }

//     final locationServiceEnabled =
//         await flutterBeacon.checkLocationServicesIfEnabled;
//     controller.updateLocationService(locationServiceEnabled);
//     print('LOCATION SERVICE $locationServiceEnabled');
//     if (!locationServiceEnabled) {
//       handleOpenLocationSettings();
//     }
//     if (controller.bluetoothEnabled &&
//         controller.authorizationStatusOk &&
//         controller.locationServiceEnabled) {
//       print('STATE READY');

//       print('SCANNING');
//       controller.startScanning();
//     } else {
//       print('STATE NOT READY');
//       controller.pauseScanning();
//     }
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) async {
//     print('AppLifecycleState = $state');
//     if (state == AppLifecycleState.resumed) {
//       if (_streamBluetooth != null) {
//         if (_streamBluetooth!.isPaused) {
//           _streamBluetooth?.resume();
//         }
//       }
//       await checkAllRequirements();
//     } else if (state == AppLifecycleState.paused) {
//       _streamBluetooth?.pause();
//     }
//   }

//   handleOpenBluetooth() async {
//     if (Platform.isAndroid) {
//       try {
//         await flutterBeacon.openBluetoothSettings;
//       } on PlatformException catch (e) {
//         print(e);
//       }
//     } else if (Platform.isIOS) {
//       await showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: const Text('Bluetooth is Off'),
//             content:
//                 const Text('Please enable Bluetooth on Settings > Bluetooth.'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   handleOpenLocationSettings() async {
//     if (Platform.isAndroid) {
//       await flutterBeacon.openLocationSettings;
//     } else if (Platform.isIOS) {
//       await showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: const Text('Location Services Off'),
//             content: const Text(
//               'Please enable Location Services on Settings > Privacy > Location Services.',
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         centerTitle: true,
//       ),
//       bottomSheet: Container(
//         decoration: BoxDecoration(
//             color: Colors.grey[200],
//             // boxShadow: [],
//             borderRadius:
//                 const BorderRadius.vertical(top: Radius.circular(16.0))),
//         height: height * 0.2,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             ElevatedButton(
//               child: const Text('Admin'),
//               onPressed: () async {
//                 // var isChange = await Navigator.push(
//                 //     context,
//                 //     MaterialPageRoute(
//                 //         builder: (context) => Admin(
//                 //               storage: storage,
//                 //             )));
//               },
//             ),
//             ElevatedButton(
//               child: const Text('Testing'),
//               onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => const HomePage()));
//               },
//             ),
//           ],
//         ),
//       ),
//       //drawer: CollapsingNavigationDrawer(),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
//           child: _regionBeacons.isEmpty && _isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : _regionBeacons.isEmpty && !_isLoading
//                   ? const Center(child: Text('No Beacons'))
//                   : ListView(
//                       shrinkWrap: true,
//                       children: ListTile.divideTiles(
//                         context: context,
//                         tiles: _regionBeacons.values.map(
//                           (beacon) {
//                             if (beacon.isNotEmpty) {
//                               return ListTile(
//                                 onTap: () {
//                                   Navigator.push(context,
//                                       MaterialPageRoute(builder: (conttext) {
//                                     return const LabModuleViews();
//                                   }));
//                                 },
//                                 contentPadding: const EdgeInsets.symmetric(
//                                     horizontal: 20, vertical: 30),
//                                 shape: const RoundedRectangleBorder(
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(16))),
//                                 tileColor: Colors.redAccent,
//                                 title: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       '${beacon.first.name}',
//                                       style: const TextStyle(
//                                           fontSize: 18.0, color: Colors.white),
//                                     ),
//                                     Text(
//                                       '(${beacon.first.beacon!.proximityUUID})',
//                                       style: const TextStyle(
//                                           fontSize: 12.0, color: Colors.white),
//                                     ),
//                                   ],
//                                 ),
//                                 subtitle: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       mainAxisSize: MainAxisSize.max,
//                                       children: <Widget>[
//                                         // Flexible(
//                                         //   child: Text(
//                                         //     'Name: ${beacon.name}',
//                                         //     style: const TextStyle(
//                                         //         fontSize: 13.0, color: Colors.white),
//                                         //   ),
//                                         //   flex: 1,
//                                         //   fit: FlexFit.tight,
//                                         // ),
//                                         Flexible(
//                                           child: Text(
//                                             'Major: ${beacon.first.beacon!.major}\nMinor: ${beacon.first.beacon!.minor}',
//                                             style: const TextStyle(
//                                                 fontSize: 13.0,
//                                                 color: Colors.white),
//                                           ),
//                                           flex: 1,
//                                           fit: FlexFit.tight,
//                                         ),
//                                         Flexible(
//                                           child: Text(
//                                             'Accuracy: ${beacon.first.beacon!.accuracy}m\nRSSI: ${beacon.first.beacon!.rssi}',
//                                             style: const TextStyle(
//                                                 fontSize: 13.0,
//                                                 color: Colors.white),
//                                           ),
//                                           flex: 2,
//                                           fit: FlexFit.tight,
//                                         ),
//                                       ],
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.only(top: 8.0),
//                                       child: Text(
//                                         'Signal : ${RssiSignal.rssiTranslator(beacon.first.beacon!.rssi)}',
//                                         style: const TextStyle(
//                                             fontSize: 13.0,
//                                             color: Colors.white),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               );
//                             } else {
//                               return const Text('Getting Beacons data .. ');
//                             }
//                           },
//                         ),
//                       ).toList(),
//                     ),
//           // StreamBuilder<List<Region>>(
//           //     stream: controller.regionList,
//           //     builder: (context, snapshot) {
//           //       if (snapshot.hasData) {
//           //         return ListView.builder(
//           //             shrinkWrap: true,
//           //             itemCount: snapshot.data!.length,
//           //             itemBuilder: (context, index) {
//           //               return Card(
//           //                 child: Column(
//           //                   children: [
//           //                     Text(snapshot.data![index].identifier),
//           //                     Text(snapshot.data![index].proximityUUID!),
//           //                     Text(snapshot.data![index].major.toString()),
//           //                     Text(snapshot.data![index].minor.toString()),
//           //                   ],
//           //                 ),
//           //               );
//           //             });
//           //       } else {
//           //         return const CircularProgressIndicator();
//           //       }
//           //     }),
//         ),
//       ),
//     );
//   }
// }
