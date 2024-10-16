import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential?> loginWithGoogle() async {
    try {
      // Sign out from the previous Google account to force account selection
      await _googleSignIn.signOut();

      // Start the Google sign-in process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Check if the sign-in was canceled by the user
      if (googleUser == null) {
        log("Google sign-in was canceled");
        return null;
      }

      // Obtain authentication details from the Google sign-in request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a credential using the authentication details
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // Sign in to Firebase with the Google credential
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      log('Google sign-in successful: ${userCredential.user?.email}');
      return userCredential;
    } catch (e) {
      // Log any errors that occur during sign-in
      log('Google sign-in failed: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();  // Sign out from Firebase
      await _googleSignIn.signOut();  // Sign out from Google
      log("Signed Out Successfully");
    } catch (e) {
      log("Sign-out failed: $e");
    }
  }
}