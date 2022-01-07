import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_engineering_lab/model/beacons_model.dart';

class Admin extends StatefulWidget {
  final GetStorage storage;
  const Admin({Key? key, required this.storage}) : super(key: key);

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final nameTextController = TextEditingController();
  final idTextController = TextEditingController();
  final uuidTextController = TextEditingController();
  final majorTextController = TextEditingController();
  final minorTextController = TextEditingController();
  // final storage = GetStorage('iBeacons');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var beacons = widget.storage.read('beacons');

    print('Read from storage : $beacons');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: nameTextController,
                decoration: const InputDecoration(hintText: 'Name'),
              ),
              TextFormField(
                controller: idTextController,
                decoration: const InputDecoration(hintText: 'Identifier'),
              ),
              TextFormField(
                controller: uuidTextController,
                decoration: const InputDecoration(hintText: 'ProximityUUID'),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: majorTextController,
                decoration: const InputDecoration(hintText: 'Major'),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Minor'),
                controller: minorTextController,
              ),
              Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  width: double.infinity,
                  child: ElevatedButton(
                      // style: ElevatedButton.styleFrom(),
                      onPressed: _onSubmit,
                      child: const Text('Submit'))),
              ElevatedButton(
                  // style: ElevatedButton.styleFrom(),
                  onPressed: _onDelete,
                  child: const Text('Delete'))
            ],
          ),
        ),
      ),
    );
  }

  _onDelete() async {
    try {
      await widget.storage.remove('beacons');
    } catch (e) {
      print('OnDelete $e');
    }
  }

  _onSubmit() async {
    var beacons = widget.storage.read('beacons');
    var listBeacons = [];
    print('Read from storage : $beacons');
    if (beacons != null) {
      listBeacons = beacons;
      // var beaconsDecoded = jsonDecode(beacons) as List;
      // listBeacons = beaconsDecoded.map((e) => e).toList();
    }
    Map data = {
      'identifier': idTextController.text,
      'name': nameTextController.text,
      'uuid': uuidTextController.text,
      'major': int.parse(majorTextController.text),
      'minor': int.parse(minorTextController.text)
    };

    listBeacons.add(data);

    // String encoded = json.encode(listBeacons);

    // Map dataToStorage = {'data': listBeacons};
    // var encoded = jsonEncode(dataToStorage);
    print(listBeacons);
    await widget.storage.write('beacons', listBeacons);
    Navigator.pop(context);
  }
}
