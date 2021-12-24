import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_engineering_lab/LoginScreen.dart';
import 'package:flutter_beacon/flutter_beacon.dart';

Future<void> main() async {
  runApp(const MyApp());
  var _streamRanging;
  var _streamMonitoring;

  try{
    await flutterBeacon.initializeAndCheckScanning;
  } on PlatformException catch(e){
      print("iBeacon library failed to initialize, check your code again");
  }
  final regions = <Region>[];
  regions.add(Region(
    identifier: 'b4aa8223b45d32ad90204da9b2adef1d',
    proximityUUID: 'b9407f30-f5f8-466e-aff9-25556b57fe7d'
  ));
  // to start ranging beacons
  _streamRanging = flutterBeacon.ranging(regions).listen((RangingResult result) {
    // result contains a region and list of beacons found
    // list can be empty if no matching beacons were found in range
  });

// to stop ranging beacons
  _streamRanging.cancel();

  // to start monitoring beacons
  _streamMonitoring = flutterBeacon.monitoring(regions).listen((MonitoringResult result) {
    // result contains a region, event type and event state
  });

// to stop monitoring beacons
  _streamMonitoring.cancel();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UNIMY ENGINEERING LAB',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.red,
      ),
     home: const MyHomePage(title: 'UNIMY ENGINEERING LAB'),

      //home: LoginScreen(),
      debugShowCheckedModeBanner: false,

    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Login'),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
          },
        ),
      ),
    );
  }
}

