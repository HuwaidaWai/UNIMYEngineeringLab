import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smart_engineering_lab/enum/view_state_enum.dart';
import 'package:smart_engineering_lab/main.dart';
import 'package:smart_engineering_lab/provider/root_change_notifier.dart';
import 'package:smart_engineering_lab/services/auth_service.dart';
import 'package:smart_engineering_lab/services/local_notification_services.dart';
import 'dart:async';

import 'package:smart_engineering_lab/sign_up_screen.dart';
import 'package:smart_engineering_lab/view/home/home_page_index.dart';
import 'package:smart_engineering_lab/widget/login_button_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  Widget buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Email',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '*This field is required';
            }
            return null;
          },
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: Colors.black87),
          decoration: const InputDecoration(
              filled: true,
              errorStyle: TextStyle(color: Colors.red),
              fillColor: Color(0xffE6F2F6),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(20)))),
        )
      ],
    );
  }

  Widget buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Password',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '*This field is required';
            }
            return null;
          },
          controller: pwController,
          obscureText: true,
          style: const TextStyle(color: Colors.black87),
          decoration: const InputDecoration(
              filled: true,
              errorStyle: TextStyle(color: Colors.red),
              fillColor: Color(0xffE6F2F6),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(20)))),
        )
      ],
    );
  }

  Widget buildForgotPassBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => print("Forgot Password pressed"),
        padding: const EdgeInsets.only(right: 0),
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /*Widget buildRememberCb(){
    return Container(
      height: 20,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: isRememberMe,
              checkColor: Colors.red,
              activeColor: Colors.white,
              onChanged: (value){
                setState(() {
                  isRememberMe = value; //ERROR
                });
              },
            ),
          ),
          Text(
            'Remember me',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  } */

  Widget buildLoginBtn() {
    final changeNotifier = context.watch<RootChangeNotifier>();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: LoginButtonWidget(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            await context
                .read<AuthService>()
                .signIn(
                    email: emailController.text,
                    password: pwController.text,
                    changeNotifier: changeNotifier)
                .catchError((e) {
              print(' CATCH ERROR : $e');
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('ERROR'),
                      content: Text(e.toString()),
                      actions: [
                        ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Okay'))
                      ],
                    );
                  });
            });
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return const HomePageIndex();
            }));
          }
        },
        child: changeNotifier.getViewState == ViewState.BUSY
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Text(
                'LOGIN',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Widget buildSignUpBtn() {
    return GestureDetector(
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const SignUpScreen())),
        child: RichText(
          text: const TextSpan(children: [
            TextSpan(
                text: 'Don\'t have an Account? ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                )),
            TextSpan(
                text: 'Sign Up',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ))
          ]),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      // decoration: const BoxDecoration(
      //     gradient: LinearGradient(
      //         begin: Alignment.topCenter,
      //         end: Alignment.bottomCenter,
      //         colors: [
      //       Color(0x99d10e48),
      //       Color(0xBFd10e48),
      //       Color(0xccd10e48),
      //       Color(0xffd10e48),
      //     ])),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 120),
        child: Form(
          key: _formKey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Image.asset(
                    'assets/unimy.png',
                    height: 120,
                  ),
                ),
                const Text(
                  'UNIMY Engineering Lab',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 50),
                buildEmail(),
                const SizedBox(height: 20),
                buildPassword(),
                buildForgotPassBtn(),
                //buildRememberCb(),
                buildLoginBtn(),
                buildSignUpBtn(),
              ]),
        ),
      ),
    ));
  }
}
