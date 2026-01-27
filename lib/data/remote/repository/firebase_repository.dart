import "package:chat_app/data/models/user_model.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";

class FirebaseRepository {
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  static const String COLLECTION_USERS = "users";
  static const String COLLECTION_CHATROOM = "chatroom";

  // User registration

  Future<bool> registerUser({required UserModel user, required String password}) async {
    try {
      final userCred = await firebaseAuth.createUserWithEmailAndPassword(email: user.email!, password: password);

      if (userCred.user != null) {
        await firebaseFirestore.collection(COLLECTION_USERS).doc(userCred.user!.uid).set(user.toDoc());
        return true; // Return true on success
      } else {
        return false; // Return false if user credential is null
      }
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
