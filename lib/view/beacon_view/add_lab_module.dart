import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:smart_engineering_lab/constant/color_constant.dart';
import 'package:smart_engineering_lab/model/lab_module_model.dart';
import 'package:smart_engineering_lab/services/database_services.dart';

class AddLabModule extends StatefulWidget {
  final String beaconId;
  const AddLabModule({Key? key, required this.beaconId}) : super(key: key);

  @override
  _AddLabModuleState createState() => _AddLabModuleState();
}

class _AddLabModuleState extends State<AddLabModule> {
  //TODO: Fix delete button
  var listOfController = LabModuleViewModel(
      nameModule: TextEditingController(),
      titleModule: TextEditingController(),
      sections: [
        SectionViewModel(
            titleSection: TextEditingController(), description: []),
        SectionViewModel(
            titleSection: TextEditingController(), description: []),
        SectionViewModel(
            titleSection: TextEditingController(), description: []),
        SectionViewModel(
            titleSection: TextEditingController(), description: []),
        SectionViewModel(
            titleSection: TextEditingController(), description: []),
        SectionViewModel(titleSection: TextEditingController(), description: [])
      ]);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const FaIcon(
              FontAwesomeIcons.chevronLeft,
              color: Colors.white,
            )),
        title: Text(
          'Add Lab Module',
          style: titleStyle,
        ),
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildTextField(
              'Name Module',
              listOfController.nameModule!,
              false,
            ),
            buildTextField(
              'Title Module',
              listOfController.titleModule!,
              false,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Section'),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      listOfController.sections!.add(SectionViewModel(
                          titleSection: TextEditingController(),
                          description: []));
                    });
                  },
                  child: const Icon(Icons.add),
                  style: ElevatedButton.styleFrom(elevation: 0),
                )
              ],
            ),
            ListView.builder(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: listOfController.sections!.length,
                itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                                label: Text(
                                  'Section',
                                  style: subtitleStyle2,
                                ),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.0))),
                            controller:
                                listOfController.sections![index].titleSection,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      listOfController
                                          .sections![index].description!
                                          .add(Description(
                                              type: 'TEXT',
                                              description:
                                                  TextEditingController()));
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        'Add Text',
                                        style: subtitleStyle2,
                                      ),
                                      const Icon(Icons.add),
                                    ],
                                  )),
                              const SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      listOfController
                                          .sections![index].description!
                                          .add(Description(type: 'PICTURE'));
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        'Add Diagram',
                                        style: subtitleStyle2,
                                      ),
                                      const Icon(Icons.add),
                                    ],
                                  ))
                            ],
                          ),
                          Column(
                            children: listOfController
                                .sections![index].description!
                                .map((e) {
                              if (e.type == 'PICTURE') {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8, bottom: 8, left: 32, right: 8),
                                  child: buildImageContainer(
                                      () async {
                                        var path;
                                        FilePickerResult? result =
                                            await FilePicker.platform.pickFiles(
                                          type: FileType.custom,
                                          allowedExtensions: ['jpg', 'png'],
                                        );
                                        if (result != null) {
                                          //File file = File(result.files.single.path);
                                          PlatformFile platformFile =
                                              result.files.first;
                                          path = platformFile.path;
                                          var indexDescription =
                                              listOfController
                                                  .sections![index].description!
                                                  .indexOf(e);
                                          setState(() {
                                            listOfController
                                                .sections![index]
                                                .description![indexDescription]
                                                .path = path;
                                          });

                                          print(
                                              'This is basename :${p.basename(path!)}');

                                          // changeNotifier.setBeaconsImage(File(path!));
                                        }
                                      },
                                      e.path,
                                      () {
                                        print('HELLOOO');
                                        var indexDescription = listOfController
                                            .sections![index].description!
                                            .indexOf(e);
                                        setState(() {
                                          listOfController
                                              .sections![index]
                                              .description![indexDescription]
                                              .path = null;
                                        });
                                      }),
                                );
                              } else {
                                return buildTextField(
                                    'Text Description', e.description!, true,
                                    onTap: () {});
                              }
                            }).toList(),
                          )
                        ],
                      ),
                    )),
            ElevatedButton(
                onPressed: () {
                  listOfController.beaconId = widget.beaconId;
                  DatabaseService().createLabModule(listOfController);
                },
                child: Text(
                  'Submit',
                  style: subtitleStyle2,
                ))
          ],
        ),
      )),
    );
  }

  // Widget buildSectionTextField(
  //         SectionViewModel section, Function() onPressed) =>
  //     Padding(
  //       padding: const EdgeInsets.symmetric(vertical: 8),
  //       child: Column(
  //         children: [
  //           TextFormField(
  //             controller: section.titleSection,
  //           ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.end,
  //             children: [
  //               IconButton(onPressed: onPressed, icon: const Icon(Icons.add))
  //             ],
  //           )
  //         ],
  //       ),
  //     );

  Widget buildImageContainer(
          Function() onPressed, String? path, Function() onPressedDelete) =>
      Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.grey)),
            padding: const EdgeInsets.all(8),
            child: Center(
              child: path == null
                  ? OutlinedButton(
                      child: Text(
                        'Pick File',
                        style: subtitleStyle2Small,
                      ),
                      onPressed: onPressed)
                  : Image.file(
                      File(path),
                      height: 100,
                    ),
            ),
          ),
          path == null
              ? Container()
              : Positioned(
                  top: 5,
                  right: 10,
                  child: IconButton(
                    onPressed: onPressedDelete,
                    icon: const Icon(Icons.delete),
                  )),
        ],
      );
  Widget buildTextField(
          String label, TextEditingController controller, bool isDescription,
          {Function()? onTap}) =>
      Stack(
        children: [
          onTap == null
              ? Container()
              : Positioned(
                  right: 10,
                  child: GestureDetector(
                      onTap: onTap, child: const Icon(Icons.delete))),
          Padding(
            padding: EdgeInsets.only(
                top: 8, bottom: 8, left: isDescription ? 32 : 0),
            child: TextFormField(
              controller: controller,
              maxLines: isDescription ? null : 1,
              decoration: InputDecoration(
                  label: Text(
                    label,
                    style: subtitleStyle2,
                  ),
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(width: 1.0))),
            ),
          ),
        ],
      );
}
