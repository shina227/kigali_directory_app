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
        // Send verification email
        await user.sendEmailVerification();

        // Create Firestore profile
        await _db.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'fullName': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });

        await user.updateDisplayName(name);
        // Sign out immediately — force them to verify first
        await _auth.signOut();
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Login — enforces email verification
  Future<String?> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      // Block unverified users
      if (user != null && !user.emailVerified) {
        await _auth.signOut();
        return "Please verify your email before logging in. Check your inbox.";
      }

      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return "No account found with this email.";
        case 'wrong-password':
          return "Incorrect password.";
        case 'invalid-credential':
          return "Invalid email or password.";
        case 'too-many-requests':
          return "Too many attempts. Try again later.";
        default:
          return "Login failed. Please try again.";
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Logout
  Future<void> logout() async => await _auth.signOut();

  // Forgot Password
  Future<String?> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return "No user found with this email.";
        case 'invalid-email':
          return "The email address is not valid.";
        default:
          return "An error occurred. Please try again.";
      }
    } catch (e) {
      return e.toString();
    }
  }
}