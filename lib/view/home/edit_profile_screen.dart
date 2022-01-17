import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/src/provider.dart';
import 'package:smart_engineering_lab/constant/color_constant.dart';
import 'package:smart_engineering_lab/enum/view_state_enum.dart';
import 'package:smart_engineering_lab/provider/root_change_notifier.dart';
import 'package:smart_engineering_lab/services/database_services.dart';
import 'package:smart_engineering_lab/widget/login_button_widget.dart';

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String id;
  final String role;
  final String email;
  const EditProfileScreen(
      {Key? key,
      required this.name,
      required this.id,
      required this.role,
      required this.email})
      : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final emailController = TextEditingController();
  final roleController = TextEditingController();
  @override
  void initState() {
    super.initState();
    nameController.text = widget.name;
    idController.text = widget.id;
    emailController.text = widget.email;
    roleController.text = widget.role;
  }

  @override
  Widget build(BuildContext context) {
    final changeNotifier = context.watch<RootChangeNotifier>();
    final firebaseUser = context.watch<User>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.chevronLeft),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ]),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Text(
                  'Settings',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                ),
              ),
              buildTextField('Name', nameController, true),
              buildTextField('Student Id', idController, false),
              buildTextField('Email', emailController, false),
              buildTextField('User Role', roleController, false),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: LoginButtonWidget(
                    onPressed: () {
                      DatabaseService(uid: firebaseUser.uid)
                          .updateUserData(data: {'name': nameController.text});
                    },
                    child: changeNotifier.getViewState == ViewState.BUSY
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            'Submit',
                            style: subtitleStyle2,
                          )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText,
      TextEditingController editingController, bool isEnable) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 8.0,
            ),
            child: Text(
              labelText,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          TextFormField(
            enabled: isEnable,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '*This field is required';
              }
              return null;
            },
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
}
