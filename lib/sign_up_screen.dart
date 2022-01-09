import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smart_engineering_lab/constant/color_constant.dart';
import 'package:smart_engineering_lab/enum/view_state_enum.dart';
import 'package:smart_engineering_lab/main.dart';
import 'package:smart_engineering_lab/provider/root_change_notifier.dart';
import 'package:smart_engineering_lab/services/auth_service.dart';
import 'package:smart_engineering_lab/widget/login_button_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool studentSelected = true;
  bool lecturerSelected = false;
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final repwController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final changeNotifier = context.watch<RootChangeNotifier>();
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 36.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.chevronLeft),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ]),
              buildTitle(),
              buildTextField('Name', nameController),
              buildTextField('Student/Lecturer ID', idController),
              buildTextField('Email', emailController),
              buildTextField('Password', pwController),
              buildTextField('Re-Password', repwController),
              buildUserType(),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: LoginButtonWidget(
                  child: changeNotifier.getViewState == ViewState.BUSY
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text('Login'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (pwController.text != repwController.text) {
                        pwController.clear();
                        repwController.clear();
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Password not matching'),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('Okay'))
                                ],
                              );
                            });
                      } else {
                        print(emailController.text);
                        print(pwController.text);
                        print(nameController.text);
                        print(repwController.text);
                        print(studentSelected ? 'STUDENT' : 'LECTURER');
                        context
                            .read<AuthService>()
                            .signUp(
                                email: emailController.text,
                                password: pwController.text,
                                displayName: nameController.text,
                                role: studentSelected ? 'STUDENT' : 'LECTURER',
                                changeNotifier: changeNotifier)
                            .catchError((e) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('ERROR'),
                                  content: Text(e.toString()),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text('Okay'))
                                  ],
                                );
                              });
                        }).whenComplete(() {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const AuthWrapper();
                          }));
                        });
                      }
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  Widget buildTitle() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          "Let’s Get Started!",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Text(
            'Create your own account to enjoy your e-learning experience!',
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  Widget buildTextField(
      String labelText, TextEditingController editingController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 8.0,
            ),
            child: Row(
              children: [
                Text(
                  labelText,
                  style: const TextStyle(fontSize: 14),
                ),
                const Text(
                  '*',
                  style: TextStyle(color: Colors.red),
                )
              ],
            ),
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '*This field is required';
              }
              return null;
            },
            obscureText: (labelText == 'Password' || labelText == 'Re-Password')
                ? true
                : false,
            enableSuggestions:
                (labelText == 'Password' || labelText == 'Re-Password')
                    ? false
                    : true,
            autocorrect: (labelText == 'Password' || labelText == 'Re-Password')
                ? false
                : true,
            controller: editingController,
            decoration: const InputDecoration(
                filled: true,
                errorStyle: TextStyle(color: Colors.red),
                fillColor: Color(0xffE6F2F6),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(20)))),
          ),
        ],
      ),
    );
  }

  Widget buildUserType() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            children: const [
              Expanded(
                child: Divider(
                  height: 5,
                  color: Colors.black,
                  thickness: 0.2,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 36.0),
                child: Text('USER'),
              ),
              Expanded(
                child: Divider(
                  height: 5,
                  color: Colors.black,
                  thickness: 0.2,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: TextButton(
                style: TextButton.styleFrom(
                    primary: studentSelected ? colorCustom : Colors.black),
                onPressed: () {
                  setState(() {
                    lecturerSelected = false;
                    studentSelected = true;
                  });
                },
                child: const Text('STUDENT'),
              )),
              Container(width: 20),
              Expanded(
                  child: TextButton(
                style: TextButton.styleFrom(
                    splashFactory: InkRipple.splashFactory,
                    primary: lecturerSelected ? colorCustom : Colors.black),
                onPressed: () {
                  setState(() {
                    lecturerSelected = true;
                    studentSelected = false;
                  });
                },
                child: const Text('LECTURER'),
              ))
            ],
          )
        ],
      ),
    );
  }
}
