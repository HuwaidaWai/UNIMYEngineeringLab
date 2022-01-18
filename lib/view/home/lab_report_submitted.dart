import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/src/provider.dart';
import 'package:smart_engineering_lab/constant/color_constant.dart';
import 'package:smart_engineering_lab/model/lab_module_model.dart';
import 'package:smart_engineering_lab/provider/root_change_notifier.dart';
import 'package:smart_engineering_lab/services/database_services.dart';
import 'package:smart_engineering_lab/view/beacon_view/lab_module_screens.dart';

class LabReportSubmitted extends StatefulWidget {
  const LabReportSubmitted({Key? key}) : super(key: key);

  @override
  _LabReportSubmittedState createState() => _LabReportSubmittedState();
}

class _LabReportSubmittedState extends State<LabReportSubmitted> {
  @override
  Widget build(BuildContext context) {
    final changeNotifier = context.read<RootChangeNotifier>();
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
        title: const Text('UNIMY ENGINEERING LAB'),
        // centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Text('Lab Report Submitted'),
              ),
            ),
            StreamBuilder<List<LabModuleViewModel>>(
                stream: DatabaseService()
                    .listLabModulesSubmitted(changeNotifier.getUserModel.name!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var data = snapshot.data!;
                    if (data.isEmpty) {
                      return const Center(
                          child: Text('No Lab Module Submitted'));
                    } else {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.length,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, i) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  // data[i].beaconId = widget.region.identifier;
                                  return LabModuleScreenNew(
                                      labModuleModel: data[i]);
                                }));
                              },
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Image.asset(
                                                'assets/unimyLab.png',
                                                width: 100,
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          data[i]
                                                              .nameModule!
                                                              .text,
                                                          style: subtitleStyle,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    data[i].titleModule!.text,
                                                    style: subtitleStyle2,
                                                  ),
                                                  const Text('Submitted by'),
                                                  Column(
                                                    children: data[i]
                                                        .userPreparedBy!
                                                        .map((e) =>
                                                            Text(e.name!))
                                                        .toList(),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      'Are you sure want to delete?',
                                                      style: subtitleStyle2,
                                                    ),
                                                    actions: [
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            DatabaseService()
                                                                .deleteLabModule(
                                                                    data[i]
                                                                        .labModuleId!);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                            'Yes',
                                                            style:
                                                                subtitleStyle2,
                                                          ))
                                                    ],
                                                  );
                                                });
                                          },
                                          icon: const Icon(Icons.delete))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    }
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    return const CircularProgressIndicator();
                  }
                })
          ],
        ),
      )),
    );
  }
}
