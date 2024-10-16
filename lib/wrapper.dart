import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_round/home_page.dart';
import 'package:task_round/sign_up_page.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          // Navigate to HomePage if the user is signed in, else to LoginPage
          return user == null ? const SignUpPage() : const HomePage();
        }
        return const Center(child: CircularProgressIndicator()); // Loading indicator while checking auth state
      },
    );
  }
}