import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_engineering_lab/constant/color_constant.dart';
import 'package:smart_engineering_lab/model/attendance_model.dart';
import 'package:smart_engineering_lab/services/database_services.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
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
          'Attendance Logbook',
          style: subtitleStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: const [
                    Expanded(
                        child: Text(
                      'Name',
                      textAlign: TextAlign.center,
                    )),
                    Expanded(child: Text('Id', textAlign: TextAlign.center)),
                    Expanded(child: Text('Date', textAlign: TextAlign.center)),
                    Expanded(child: Text('Time', textAlign: TextAlign.center)),
                  ],
                ),
              ),
              const Divider(
                height: 1,
                thickness: 2,
              ),
              StreamBuilder<List<AttendanceModel>>(
                  stream: DatabaseService().listOfAttendace,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, i) {
                            return Card(
                              child: Row(
                                children: [
                                  Text(snapshot.data![i].user!.name!),
                                  Text(snapshot.data![i].user!.id!),
                                  Text(snapshot.data![i].date!),
                                  Text(snapshot.data![i].time!)
                                ],
                              ),
                            );
                          });
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
