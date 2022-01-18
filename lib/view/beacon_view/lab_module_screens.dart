import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';
import 'package:smart_engineering_lab/constant/color_constant.dart';
import 'package:smart_engineering_lab/model/lab_module_model.dart';
import 'package:smart_engineering_lab/model/user_model.dart';
import 'package:smart_engineering_lab/provider/root_change_notifier.dart';
import 'package:smart_engineering_lab/services/database_services.dart';
import 'package:smart_engineering_lab/view/home/home_page_index.dart';

class LabModuleScreenNew extends StatefulWidget {
  final LabModuleViewModel labModuleModel;

  const LabModuleScreenNew({Key? key, required this.labModuleModel})
      : super(key: key);

  @override
  _LabModuleScreenNewState createState() => _LabModuleScreenNewState();
}

class _LabModuleScreenNewState extends State<LabModuleScreenNew> {
  final preparedForController = TextEditingController();
  @override
  void initState() {
    super.initState();

    preparedForController.text = widget.labModuleModel.userPreparedFor!;
  }

  @override
  Widget build(BuildContext context) {
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
          widget.labModuleModel.nameModule!.text,
          style: subtitleStyle,
        ),
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Image.asset('assets/unimyLogo.png'),
            ),
            Text(
              widget.labModuleModel.nameModule!.text,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 30),
              child: Text(
                widget.labModuleModel.titleModule!.text,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Prepared by",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextFormField(
                      enabled: false,
                      controller: preparedForController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1)),
                      ))
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Prepared for",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  widget.labModuleModel.userPreparedBy!.isEmpty
                      ? Container()
                      : Row(
                          children: const [
                            Expanded(
                                flex: 2,
                                child: Text(
                                  'Student Name',
                                  textAlign: TextAlign.center,
                                )),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                flex: 1,
                                child: Text(
                                  'Student Id',
                                  textAlign: TextAlign.center,
                                )),
                            // Expanded(flex: 2, child: Text('Student Name')),
                            // SizedBox(
                            //   width: 10,
                            // ),
                            // Expanded(flex: 1, child: Text('Student Id')),
                          ],
                        ),
                  Column(
                    children: widget.labModuleModel.userPreparedBy!
                        .map((e) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                        enabled: true,
                                        controller:
                                            TextEditingController(text: e.name),
                                        onChanged: (value) {
                                          widget
                                              .labModuleModel
                                              .userPreparedBy![widget
                                                  .labModuleModel
                                                  .userPreparedBy!
                                                  .indexOf(e)]
                                              .name = value;
                                        },
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(width: 1)),
                                        )),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: TextFormField(
                                        enabled: true,
                                        controller:
                                            TextEditingController(text: e.id),
                                        onChanged: (value) {
                                          widget
                                              .labModuleModel
                                              .userPreparedBy![widget
                                                  .labModuleModel
                                                  .userPreparedBy!
                                                  .indexOf(e)]
                                              .id = value;
                                        },
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(width: 1)),
                                        )),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              widget.labModuleModel.userPreparedBy!
                                  .add(UserModel());
                            });
                          },
                          child: const Text('Add')),
                    ],
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Date",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            TextFormField(
                enabled: true,
                controller: TextEditingController(
                    text: DateFormat('dd-MM-yyyy').format(DateTime.now())),
                onChanged: (value) {
                  widget.labModuleModel.date =
                      DateFormat('dd-MM-yyyy').format(DateTime.now());
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.labModuleModel.sections!
                  .map((e) => Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                e.titleSection!.text,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            e.titleSection!.text.contains('Discussion') ||
                                    e.titleSection!.text.contains('Conclusion')
                                ? Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    child: Column(
                                      children: e.description!
                                          .map((description) => TextFormField(
                                              controller: TextEditingController(
                                                  text: description
                                                      .description!.text),
                                              onChanged: (value) {
                                                var indexSection = widget
                                                    .labModuleModel.sections!
                                                    .indexOf(e);
                                                var indexDescription = widget
                                                    .labModuleModel
                                                    .sections![indexSection]
                                                    .description!
                                                    .indexOf(description);

                                                widget
                                                    .labModuleModel
                                                    .sections![indexSection]
                                                    .description![
                                                        indexDescription]
                                                    .description!
                                                    .text = value;
                                              },
                                              decoration: InputDecoration(
                                                  border:
                                                      const OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  width: 1)),
                                                  hintText:
                                                      e.titleSection!.text)))
                                          .toList(),
                                    ))
                                : e.titleSection!.text.contains('Results')
                                    ? Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        child: Column(
                                          children: e.description!
                                              .map(
                                                (description) =>
                                                    buildImageContainer(
                                                  () async {
                                                    var path;
                                                    FilePickerResult? result =
                                                        await FilePicker
                                                            .platform
                                                            .pickFiles(
                                                      type: FileType.custom,
                                                      allowedExtensions: [
                                                        'jpg',
                                                        'png'
                                                      ],
                                                    );
                                                    if (result != null) {
                                                      //File file = File(result.files.single.path);
                                                      PlatformFile
                                                          platformFile =
                                                          result.files.first;

                                                      path = platformFile.path;
                                                      setState(() {
                                                        description.path = path;
                                                      });

                                                      // var indexDescription =
                                                      //     labModuleView
                                                      //         .sections![
                                                      //             index]
                                                      //         .description!
                                                      //         .indexOf(e);
                                                      // setState(() {
                                                      //   labModuleView
                                                      //       .sections![
                                                      //           index]
                                                      //       .description![
                                                      //           indexDescription]
                                                      //       .path = path;
                                                      // });

                                                      print(
                                                          'This is basename :${p.basename(path!)}');

                                                      // changeNotifier.setBeaconsImage(File(path!));
                                                    }
                                                  },
                                                  description.path,
                                                  () {
                                                    print('HELLOOO');
                                                    setState(() {
                                                      description.path = null;
                                                    });
                                                    // var indexDescription =
                                                    //     widget
                                                    //         .labModuleModel
                                                    //         .sections![
                                                    //             index]
                                                    //         .description!
                                                    //         .indexOf(
                                                    //             description);
                                                    // setState(() {
                                                    //   labModuleView
                                                    //       .sections![
                                                    //           index]
                                                    //       .description![
                                                    //           indexDescription]
                                                    //       .path = null;
                                                    // });
                                                  },
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      )
                                    : Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        child: Column(
                                          children: e.description!.map((e1) {
                                            if (e1.type == 'PICTURE') {
                                              return Image.network(
                                                e1.pictureLink!,
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    const Text(
                                                        'Link image problem'),
                                              );
                                            } else {
                                              return Text(e1.description!.text);
                                            }
                                          }).toList(),
                                        ))
                          ],
                        ),
                      ))
                  .toList(),
            ),
            changeNotifier.getUserModel.role == 'STUDENT'
                ? Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text(
                                            'Are you sure to submit?'),
                                        actions: [
                                          Row(
                                            children: [
                                              ElevatedButton(
                                                  onPressed: () async {
                                                    // widget.labModuleModel
                                                    //     .submitted = true;

                                                    // log('LAB VIEW MODEL :${widget.labModuleModel.toJson()}');
                                                    // await DatabaseService()
                                                    //     .sumittedLabModuleByStudent(
                                                    //         widget
                                                    //             .labModuleModel,
                                                    //         changeNotifier);

                                                    Navigator.of(context).pop();
                                                    // Navigator.of(context).push(
                                                    //     MaterialPageRoute(
                                                    //         builder: (context) =>
                                                    //             HomePageIndex()));
                                                  },
                                                  child: const Text('No')),
                                              ElevatedButton(
                                                  onPressed: () async {
                                                    widget.labModuleModel
                                                        .submitted = true;

                                                    log('LAB VIEW MODEL :${widget.labModuleModel.toJson()}');
                                                    await DatabaseService()
                                                        .sumittedLabModuleByStudent(
                                                            widget
                                                                .labModuleModel,
                                                            changeNotifier);

                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
                                                    // Navigator.of(context).push(
                                                    //     MaterialPageRoute(
                                                    //         builder: (context) =>
                                                    //             HomePageIndex()));
                                                  },
                                                  child: const Text('Yes')),
                                            ],
                                          )
                                        ],
                                      ));
                            },
                            child: const Text('SUBMIT'))
                      ],
                    ),
                  )
                : Container()
          ],
        ),
      )),
    );
  }

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
}
