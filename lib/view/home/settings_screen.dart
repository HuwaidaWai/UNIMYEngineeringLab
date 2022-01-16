import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/src/provider.dart';
import 'package:smart_engineering_lab/constant/color_constant.dart';
import 'package:smart_engineering_lab/main.dart';
import 'package:smart_engineering_lab/model/user_model.dart';
import 'package:smart_engineering_lab/provider/root_change_notifier.dart';
import 'package:smart_engineering_lab/services/auth_service.dart';
import 'package:smart_engineering_lab/services/database_services.dart';
import 'package:smart_engineering_lab/view/home/edit_profile_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _switchValueNotification = false;
  bool _switchValueApp = false;
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    final changeNotifier = context.watch<RootChangeNotifier>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Text(
                  'Settings',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                ),
              ),
              Column(
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'ACCOUNT',
                              style: subtitleStyle,
                            ),
                          ),
                          const Divider(
                            height: 1,
                            thickness: 2,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          StreamBuilder<UserModel>(
                              stream: DatabaseService(uid: firebaseUser.uid)
                                  .readUserName,
                              builder: (context, snapshot) {
                                return TextButton(
                                  onPressed: () {
                                    if (snapshot.hasData) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditProfileScreen(
                                                    name: snapshot.data!.name!,
                                                  )));
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Edit Profile',
                                        style:
                                            TextStyle(color: Colors.grey[600]),
                                      ),
                                      const FaIcon(
                                          FontAwesomeIcons.chevronRight)
                                    ],
                                  ),
                                );
                              }),
                          TextButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Change Password',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                const FaIcon(FontAwesomeIcons.chevronRight)
                              ],
                            ),
                          )
                        ],
                      )),
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'NOTIFICATION',
                              style: subtitleStyle,
                            ),
                          ),
                          const Divider(
                            height: 1,
                            thickness: 2,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _switchValueNotification =
                                    !_switchValueNotification;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Notification',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                CupertinoSwitch(
                                  activeColor: Colors.red,
                                  value: _switchValueNotification,
                                  onChanged: (value) {
                                    setState(() {
                                      _switchValueNotification = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _switchValueApp = !_switchValueApp;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'App Notification',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                CupertinoSwitch(
                                  activeColor: Colors.red,
                                  value: _switchValueApp,
                                  onChanged: (value) {
                                    setState(() {
                                      _switchValueApp = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'MORE',
                              style: subtitleStyle,
                            ),
                          ),
                          const Divider(
                            height: 1,
                            thickness: 2,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Language',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                const FaIcon(FontAwesomeIcons.chevronRight)
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Terms and condition',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                const FaIcon(FontAwesomeIcons.chevronRight)
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'FAQs',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                const FaIcon(FontAwesomeIcons.chevronRight)
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context
                                  .read<AuthService>()
                                  .signOut(changeNotifier);
                              // changeNotifier.setPushedNotification(false);
                              Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(builder: (context) {
                                return const AuthWrapper();
                              }), (route) => false);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Logout',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                const FaIcon(FontAwesomeIcons.chevronRight)
                              ],
                            ),
                          )
                        ],
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
