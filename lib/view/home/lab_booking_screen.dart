import 'package:flutter/material.dart';

class LabBookingScreen extends StatefulWidget {
  const LabBookingScreen({Key? key}) : super(key: key);

  @override
  _LabBookingScreenState createState() => _LabBookingScreenState();
}

class _LabBookingScreenState extends State<LabBookingScreen> {
  bool lisLabRoomSelected = false;
  bool daySelected = false;
  bool timeSlotSelected = false;
  var listLabRoom = ['1', '2', '3', '4'];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 36.0),
        child: Column(
          children: [
            const Text('Lab Booking'),
            Column(
              children: [
                const Text('Lab Room'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: listLabRoom
                      .map((e) => Container(
                            margin: const EdgeInsets.all(8),
                            child: Card(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16))),
                              elevation: 2.0,
                              child: Center(
                                child: Text(e),
                              ),
                            ),
                          ))
                      .toList(),
                )
              ],
            ),
            const Text('Date'),
            const Text('Time Slot')
          ],
        ),
      ),
    );
  }
}
