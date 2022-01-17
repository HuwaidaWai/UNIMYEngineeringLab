import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
                                : Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    child: Column(
                                      children: e.description!.map((e1) {
                                        if (e1.type == 'PICTURE') {
                                          return Image.network(e1.pictureLink!);
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
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text('Are you sure to sumit?'),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () async {
                                          widget.labModuleModel.submitted =
                                              true;

                                          log('LAB VIEW MODEL :${widget.labModuleModel.toJson()}');
                                          await DatabaseService()
                                              .updateLabModule(
                                                  widget.labModuleModel,
                                                  changeNotifier);

                                          Navigator.of(context).pop();
                                          // Navigator.of(context).push(
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             HomePageIndex()));
                                        },
                                        child: const Text('Yes'))
                                  ],
                                )).whenComplete(
                            () => Navigator.of(context).pop());
                      },
                      child: const Text('SUBMIT'))
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
