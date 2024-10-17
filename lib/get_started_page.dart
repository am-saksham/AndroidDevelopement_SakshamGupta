import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_round/sign_up_page.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Stack(
        children: [
          // Center the GIF in the middle of the screen
          Center(
            child: Image.asset(
              'assets/Android.gif', // Replace this with the path to your GIF
              width: 200,
              height: 200,
            ).animate().fadeIn(duration: 2.seconds), // Add animation to the GIF
          ),
          // Positioned button at the bottom center
          Positioned(
            bottom: 30.0, // Distance from the bottom of the screen
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0), // Add horizontal padding
              child: SizedBox(
                width: 366,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC03B7C), // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17.0), // Rounded edges
                    ),
                  ),
                  onPressed: () {
                    // Action when button is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpPage()),
                    );
                  },
                  child: Text(
                    'Get Started',
                    style: GoogleFonts.inter(
                      color: Colors.white, // Text color
                      fontSize: 20.0, // Text size
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}