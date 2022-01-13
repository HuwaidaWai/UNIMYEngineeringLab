import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_engineering_lab/helper/rssi_signal_helper.dart';
import 'package:smart_engineering_lab/model/beacons_model.dart';
import 'package:smart_engineering_lab/model/beacons_view_model.dart';
import 'package:smart_engineering_lab/model/region_view_model.dart';
import 'package:smart_engineering_lab/model/user_model.dart';
import 'package:smart_engineering_lab/services/database_services.dart';
import 'package:smart_engineering_lab/view/beacon_view/single_beacon_screen.dart';
import 'package:smart_engineering_lab/view/old/admin_page.dart';
import 'package:smart_engineering_lab/view/old/lab_module_views.dart';
import 'package:smart_engineering_lab/view/old/requirement_state_controller.dart';

class BeaconScreen extends StatefulWidget {
  // final Map<RegionViewModel, List<BeaconViewModel>> regionBeacons;
  final Map<Region, List<BeaconViewModel>> regionBeacons;
  final bool isLoading;
  const BeaconScreen(
      {Key? key, required this.regionBeacons, required this.isLoading})
      : super(key: key);

  @override
  _BeaconScreenState createState() => _BeaconScreenState();
}

class _BeaconScreenState extends State<BeaconScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    //TODO: Fix ui for the ranging beacon screen
    super.initState();
  }
  // var listBeaconsGlobal = <BeaconEstimote>[];
  // final controller = Get.find<RequirementStateController>();
  // StreamSubscription<BluetoothState>? streamBluetooth;
  // StreamSubscription<RangingResult>? streamRanging;
  // final regionBeacons = <Region, List<BeaconViewModel>>{};
  // var beacons = <BeaconViewModel>[];
  // var regions = <Region>[];

  // bool _isLoading = true;
  // @override
  // void initState() {
  //   WidgetsBinding.instance?.addObserver(this);

  //   listeningBluetoothState();
  //   print('Controller initialized : ${controller.initialized}');
  //   controller.startStream.listen((flag) {
  //     printInfo(info: 'start stream $flag');
  //     if (flag == true) {
  //       initScanBeacon();
  //     }
  //   }, onDone: () {
  //     print('Done start subscription');
  //   });

  //   controller.pauseStream.listen((flag) {
  //     printInfo(info: 'pause stream $flag');
  //     if (flag == true) {
  //       pauseScanBeacon();
  //     }
  //   }, onDone: () {
  //     print('Done pause subscription');
  //   });
  //   print('INIT STATE');
  //   super.initState();
  // }

  // getFromDatabase() {
  //   DatabaseService().listOfBeacons.listen((listBeacons) {
  //     print('listBeacons $listBeacons');
  //     if (listBeacons.isNotEmpty) {
  //       setState(() {
  //         listBeaconsGlobal = listBeacons;
  //       });
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
  //   });
  // }

  // initScanBeacon() async {
  //   print('INITSCANNING');
  //   await flutterBeacon.initializeScanning;
  //   print('Test: '
  //       'RETURNED, authorizationStatusOk=${controller.authorizationStatusOk}, '
  //       'locationServiceEnabled=${controller.locationServiceEnabled}, '
  //       'bluetoothEnabled=${controller.bluetoothEnabled}');
  //   if (!controller.authorizationStatusOk ||
  //       !controller.locationServiceEnabled ||
  //       !controller.bluetoothEnabled) {
  //     print(
  //         'RETURNED, authorizationStatusOk=${controller.authorizationStatusOk}, '
  //         'locationServiceEnabled=${controller.locationServiceEnabled}, '
  //         'bluetoothEnabled=${controller.bluetoothEnabled}');
  //     return;
  //   }

  //   if (streamRanging != null) {
  //     if (streamRanging!.isPaused) {
  //       streamRanging?.resume();
  //       return;
  //     }
  //   }

  //   controller.regionList.listen((event) {
  //     if (event.isNotEmpty) {
  //       streamRanging =
  //           flutterBeacon.ranging(event).listen((RangingResult result) {
  //         print('Ranging Result $result');
  //         if (mounted) {
  //           setState(() {
  //             var _name = listBeaconsGlobal
  //                 .firstWhere(
  //                     (element) =>
  //                         element.identifier == result.region.identifier,
  //                     orElse: () => BeaconEstimote(name: null))
  //                 .name;
  //             if (_name != null) {
  //               beacons = result.beacons
  //                   .map((e) => BeaconViewModel(beacon: e, name: _name))
  //                   .toList();
  //               regionBeacons[result.region] = beacons;
  //               print('Map Region beacons $regionBeacons');
  //             }
  //           });
  //         }
  //       }, onError: (e) {
  //         printError(info: 'Error listening to region list $e');
  //       }, cancelOnError: true);
  //       print(streamRanging!.reactive.value);
  //     }
  //   });

  //   getFromDatabase();
  // }

  // pauseScanBeacon() async {
  //   streamRanging?.pause();
  //   if (beacons.isNotEmpty) {
  //     setState(() {
  //       beacons.clear();
  //     });
  //   }
  // }

  // @override
  // void dispose() async {
  //   // await flutterBeacon.close;

  //   streamBluetooth?.cancel();
  //   streamRanging?.cancel();
  //   print('DISPOSE');
  //   super.dispose();
  // }

  // listeningBluetoothState() async {
  //   print('Listening to bluetooth state');
  //   streamBluetooth = flutterBeacon
  //       .bluetoothStateChanged()
  //       .listen((BluetoothState state) async {
  //     print('Bluetooth ${state.toString()}');
  //     controller.updateBluetoothState(state);
  //     await checkAllRequirements();
  //   });
  // }

  // checkAllRequirements() async {
  //   final bluetoothState = await flutterBeacon.bluetoothState;
  //   controller.updateBluetoothState(bluetoothState);
  //   print('BLUETOOTH $bluetoothState');
  //   if (bluetoothState == BluetoothState.stateOff) {
  //     handleOpenBluetooth();
  //   }

  //   final authorizationStatus = await flutterBeacon.authorizationStatus;
  //   controller.updateAuthorizationStatus(authorizationStatus);
  //   print('AUTHORIZATION $authorizationStatus');
  //   if (authorizationStatus == AuthorizationStatus.notDetermined) {
  //     await flutterBeacon.requestAuthorization;
  //   }

  //   final locationServiceEnabled =
  //       await flutterBeacon.checkLocationServicesIfEnabled;
  //   controller.updateLocationService(locationServiceEnabled);
  //   print('LOCATION SERVICE $locationServiceEnabled');
  //   if (!locationServiceEnabled) {
  //     handleOpenLocationSettings();
  //   }
  //   if (controller.bluetoothEnabled &&
  //       controller.authorizationStatusOk &&
  //       controller.locationServiceEnabled) {
  //     print('STATE READY');

  //     print('SCANNING');
  //     controller.startScanning();
  //     // initScanBeacon();
  //   } else {
  //     print('STATE NOT READY');
  //     controller.pauseScanning();
  //   }
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) async {
  //   print('AppLifecycleState = $state');
  //   if (state == AppLifecycleState.resumed) {
  //     if (streamBluetooth != null) {
  //       if (streamBluetooth!.isPaused) {
  //         streamBluetooth?.resume();
  //       }
  //     }
  //     await checkAllRequirements();
  //   } else if (state == AppLifecycleState.paused) {
  //     streamBluetooth?.pause();
  //   }
  // }

  // handleOpenBluetooth() async {
  //   if (Platform.isAndroid) {
  //     try {
  //       await flutterBeacon.openBluetoothSettings;
  //     } on PlatformException catch (e) {
  //       print(e);
  //     }
  //   } else if (Platform.isIOS) {
  //     await showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: const Text('Bluetooth is Off'),
  //           content:
  //               const Text('Please enable Bluetooth on Settings > Bluetooth.'),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: const Text('OK'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }

  // handleOpenLocationSettings() async {
  //   if (Platform.isAndroid) {
  //     await flutterBeacon.openLocationSettings;
  //   } else if (Platform.isIOS) {
  //     await showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: const Text('Location Services Off'),
  //           content: const Text(
  //             'Please enable Location Services on Settings > Privacy > Location Services.',
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: const Text('OK'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 36.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'Table Beacons',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        'Choose your table section',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                StreamBuilder<UserModel>(
                    stream: DatabaseService(uid: firebaseUser.uid).readUserName,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: snapshot.data!.role == 'STUDENT'
                              ? const SizedBox()
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(elevation: 0),
                                  onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => const Admin())),
                                  child: Row(
                                    children: const [
                                      Text('Add',
                                          style: TextStyle(
                                            fontSize: 18,
                                          )),
                                      Icon(Icons.add)
                                    ],
                                  ),
                                ),
                        );
                      } else {
                        return Container();
                      }
                    })
              ],
            ),
            widget.regionBeacons.isEmpty && widget.isLoading == true
                ? const Center(child: CircularProgressIndicator())
                : widget.regionBeacons.isEmpty && widget.isLoading == false
                    ? const Center(child: Text('No Beacons'))
                    : GridView.count(
                        childAspectRatio: 0.5,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        primary: false,
                        padding: const EdgeInsets.all(20),
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 10,
                        crossAxisCount: 2,
                        children: widget.regionBeacons.entries.map(
                          (beacon) {
                            return GestureDetector(
                              onTap: () {
                                if (beacon.value.isNotEmpty) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => SingleBeaconScreen(
                                          region: beacon.key,
                                          beaconViewModel:
                                              beacon.value.first)));
                                }
                              },
                              child: Card(
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: beacon.value.isEmpty
                                      ? const Text('Connecting to beacons')
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8)),
                                                  color: Colors.green),
                                              height: 8,
                                              width: 8,
                                            ),
                                            ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: beacon.value.length,
                                                itemBuilder: (context, i) {
                                                  return Column(
                                                    children: [
                                                      Image.network(
                                                        beacon.value[i]
                                                            .pictureLink!,
                                                        height: 80,
                                                        width: 80,
                                                      ),
                                                      Text(
                                                        beacon.value[i].name!,
                                                      ),
                                                      Text(RssiSignal
                                                          .rssiTranslator(beacon
                                                              .value[i]
                                                              .beacon!
                                                              .rssi)),
                                                      Text(
                                                          '${beacon.value[i].beacon!.accuracy.toString()} m'),
                                                    ],
                                                  );
                                                }),
                                          ],
                                        ),
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      )
            // : ListView(
            //     physics: const ClampingScrollPhysics(),
            //     shrinkWrap: true,
            //     children: ListTile.divideTiles(
            //       context: context,
            //       tiles: widget.regionBeacons.values.map(
            //         (beacon) {
            //           if (beacon.isNotEmpty) {
            //             return ListTile(
            //               onTap: () {
            //                 Navigator.push(context,
            //                     MaterialPageRoute(builder: (conttext) {
            //                   return const LabModuleViews();
            //                 }));
            //               },
            //               contentPadding: const EdgeInsets.symmetric(
            //                   horizontal: 20, vertical: 30),
            //               shape: const RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.all(
            //                       Radius.circular(16))),
            //               tileColor: Colors.redAccent,
            //               title: Column(
            //                 crossAxisAlignment:
            //                     CrossAxisAlignment.start,
            //                 children: [
            //                   Text(
            //                     '${beacon.first.name}',
            //                     style: const TextStyle(
            //                         fontSize: 18.0,
            //                         color: Colors.white),
            //                   ),
            //                   Text(
            //                     '(${beacon.first.beacon!.proximityUUID})',
            //                     style: const TextStyle(
            //                         fontSize: 12.0,
            //                         color: Colors.white),
            //                   ),
            //                 ],
            //               ),
            //               subtitle: Column(
            //                 crossAxisAlignment:
            //                     CrossAxisAlignment.start,
            //                 children: [
            //                   Row(
            //                     mainAxisSize: MainAxisSize.max,
            //                     children: <Widget>[
            //                       // Flexible(
            //                       //   child: Text(
            //                       //     'Name: ${beacon.name}',
            //                       //     style: const TextStyle(
            //                       //         fontSize: 13.0, color: Colors.white),
            //                       //   ),
            //                       //   flex: 1,
            //                       //   fit: FlexFit.tight,
            //                       // ),
            //                       Flexible(
            //                         child: Text(
            //                           'Major: ${beacon.first.beacon!.major}\nMinor: ${beacon.first.beacon!.minor}',
            //                           style: const TextStyle(
            //                               fontSize: 13.0,
            //                               color: Colors.white),
            //                         ),
            //                         flex: 1,
            //                         fit: FlexFit.tight,
            //                       ),
            //                       Flexible(
            //                         child: Text(
            //                           'Accuracy: ${beacon.first.beacon!.accuracy}m\nRSSI: ${beacon.first.beacon!.rssi}',
            //                           style: const TextStyle(
            //                               fontSize: 13.0,
            //                               color: Colors.white),
            //                         ),
            //                         flex: 2,
            //                         fit: FlexFit.tight,
            //                       ),
            //                     ],
            //                   ),
            //                   Padding(
            //                     padding:
            //                         const EdgeInsets.only(top: 8.0),
            //                     child: Text(
            //                       'Signal : ${RssiSignal.rssiTranslator(beacon.first.beacon!.rssi)}',
            //                       style: const TextStyle(
            //                           fontSize: 13.0,
            //                           color: Colors.white),
            //                     ),
            //                   )
            //                 ],
            //               ),
            //             );
            //           } else {
            //             return const Text('Getting Beacons data .. ');
            //           }
            //         },
            //       ),
            //     ).toList(),
            //   ),
          ],
        ),
      ),
    );
  }
}
