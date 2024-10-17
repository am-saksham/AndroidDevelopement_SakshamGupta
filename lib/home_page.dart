// lib/home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_round/login_page.dart';
import 'package:task_round/auth_service.dart'; // Import the AuthService

class HomePage extends StatelessWidget {
  const HomePage();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                // Create an instance of AuthService
                final AuthService authService = AuthService();

                // Call signOut method
                await authService.signOut();

                // Navigate to LoginPage after signing out
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage(clearFields: true)),
                      (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome!',
                style: GoogleFonts.inter(fontSize: 24),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to another page or perform an action
                },
                child: const Text('Go to Events'),
              ),
              // Add more buttons or features as needed
            ],
          ),
        ),
      ),
    );
  }
}