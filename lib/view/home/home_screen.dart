import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO: Finish UI for homescreen
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 36.0),
        child: Column(
          children: const [
            Center(
              child: Text('HOME SCREEN'),
            )
          ],
        ),
      ),
    );
  }
}
