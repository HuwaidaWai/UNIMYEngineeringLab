import 'package:flutter/material.dart';
import 'package:smart_engineering_lab/constant/color_constant.dart';
import 'package:smart_engineering_lab/login_screens.dart';
import 'package:smart_engineering_lab/sign_up_screen.dart';
import 'package:smart_engineering_lab/widget/login_button_widget.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: height,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  'UNIMY',
                  style: supertitleStyle,
                ),
              ),
              Text(
                'SMART ENGINEERING LAB',
                style: landingsubtitleStyle,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/landing_img.png'),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    LoginButtonWidget(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                        },
                        child: Text(
                          'LOGIN',
                          style: subtitleStyle2Small,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: LoginButtonWidget(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const SignUpScreen()));
                          },
                          child: Text(
                            'SIGNUP',
                            style: subtitleStyle2Small,
                          )),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
