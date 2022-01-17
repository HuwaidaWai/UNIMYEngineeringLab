import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:smart_engineering_lab/constant/color_constant.dart';
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
  final _formKey = GlobalKey<FormState>();
  // final storage = GetStorage('iBeacons');
  String? path;
  Map dataToUpload = {'destination': null, 'file': null};

  @override
  void initState() {
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const FaIcon(FontAwesomeIcons.chevronLeft))
                    ],
                  ),
                ),
                buildImageContainer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*This field is required';
                      }
                      return null;
                    },
                    controller: nameTextController,
                    decoration: InputDecoration(
                        hintText: 'Name',
                        hintStyle: subtitleStyle2Small,
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(width: 1.0))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*This field is required';
                      }
                      return null;
                    },
                    controller: idTextController,
                    decoration: InputDecoration(
                        hintText: 'Identifier',
                        hintStyle: subtitleStyle2Small,
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(width: 1.0))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*This field is required';
                      }
                      return null;
                    },
                    controller: uuidTextController,
                    decoration: InputDecoration(
                        hintText: 'ProximityUUID',
                        hintStyle: subtitleStyle2Small,
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(width: 1.0))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*This field is required';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    controller: majorTextController,
                    decoration: InputDecoration(
                        hintText: 'Major',
                        hintStyle: subtitleStyle2Small,
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(width: 1.0))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*This field is required';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: 'Minor',
                        hintStyle: subtitleStyle2Small,
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(width: 1.0))),
                    controller: minorTextController,
                  ),
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
      ),
    );
  }

  _onDelete() async {
    try {} catch (e) {
      print('OnDelete $e');
    }
  }

  _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final changeNotifier = context.read<RootChangeNotifier>();
      Map data = {
        'identifier': idTextController.text,
        'name': nameTextController.text,
        'uuid': uuidTextController.text,
        'major': int.parse(majorTextController.text),
        'minor': int.parse(minorTextController.text),
        'attendance': false
      };
      var beaconEstimote = BeaconEstimote.fromJson(data);

      DatabaseService()
          .createBeacon(beaconEstimote, changeNotifier, File(path!));
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Success add beacon',
                style: titleStyle,
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Okay',
                      style: subtitleStyle,
                    ))
              ],
            );
          });
    }
  }
}
