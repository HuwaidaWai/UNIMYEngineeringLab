import 'package:flutter/material.dart';

class LoginButtonWidget extends StatefulWidget {
  final Function() onPressed;
  const LoginButtonWidget({Key? key, required this.onPressed})
      : super(key: key);

  @override
  State<LoginButtonWidget> createState() => _LoginButtonWidgetState();
}

class _LoginButtonWidgetState extends State<LoginButtonWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      constraints:
          BoxConstraints(minWidth: size.width, maxWidth: 500, minHeight: 60),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 2,
              // fixedSize: Size,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)))),
          onPressed: widget.onPressed,
          child: const Text('Login')),
    );
  }
}
