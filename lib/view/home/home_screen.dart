import 'package:flutter/material.dart';
import 'package:smart_engineering_lab/constant/color_constant.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO: Finish UI for homescreen
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 36.0),
      child: Column(
        children: [
          Center(
            child: Text(
              'HOME SCREEN',
              style: titleStyle,
            ),
          )
        ],
      ),
    );
  }
}
