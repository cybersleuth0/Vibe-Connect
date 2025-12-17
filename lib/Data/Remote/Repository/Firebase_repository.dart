import 'package:firebase_auth/firebase_auth.dart';

// Provider registration with Firebase
Future<bool> registerUser({required String email, required String password}) async {
  try {
    final FirebaseAuth auth = FirebaseAuth.instance;
    // Register with Firebase only
    await auth.createUserWithEmailAndPassword(email: email, password: password);

    return true;
  } on FirebaseAuthException {
    rethrow;
  } catch (e) {
    rethrow;
  }
}
