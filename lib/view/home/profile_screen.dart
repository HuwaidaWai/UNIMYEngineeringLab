import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_engineering_lab/enum/view_state_enum.dart';
import 'package:smart_engineering_lab/main.dart';
import 'package:smart_engineering_lab/provider/root_change_notifier.dart';
import 'package:smart_engineering_lab/services/auth_service.dart';
import 'package:smart_engineering_lab/widget/login_button_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final changeNotifier = context.watch<RootChangeNotifier>();
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 36.0),
        child: Column(
          children: [
            const Center(
              child: Text('HOME SCREEN'),
            ),
            LoginButtonWidget(
                onPressed: () {
                  context.read<AuthService>().signOut(changeNotifier);
                  changeNotifier.setPushedNotification(false);
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) {
                    return const AuthWrapper();
                  }), (route) => false);
                },
                child: changeNotifier.getViewState == ViewState.BUSY
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text('Logout'))
          ],
        ),
      ),
    );
  }
}
