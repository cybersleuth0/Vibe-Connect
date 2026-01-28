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
      print("Creating user in Auth...");
      final userCred = await firebaseAuth.createUserWithEmailAndPassword(email: user.email!, password: password);

      if (userCred.user != null) {
        print("User created in Auth: ${userCred.user?.uid}");
        user.userId = userCred.user!.uid;
        user.createdAt = DateTime.now().toIso8601String();

        print("Saving user to Firestore...");
        await firebaseFirestore.collection(COLLECTION_USERS).doc(userCred.user!.uid).set(user.toDoc());
        print("User saved to Firestore");

        return true; // Return true on success
      } else {
        print("User creation returned null");
        return false; // Return false if user credential is null
      }
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: $e");
      rethrow;
    } catch (e) {
      print("General Exception: $e");
      rethrow;
    }
  }

  // Update User Data
  Future<void> updateUserData(Map<String, dynamic> data, String userId) async {
    try {
      await firebaseFirestore.collection(COLLECTION_USERS).doc(userId).update(data);
    } catch (e) {
      rethrow;
    }
  }

  // User Login
  Future<UserCredential> loginUser({required String email, required String password}) async {
    try {
      return await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // User Logout
  Future<void> logoutUser() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  // Fetch all users from firebase

  static Future<QuerySnapshot<Map<String, dynamic>>> getAllUsers() async {
    return await firebaseFirestore.collection(COLLECTION_USERS).get();
  }
}
