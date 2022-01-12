import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:provider/provider.dart';
import 'package:smart_engineering_lab/model/beacons_view_model.dart';
import 'package:smart_engineering_lab/model/lab_module_model.dart';
import 'package:smart_engineering_lab/model/user_model.dart';
import 'package:smart_engineering_lab/services/database_services.dart';
import 'package:smart_engineering_lab/view/beacon_view/add_lab_module.dart';
import 'package:smart_engineering_lab/view/beacon_view/lab_module_screens.dart';

class SingleBeaconScreen extends StatefulWidget {
  final Region region;
  final BeaconViewModel beaconViewModel;
  const SingleBeaconScreen(
      {Key? key, required this.beaconViewModel, required this.region})
      : super(key: key);

  @override
  _SingleBeaconScreenState createState() => _SingleBeaconScreenState();
}

class _SingleBeaconScreenState extends State<SingleBeaconScreen> {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.beaconViewModel.name!),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Lab Report'),
                  StreamBuilder<UserModel>(
                      stream:
                          DatabaseService(uid: firebaseUser.uid).readUserName,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: snapshot.data!.role == 'STUDENT'
                                ? const SizedBox()
                                : ElevatedButton(
                                    style:
                                        ElevatedButton.styleFrom(elevation: 0),
                                    onPressed: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => AddLabModule(
                                                beaconId:
                                                    widget.region.identifier))),
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
              StreamBuilder<List<LabModuleViewModel>>(
                  stream: DatabaseService()
                      .listLabModules(widget.region.identifier),
                  builder: (context, snapshot) {
                    print('Identifier please: ${widget.region.identifier}');
                    if (snapshot.hasData) {
                      var data = snapshot.data!;
                      if (data.isEmpty) {
                        return const Text('No Lab Module');
                      } else {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: data.length,
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (context, i) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LabModuleScreenNew(
                                                  labModuleModel: data[i])));
                                },
                                child: Card(
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(data[i].nameModule!.text),
                                          Text(data[i].titleModule!.text),
                                        ],
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            DatabaseService().deleteLabModule(
                                                data[i].labModuleId!);
                                          },
                                          icon: const Icon(Icons.delete))
                                    ],
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
        ),
      ),
    );
  }
}
