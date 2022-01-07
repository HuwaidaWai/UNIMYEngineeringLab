import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_engineering_lab/enum/view_state_enum.dart';
import 'package:smart_engineering_lab/provider/root_change_notifier.dart';
import 'package:smart_engineering_lab/services/database_services.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  AuthService(this._firebaseAuth);
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  Future signIn({
    required String email,
    required String password,
    required RootChangeNotifier changeNotifier,
  }) async {
    try {
      changeNotifier.setState(ViewState.BUSY);
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      changeNotifier.setState(ViewState.IDLE);
      return "Signed In";
    } on FirebaseAuthException catch (e) {
      changeNotifier.setState(ViewState.IDLE);
      throw e.message!;
    }
  }

  Future signUp({
    required String email,
    required String password,
    required String displayName,
    required String role,
    required RootChangeNotifier changeNotifier,
  }) async {
    try {
      changeNotifier.setState(ViewState.BUSY);
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      // final task = await StorageService.uploadFile(
      //         destination: data['destination'], file: data['file'])
      //     .whenComplete(() {});
      // profilePicUrl = await task.ref.getDownloadURL();

      await DatabaseService(userCredential.user!.uid)
          .createUserData(email: email, name: displayName, role: role);

      changeNotifier.setState(ViewState.IDLE);
      return "Signed Up";
    } on FirebaseAuthException catch (e) {
      changeNotifier.setState(ViewState.IDLE);
      throw e.message!;
    }
  }
}
