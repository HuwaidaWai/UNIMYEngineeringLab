import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final uuidTextController = TextEditingController();
  final majorTextController = TextEditingController();
  final minorTextController = TextEditingController();
  final storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: uuidTextController,
              decoration: const InputDecoration(hintText: 'ProximityUUID'),
            ),
            TextFormField(
              controller: majorTextController,
              decoration: const InputDecoration(hintText: 'Major'),
            ),
            TextFormField(
              decoration: const InputDecoration(hintText: 'Minor'),
              controller: minorTextController,
            ),
            Container(
                margin: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                    onPressed: _onSubmit, child: const Text('Submit')))
          ],
        ),
      ),
    );
  }

  _onSubmit() {}
}
