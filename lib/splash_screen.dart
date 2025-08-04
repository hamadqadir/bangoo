import 'package:flutter/material.dart';
import 'dart:async';
import 'audio_list_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => FolderListScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image.asset(
          //   'assets/logo.png', // Ensure you have a logo image in your assets
          //   width: 100,
          //   height: 100,
          // ),
          Text("🎵 My Audio Player", style: TextStyle(fontSize: 24)),
        ],
      ),
    );
  }
}
