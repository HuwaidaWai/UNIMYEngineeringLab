import 'package:flutter/material.dart';

class LabBookingScreen extends StatefulWidget {
  const LabBookingScreen({Key? key}) : super(key: key);

  @override
  _LabBookingScreenState createState() => _LabBookingScreenState();
}

class _LabBookingScreenState extends State<LabBookingScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 36.0),
        child: Column(
          children: const [
            Center(
              child: Text('LAB BOOKING SCREEN'),
            )
          ],
        ),
      ),
    );
  }
}
