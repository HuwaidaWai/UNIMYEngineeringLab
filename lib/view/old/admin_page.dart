import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:smart_engineering_lab/enum/view_state_enum.dart';
import 'package:smart_engineering_lab/main.dart';
import 'package:smart_engineering_lab/model/beacons_model.dart';
import 'package:smart_engineering_lab/provider/root_change_notifier.dart';
import 'package:smart_engineering_lab/services/database_services.dart';
import 'package:smart_engineering_lab/widget/login_button_widget.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

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
  String? path;
  Map dataToUpload = {'destination': null, 'file': null};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget buildImageContainer() {
    final changeNotifier = context.read<RootChangeNotifier>();
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Colors.grey),
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      height: 200,
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      child: changeNotifier.getBeacons == null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                    onPressed: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['jpg', 'png'],
                      );
                      if (result != null) {
                        //File file = File(result.files.single.path);
                        PlatformFile platformFile = result.files.first;
                        setState(() {
                          path = platformFile.path;
                          dataToUpload['destination'] =
                              'beaconsName/${p.basename(path!)}';
                          dataToUpload['file'] = File(path!);
                        });
                        print('This is basename :${p.basename(path!)}');
                        changeNotifier.setBeaconsImage(File(path!));
                      }
                    },
                    child: const Text('Select Picture'))
              ],
            )
          : GestureDetector(
              child: Image.file(changeNotifier.getBeacons!),
              onTap: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['jpg', 'png'],
                );
                if (result != null) {
                  //File file = File(result.files.single.path);
                  PlatformFile platformFile = result.files.first;
                  setState(() {
                    path = platformFile.path;
                    dataToUpload['destination'] =
                        'beaconsName/${p.basename(path!)}';
                    dataToUpload['file'] = File(path!);
                  });
                  print('This is basename :${p.basename(path!)}');
                  changeNotifier.setBeaconsImage(File(path!));
                }
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final changeNotifier = context.watch<RootChangeNotifier>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildImageContainer(),
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
                  child: LoginButtonWidget(
                      // style: ElevatedButton.styleFrom(),
                      onPressed: _onSubmit,
                      child: changeNotifier.getViewState == ViewState.BUSY
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text('Submit'))),
              // LoginButtonWidget(
              //     // style: ElevatedButton.styleFrom(),
              //     onPressed: _onDelete,
              //     child: const Text('Delete'))
            ],
          ),
        ),
      ),
    );
  }

  _onDelete() async {
    try {} catch (e) {
      print('OnDelete $e');
    }
  }

  _onSubmit() async {
    final changeNotifier = context.read<RootChangeNotifier>();
    Map data = {
      'identifier': idTextController.text,
      'name': nameTextController.text,
      'uuid': uuidTextController.text,
      'major': int.parse(majorTextController.text),
      'minor': int.parse(minorTextController.text)
    };
    var beaconEstimote = BeaconEstimote.fromJson(data);

    DatabaseService().createBeacon(beaconEstimote, changeNotifier, File(path!));
    Navigator.of(context).pop();
  }
}
