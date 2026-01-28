import "package:firebase_auth/firebase_auth.dart";

class AuthExceptionHandler {
  static String handleException(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case "invalid-credential":
        case "user-not-found":
        case "wrong-password":
          return "Invalid email or password.";
        case "email-already-in-use":
          return "This email is already registered.";
        case "user-disabled":
          return "This user account has been disabled.";
        case "operation-not-allowed":
          return "Operation not allowed. Please contact support.";
        case "invalid-email":
          return "Please enter a valid email address.";
        case "weak-password":
          return "The password provided is too weak.";
        case "network-request-failed":
          return "Network error. Please check your connection.";
        case "too-many-requests":
          return "Too many attempts. Please try again later.";
        default:
          return "Authentication failed. Please try again.";
      }
    }
    return "An error occurred. Please try again.";
  }
}
