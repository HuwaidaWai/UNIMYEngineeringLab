import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:provider/src/provider.dart';
import 'package:smart_engineering_lab/constant/color_constant.dart';
import 'package:smart_engineering_lab/enum/view_state_enum.dart';
import 'package:smart_engineering_lab/model/lab_module_model.dart';
import 'package:smart_engineering_lab/model/user_model.dart';
import 'package:smart_engineering_lab/provider/root_change_notifier.dart';
import 'package:smart_engineering_lab/services/database_services.dart';

class AddLabModule extends StatefulWidget {
  final String beaconId;
  const AddLabModule({Key? key, required this.beaconId}) : super(key: key);

  @override
  _AddLabModuleState createState() => _AddLabModuleState();
}

class _AddLabModuleState extends State<AddLabModule> {
  var labModuleView = LabModuleViewModel(
      nameModule: TextEditingController(text: ''),
      titleModule: TextEditingController(text: ''),
      sections: [
        SectionViewModel(
            titleSection: TextEditingController(text: '1.0 Introduction'),
            description: []),
        SectionViewModel(
            titleSection: TextEditingController(text: '2.0 Objective'),
            description: []),
        SectionViewModel(
            titleSection: TextEditingController(text: '3.0 Flow chart'),
            description: []),
        SectionViewModel(
            titleSection: TextEditingController(text: '4.0 Tools'),
            description: []),
        SectionViewModel(
            titleSection: TextEditingController(text: '5.0 Procedure'),
            description: []),
        SectionViewModel(
            titleSection: TextEditingController(text: '6.0 Introduction'),
            description: []),
        SectionViewModel(
            titleSection: TextEditingController(text: '7.0 Discussion'),
            description: []),
        SectionViewModel(
            titleSection: TextEditingController(text: '8.0 Conclusion'),
            description: []),
      ]);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    final changeNotifier = context.watch<RootChangeNotifier>();
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
              labModuleView.nameModule!,
              false,
            ),
            buildTextField(
              'Title Module',
              labModuleView.titleModule!,
              false,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Section',
                  style: subtitleStyle2,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      labModuleView.sections!.add(SectionViewModel(
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
                itemCount: labModuleView.sections!.length,
                itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      labModuleView.sections!.removeAt(index);
                                    });
                                  },
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ))
                              // Container(
                              //   padding: const EdgeInsets.all(4),
                              //   decoration: const BoxDecoration(
                              //       color: Colors.red,
                              //       // border: Border.all(color: Colors.white),
                              //       borderRadius:
                              //           BorderRadius.all(Radius.circular(16))),
                              //   child: GestureDetector(
                              //       onTap: () {
                              //         setState(() {
                              //           labModuleView.sections!
                              //               .removeAt(index);
                              //         });
                              //       },
                              //       child: const Icon(
                              //         Icons.delete,
                              //         color: Colors.white,
                              //       )),
                              // ),
                            ],
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                label: Text(
                                  'Section',
                                  style: subtitleStyle2,
                                ),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.0))),
                            controller:
                                labModuleView.sections![index].titleSection,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      labModuleView
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
                                      labModuleView
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
                            children: labModuleView
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
                                          var indexDescription = labModuleView
                                              .sections![index].description!
                                              .indexOf(e);
                                          setState(() {
                                            labModuleView
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
                                        var indexDescription = labModuleView
                                            .sections![index].description!
                                            .indexOf(e);
                                        setState(() {
                                          labModuleView
                                              .sections![index]
                                              .description![indexDescription]
                                              .path = null;
                                        });
                                      },
                                      onPressDeleteContainer: () {
                                        setState(() {
                                          labModuleView
                                              .sections![index].description!
                                              .removeWhere(
                                                  (element) => element == e);
                                        });
                                      }),
                                );
                              } else {
                                return buildTextField(
                                    'Text Description', e.description!, true,
                                    onTap: () {
                                  setState(() {
                                    labModuleView.sections![index].description!
                                        .removeWhere((element) => element == e);
                                  });
                                });
                              }
                            }).toList(),
                          )
                        ],
                      ),
                    )),
            StreamBuilder<UserModel>(
                stream: DatabaseService(uid: firebaseUser.uid).readUserName,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ElevatedButton(
                        onPressed: () {
                          labModuleView.beaconId = widget.beaconId;
                          labModuleView.userPreparedFor = snapshot.data!.name;
                          labModuleView.userPreparedBy = <UserModel>[];
                          labModuleView.submitted = false;
                          DatabaseService()
                              .createLabModule(labModuleView, changeNotifier)
                              .whenComplete(() => Navigator.of(context).pop());
                        },
                        child: changeNotifier.getViewState == ViewState.BUSY
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Submit',
                                style: subtitleStyle2,
                              ));
                  } else {
                    return Container();
                  }
                })
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
          Function() onPressed, String? path, Function() onPressedDelete,
          {Function()? onPressDeleteContainer}) =>
      Column(
        children: [
          onPressDeleteContainer == null
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: onPressDeleteContainer,
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ))
                  ],
                ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.grey)),
            padding: const EdgeInsets.all(8),
            child: Stack(
              children: [
                Center(
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
            ),
          ),
        ],
      );
  Widget buildTextField(
          String label, TextEditingController controller, bool isDescription,
          {Function()? onTap}) =>
      Column(
        children: [
          onTap == null
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: onTap,
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ))
                  ],
                ),
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
