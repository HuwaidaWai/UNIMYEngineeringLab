import 'package:flutter/material.dart';

class LabModuleViews extends StatefulWidget {
  const LabModuleViews({Key? key}) : super(key: key);

  @override
  _LabModuleViewsState createState() => _LabModuleViewsState();
}

class _LabModuleViewsState extends State<LabModuleViews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey,
        child: const Text('Lab Module'),
      ),
    );
  }
}
