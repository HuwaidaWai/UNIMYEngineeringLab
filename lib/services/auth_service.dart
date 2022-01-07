import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_engineering_lab/enum/view_state_enum.dart';
import 'package:smart_engineering_lab/provider/root_change_notifier.dart';

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
}
