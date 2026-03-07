import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Sign Up & Create Profile
  Future<String?> signUp(String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        // Email Verification Enforcement
        await user.sendEmailVerification();

        // Create Firestore Document
        await _db.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'fullName': name,
          'email': email,
          'verified': false,
        });
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Login with Verification Check
  Future<String?> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!result.user!.emailVerified) {
        await _auth.signOut();
        return "Please verify your email first.";
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Logout
  Future<void> logout() async => await _auth.signOut();
}
