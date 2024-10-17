import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_round/get_started_page.dart';
import 'package:task_round/home_page.dart';
import 'dart:async';

import 'package:task_round/wrapper.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller!, curve: Curves.easeInOut);
    _controller!.forward();

    Timer(const Duration(seconds: 4), () {
      if(FirebaseAuth.instance.currentUser != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const GetStartedScreen()));
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC03B7C),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _animation!,
              child: Image.asset(
                'assets/app_logo.png',
                width: 150,
                height: 150,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Google Developer Groups',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      )
    );
  }
}
